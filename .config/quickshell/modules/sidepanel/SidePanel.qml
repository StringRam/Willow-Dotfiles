pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services
import qs.modules.sidepanel.components as Side

Item {
  id: root

  property int inset: 18

  // ---- estado local ----
  property date currentMonth: new Date()
  property date selectedDate: new Date()
  property var selectedEvent: null

  function addMonths(baseDate, delta) {
    const d = new Date(baseDate)
    d.setDate(1)
    d.setMonth(d.getMonth() + delta)
    return d
  }

  readonly property int _pad: Appearance.padding.normal + root.inset

  implicitWidth: mainCol.implicitWidth + _pad * 2
  implicitHeight: mainCol.implicitHeight + _pad * 2

  Connections {
    target: SidepanelState

    function onTabIndexChanged() {
      titleClip.slideTo(SidepanelState.tabLabel(), SidepanelState.slideDir)

      // al volver a Calendar, limpiamos el evento seleccionado
      if (SidepanelState.tabIndex === 0) {
        root.selectedEvent = null
      }
    }
  }

  ColumnLayout {
    id: mainCol
    anchors.fill: parent
    anchors.margins: root._pad
    spacing: Appearance.spacing.normal

    // ---- Header: título animado + botón ">" ----
    RowLayout {
      Layout.fillWidth: true
      spacing: Appearance.spacing.small

      Item {
        id: titleClip
        Layout.fillWidth: true
        height: 26
        clip: true

        property string incomingText: ""

        Text {
          id: titleA
          anchors.verticalCenter: parent.verticalCenter
          x: 0
          text: SidepanelState.tabLabel()
          color: Colours.palette.m3onSurface
          font.pixelSize: 16
          font.bold: true
        }

        Text {
          id: titleB
          anchors.verticalCenter: parent.verticalCenter
          x: 0
          opacity: 0
          text: titleClip.incomingText
          color: Colours.palette.m3onSurface
          font.pixelSize: 16
          font.bold: true
        }

        function slideTo(newText, dir) {
          const w = titleClip.width
          titleClip.incomingText = newText

          titleB.x = dir > 0 ? w : -w
          titleB.opacity = 1

          animA.from = 0
          animA.to = dir > 0 ? -w : w

          animB.from = titleB.x
          animB.to = 0

          fadeA.from = 1
          fadeA.to = 0

          seq.restart()
        }

        SequentialAnimation {
          id: seq
          running: false

          ParallelAnimation {
            PropertyAnimation {
              id: animA
              target: titleA
              property: "x"
              duration: 180
              easing.type: Easing.OutCubic
            }
            PropertyAnimation {
              id: animB
              target: titleB
              property: "x"
              duration: 180
              easing.type: Easing.OutCubic
            }
            PropertyAnimation {
              id: fadeA
              target: titleA
              property: "opacity"
              duration: 140
            }
          }

          ScriptAction {
            script: {
              titleA.text = titleClip.incomingText
              titleA.x = 0
              titleA.opacity = 1
              titleB.opacity = 0
              titleB.x = 0
            }
          }
        }
      }

      Button {
        text: ">"
        onClicked: SidepanelState.toggle()
      }
    }

    // ---- Card principal ----
    StyledRect {
      id: mainCard
      Layout.fillWidth: true

      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      border.width: 1
      border.color: Colours.palette.m3outlineVariant

      property int _innerPad: Appearance.padding.large
      implicitHeight: mainWrapper.implicitHeight + _innerPad * 2

      ColumnLayout {
        id: mainWrapper
        x: mainCard._innerPad
        y: mainCard._innerPad
        width: parent.width - mainCard._innerPad * 2
        spacing: Appearance.spacing.small

        Side.CalendarHeader {
          Layout.fillWidth: true
          visible: SidepanelState.tabIndex === 0
          monthDate: root.currentMonth
          onPrev: root.currentMonth = root.addMonths(root.currentMonth, -1)
          onNext: root.currentMonth = root.addMonths(root.currentMonth, +1)
        }

        Loader {
          Layout.fillWidth: true
          sourceComponent: SidepanelState.tabIndex === 1 ? scheduleComp : calendarComp
        }

        Component {
          id: calendarComp

          Side.MonthGrid {
            width: mainWrapper.width
            monthDate: root.currentMonth
            selectedDate: root.selectedDate
            onSelectDate: (d) => root.selectedDate = d
          }
        }

        Component {
          id: scheduleComp

          Side.WeekSchedule {
            width: mainWrapper.width
            height: 360
            selectedDate: root.selectedDate
            onSelectDate: (d) => root.selectedDate = d
            onSelectEvent: (ev) => root.selectedEvent = ev
          }
        }
      }
    }

    // resorte
    Item { Layout.fillHeight: true }

    // ---- Card inferior contextual ----
    StyledRect {
      id: bottomCard
      Layout.fillWidth: true

      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      border.width: 1
      border.color: Colours.palette.m3outlineVariant

      property int _innerPad: Appearance.padding.large
      implicitHeight: bottomWrapper.implicitHeight + _innerPad * 2

      ColumnLayout {
        id: bottomWrapper
        x: bottomCard._innerPad
        y: bottomCard._innerPad
        width: parent.width - bottomCard._innerPad * 2
        spacing: Appearance.spacing.small

        Loader {
          Layout.fillWidth: true
          sourceComponent: SidepanelState.tabIndex === 1 ? eventDetailsComp : agendaComp
        }

        Component {
          id: agendaComp

          ColumnLayout {
            Layout.fillWidth: true
            spacing: Appearance.spacing.small

            Side.AgendaHeader {
              Layout.fillWidth: true
              date: root.selectedDate
            }

            Side.AgendaList {
              Layout.fillWidth: true
              date: root.selectedDate
              maxVisible: 4
            }
          }
        }

        Component {
          id: eventDetailsComp

          Side.EventDetailsCard {
            Layout.fillWidth: true
            event: root.selectedEvent
          }
        }
      }
    }
  }
}
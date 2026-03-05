pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services
import qs.services as S
import qs.modules.sidepanel.components as Side

Item {
  id: root

  property int inset: 18

  // ---- calendar state (local, fase 1) ----
  property date currentMonth: new Date()
  property date selectedDate: new Date()

  function addMonths(baseDate, delta) {
    const d = new Date(baseDate);
    d.setDate(1);
    d.setMonth(d.getMonth() + delta);
    return d;
  }

  readonly property int _pad: Appearance.padding.normal + root.inset

  implicitWidth: mainCol.implicitWidth + _pad * 2
  implicitHeight: mainCol.implicitHeight + _pad * 2

  ColumnLayout {
    id: mainCol
    anchors.fill: parent
    anchors.margins: root._pad
    spacing: Appearance.spacing.normal

    // ---- Tabs (reemplaza el título "Sidepanel") ----
    RowLayout {
      Layout.fillWidth: true
      spacing: Appearance.spacing.small

      Item {
        id: titleClip
        Layout.fillWidth: true
        height: 26
        clip: true

        // título actual y el siguiente para animar el swap
        property string currentText: S.SidepanelState.tabLabel()
        property string incomingText: ""

        // “capas” de texto
        Text {
          id: titleA
          anchors.verticalCenter: parent.verticalCenter
          x: 0
          text: titleClip.currentText
          color: "#e5e5e5"
          font.pixelSize: 16
          font.bold: true
        }

        Text {
          id: titleB
          anchors.verticalCenter: parent.verticalCenter
          x: 0
          opacity: 0
          text: titleClip.incomingText
          color: "#e5e5e5"
          font.pixelSize: 16
          font.bold: true
        }

        function slideTo(newText, dir) {
          // dir: +1 => entra desde derecha, -1 => entra desde izquierda
          const w = titleClip.width
          titleClip.incomingText = newText

          // posicion inicial del incoming fuera de pantalla
          titleB.x = dir > 0 ? w : -w
          titleB.opacity = 1

          // animar: A sale, B entra
          animA.from = 0
          animA.to   = dir > 0 ? -w : w

          animB.from = titleB.x
          animB.to   = 0

          fadeA.from = 1
          fadeA.to   = 0

          fadeB.from = 1
          fadeB.to   = 1

          seq.restart()
        }

        SequentialAnimation {
          id: seq
          running: false

          ParallelAnimation {
            PropertyAnimation { id: animA; target: titleA; property: "x"; duration: 180; easing.type: Easing.OutCubic }
            PropertyAnimation { id: animB; target: titleB; property: "x"; duration: 180; easing.type: Easing.OutCubic }
            PropertyAnimation { id: fadeA; target: titleA; property: "opacity"; duration: 140 }
          }

          ScriptAction {
            script: {
              // swap: B pasa a ser A
              titleA.text = titleClip.incomingText
              titleA.x = 0
              titleA.opacity = 1
              titleB.opacity = 0
              titleB.x = 0
            }
          }
        }

        // si el estado cambia desde afuera, sincronizamos
        Connections {
          target: S.SidepanelState
          function onTabIndexChanged() {
            titleClip.slideTo(S.SidepanelState.tabLabel(), S.SidepanelState.slideDir)
          }
        }
      }

      Button {
        text: ">"
        onClicked: S.SidepanelState.toggle()
      }
    }

    // ---- Card principal: cambia según tab ----
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

        // Header del mes SOLO cuando estamos en Calendar
        Side.CalendarHeader {
          Layout.fillWidth: true
          visible: S.SidepanelState.tab === "calendar"
          monthDate: root.currentMonth
          onPrev: root.currentMonth = root.addMonths(root.currentMonth, -1)
          onNext: root.currentMonth = root.addMonths(root.currentMonth, +1)
        }

        // Vista según pestaña
        Loader {
          Layout.fillWidth: true
          sourceComponent: (S.SidepanelState.tabIndex === 1) ? scheduleComp : calendarComp
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
            // Por ahora: alto fijo funcional (lo refinamos con tu layout final)
            height: 360
            selectedDate: root.selectedDate
          }
        }
      }
    }

    // resorte para empujar la agenda al fondo
    Item { Layout.fillHeight: true }

    // ---- agenda card (anclada abajo) ----
    StyledRect {
      id: agendaCard
      Layout.fillWidth: true

      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      border.width: 1
      border.color: Colours.palette.m3outlineVariant

      property int _innerPad: Appearance.padding.large
      implicitHeight: agendaWrapper.implicitHeight + _innerPad * 2

      ColumnLayout {
        id: agendaWrapper
        x: agendaCard._innerPad
        y: agendaCard._innerPad
        width: parent.width - agendaCard._innerPad * 2
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
  }
}
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services

Item {
  id: root
  required property date selectedDate

  signal selectDate(date d)
  signal selectEvent(var ev)

  function startOfWeek(d) {
    const x = new Date(d.getFullYear(), d.getMonth(), d.getDate())
    const js = x.getDay()
    const mondayOffset = (js + 6) % 7
    x.setDate(x.getDate() - mondayOffset)
    return x
  }

  function sameDay(a, b) {
    return a.getFullYear() === b.getFullYear()
        && a.getMonth() === b.getMonth()
        && a.getDate() === b.getDate()
  }

  readonly property date weekStart: startOfWeek(selectedDate)

  property int startHour: 6
  property int hourCount: 16
  readonly property int _gutterW: 44
  readonly property int _rowH: 34
  readonly property int _gap: Appearance.spacing.small

  ColumnLayout {
    anchors.fill: parent
    spacing: Appearance.spacing.small

    // Header días
    RowLayout {
      Layout.fillWidth: true
      spacing: root._gap

      Item { width: root._gutterW }

      Repeater {
        model: 7

        delegate: StyledRect {
          Layout.fillWidth: true
          implicitHeight: 28
          radius: Appearance.rounding.normal

          readonly property date d: new Date(
            root.weekStart.getFullYear(),
            root.weekStart.getMonth(),
            root.weekStart.getDate() + index
          )

          readonly property bool isSelectedDay: root.sameDay(d, root.selectedDate)

          color: isSelectedDay
            ? Colours.palette.m3secondaryContainer
            : Colours.palette.m3surfaceContainerHighest

          border.width: 1
          border.color: Colours.palette.m3outlineVariant

          StyledText {
            anchors.centerIn: parent
            text: Qt.formatDate(d, "ddd d")
            color: isSelectedDay
              ? Colours.palette.m3onSecondaryContainer
              : Colours.palette.m3onSurface
          }

          MouseArea {
            anchors.fill: parent
            onClicked: root.selectDate(d)
          }
        }
      }
    }

    // Grilla horaria
    Flickable {
      Layout.fillWidth: true
      Layout.fillHeight: true
      clip: true
      contentHeight: hoursCol.implicitHeight

      Column {
        id: hoursCol
        width: parent.width
        spacing: root._gap

        Repeater {
          model: root.hourCount

          delegate: RowLayout {
            Layout.fillWidth: true
            spacing: root._gap

            readonly property int hour: index + root.startHour

            StyledText {
              width: root._gutterW
              text: hour.toString().padStart(2, "0") + ":00"
              color: Qt.rgba(
                Colours.palette.m3onSurface.r,
                Colours.palette.m3onSurface.g,
                Colours.palette.m3onSurface.b,
                0.65
              )
            }

            Repeater {
              model: 7

              delegate: StyledRect {
                Layout.fillWidth: true
                implicitHeight: root._rowH
                radius: Appearance.rounding.normal
                color: Qt.rgba(1, 1, 1, 0.02)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.06)

                readonly property date dayDate: new Date(
                  root.weekStart.getFullYear(),
                  root.weekStart.getMonth(),
                  root.weekStart.getDate() + index
                )

                MouseArea {
                  anchors.fill: parent
                  onClicked: {
                    const h = parent.parent.hour
                    const start = new Date(
                      parent.dayDate.getFullYear(),
                      parent.dayDate.getMonth(),
                      parent.dayDate.getDate(),
                      h, 0, 0
                    )
                    const end = new Date(
                      parent.dayDate.getFullYear(),
                      parent.dayDate.getMonth(),
                      parent.dayDate.getDate(),
                      h + 1, 0, 0
                    )

                    root.selectEvent({
                      summary: "Bloque " + h.toString().padStart(2, "0") + ":00",
                      start: start,
                      end: end,
                      day: parent.dayDate
                    })
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
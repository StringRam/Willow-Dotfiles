pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services

Item {
  id: root
  required property date selectedDate

  // --- helpers de fecha ---
  function startOfWeek(d) {
    const x = new Date(d.getFullYear(), d.getMonth(), d.getDate());
    const js = x.getDay();             // 0=Dom..6=Sáb
    const mondayOffset = (js + 6) % 7; // Dom->6, Lun->0, ...
    x.setDate(x.getDate() - mondayOffset);
    return x;
  }

  readonly property date weekStart: startOfWeek(selectedDate)

  // configurable
  property int startHour: 6
  property int hourCount: 16 // 6..21
  readonly property int _gutterW: 44
  readonly property int _rowH: 34
  readonly property int _gap: Appearance.spacing.small

  ColumnLayout {
    anchors.fill: parent
    spacing: Appearance.spacing.small

    // Header: días
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
          color: Colours.palette.m3surfaceContainerHighest
          border.width: 1
          border.color: Colours.palette.m3outlineVariant

          readonly property date d: new Date(
            root.weekStart.getFullYear(),
            root.weekStart.getMonth(),
            root.weekStart.getDate() + index
          )

          StyledText {
            anchors.centerIn: parent
            text: Qt.formatDate(d, "ddd d")
          }
        }
      }
    }

    // Body: horas con scroll
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

            // hora
            StyledText {
              width: root._gutterW
              text: (index + root.startHour).toString().padStart(2, "0") + ":00"
              color: Qt.rgba(
                Colours.palette.m3onSurface.r,
                Colours.palette.m3onSurface.g,
                Colours.palette.m3onSurface.b,
                0.65
              )
            }

            // celdas 7 días
            Repeater {
              model: 7
              delegate: StyledRect {
                Layout.fillWidth: true
                implicitHeight: root._rowH
                radius: Appearance.rounding.normal
                color: Qt.rgba(1, 1, 1, 0.02)
                border.width: 1
                border.color: Qt.rgba(1, 1, 1, 0.06)
              }
            }
          }
        }
      }
    }
  }
}
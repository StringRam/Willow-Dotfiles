import qs.components
import qs.config
import qs.services
import Quickshell
import QtQuick
import QtQuick.Layouts

import "../../../components/controls" as Controls

GridLayout {
  id: root

  // Layout similar a Caelestia (cards)
  rowSpacing: Appearance.spacing.normal
  columnSpacing: Appearance.spacing.normal

  implicitWidth: 520
  implicitHeight: 320

  // Weather card (izq arriba)
  StyledRect {
    Layout.row: 0
    Layout.columnSpan: 2
    Layout.preferredWidth: Config.dashboard.sizes.weatherWidth
    Layout.fillHeight: true

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Weather card"
    }
  }

  // User card (arriba centro/derecha)
  StyledRect {
    Layout.column: 2
    Layout.columnSpan: 3
    Layout.preferredWidth: 260
    Layout.preferredHeight: 140

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainerHigh

    StyledText {
      anchors.centerIn: parent
      text: "User card"
    }
  }

  // DateTime (abajo izq)
  StyledRect {
    Layout.row: 1
    Layout.preferredWidth: Config.dashboard.sizes.dateTimeWidth
    Layout.fillHeight: true

    radius: Appearance.rounding.normal
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Date/Time"
    }
  }

  // Calendar (abajo centro)
  StyledRect {
    Layout.row: 1
    Layout.column: 1
    Layout.columnSpan: 3
    Layout.fillWidth: true
    Layout.preferredHeight: 140

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Calendar"
    }
  }

  // ✅ Resources -> Session actions (abajo derecha)
  StyledRect {
    Layout.row: 1
    Layout.column: 4
    Layout.preferredWidth: 140
    Layout.fillHeight: true

    radius: Appearance.rounding.normal
    color: Colours.palette.m3surfaceContainer

    ColumnLayout {
      anchors.fill: parent
      anchors.margins: Appearance.padding.normal
      spacing: Appearance.spacing.small

      StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: "Session"
      }

      // 2x2 grid de botones
      GridLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        columns: 2
        rowSpacing: Appearance.spacing.small
        columnSpacing: Appearance.spacing.small

        // LOCK
        Controls.IconButton {
          Layout.alignment: Qt.AlignHCenter
          type: Controls.IconButton.Tonal
          icon: "lock"
          onClicked: Quickshell.execDetached(["sh", "-c", "hyprlock"])
        }

        // LOGOUT
        Controls.IconButton {
          Layout.alignment: Qt.AlignHCenter
          type: Controls.IconButton.Tonal
          icon: "logout"
          onClicked: Quickshell.execDetached(["sh", "-c", "hyprctl dispatch exit"])
        }

        // REBOOT
        Controls.IconButton {
          Layout.alignment: Qt.AlignHCenter
          type: Controls.IconButton.Tonal
          icon: "restart_alt"
          onClicked: Quickshell.execDetached(["sh", "-c", "systemctl reboot"])
        }

        // POWER OFF
        Controls.IconButton {
          Layout.alignment: Qt.AlignHCenter
          type: Controls.IconButton.Tonal
          icon: "power_settings_new"
          onClicked: Quickshell.execDetached(["sh", "-c", "systemctl poweroff"])
        }
      }
    }
  }

  // Media (derecha full height)
  StyledRect {
    Layout.row: 0
    Layout.column: 5
    Layout.rowSpan: 2
    Layout.preferredWidth: 180
    Layout.fillHeight: true

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainerHigh

    StyledText {
      anchors.centerIn: parent
      text: "Media"
    }
  }
}
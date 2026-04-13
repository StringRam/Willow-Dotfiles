import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.components
import qs.services

Item {
  id: root

  implicitWidth: 720
  implicitHeight: 240

  RowLayout {
    anchors.fill: parent
    spacing: Appearance.spacing.normal

    // -------- UserCard (izquierda) --------
    StyledRect {
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.minimumWidth: 560
      Layout.minimumHeight: 220

      // ✅ más redondeado (si xlarge no existe, usa una alternativa segura)
      radius: (Appearance.rounding.xlarge !== undefined)
                ? Appearance.rounding.xlarge
                : Math.max(Appearance.rounding.large, 22)

      color: Colours.palette.m3surfaceContainer

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.spacing.small

        StyledText { text: "User"; font.pixelSize: 16 }
        StyledText { text: "Session length: —" }
        StyledText { text: "Uptime: —" }
        StyledText { text: "Details: —" }

        Item { Layout.fillHeight: true }
      }
    }

    // -------- Acciones sesión (derecha, icon-only, con fondo individual) --------
    Item {
      Layout.preferredWidth: 76
      Layout.fillHeight: true

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.spacing.small

        component IconAction: Item {
          id: btn
          required property string iconGlyph
          property string command: ""
          signal activated()

          implicitWidth: 52
          implicitHeight: 52

          clip: true

          StyledRect {
            id: bg
            anchors.fill: parent

            radius: Appearance.rounding.full

            color: Qt.alpha(Colours.palette.m3surfaceContainerHigh, mouse.pressed ? 0.85 : 1.0)

            border.width: 1
            border.color: Qt.alpha(Colours.palette.m3outlineVariant, mouse.containsMouse ? 0.9 : 0.55)
          }

          Text {
            anchors.centerIn: parent
            text: btn.iconGlyph
            font.family: "Material Symbols Rounded"
            font.pixelSize: 26
            color: Colours.palette.m3onSurface
          }

          MouseArea {
            id: mouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
              btn.activated()
              if (btn.command !== "") Quickshell.execDetached(["sh", "-c", btn.command])
            }
          }
        }

        IconAction { iconGlyph: "󰌾"; command: "hyprlock" }
        IconAction { iconGlyph: "󰍃"; command: "hyprctl dispatch exit" }
        IconAction { iconGlyph: "󰜉"; command: "systemctl reboot" }
        IconAction { iconGlyph: "󰐥"; command: "systemctl poweroff" }
        IconAction {
          // Material Symbols: wallpaper (U+E1BC)
          iconGlyph: "\ue1bc"
          onActivated: Visibility.wallpaperPickerOpen = true
        }

        Item { Layout.fillHeight: true }
      }
    }
  }
}
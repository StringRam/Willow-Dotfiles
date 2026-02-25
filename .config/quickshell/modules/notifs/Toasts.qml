import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components.containers

Scope {
  Variants {
    model: Quickshell.screens

    StyledWindow {
      required property var modelData
      screen: modelData
      name: "toasts"

      visible: Notifs.toasts.length > 0

      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      anchors { top: true; bottom: true; left: true; right: true }

      Item {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16

        Column {
          spacing: 10

          Repeater {
            model: Notifs.toasts

            delegate: Rectangle {
              required property var modelData

              width: 320
              radius: 14
              color: "#161616"
              border.width: 1
              border.color: "#2a2a2a"
              opacity: 0.98

              Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 6

                Text {
                  text: modelData.summary || "(sin título)"
                  color: "#e5e5e5"
                  font.bold: true
                  wrapMode: Text.Wrap
                }

                Text {
                  text: modelData.body || ""
                  color: "#bdbdbd"
                  wrapMode: Text.Wrap
                  visible: (modelData.body || "") !== ""
                }

                Row {
                  spacing: 8
                  Item { width: 1; height: 1 } // spacer placeholder si querés
                }
              }

              // Auto-dismiss
              Timer {
                interval: 4500
                running: true
                repeat: false
                onTriggered: Notifs.dropToast(modelData.key)
              }

              MouseArea {
                anchors.fill: parent
                onClicked: Notifs.dropToast(modelData.key)
              }
            }
          }
        }
      }
    }
  }
}
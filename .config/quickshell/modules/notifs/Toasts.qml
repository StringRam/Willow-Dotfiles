import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.services
import qs.components.containers
import qs.components.animations

Scope {
  Variants {
    model: Quickshell.screens

    OverlayWindow {
      required property var modelData
      screen: modelData
      name: "toasts"

      // visible solo si hay toasts
      visible: Notifs.toasts.length > 0

      // No robar teclado
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      Item {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16

        Column {
          id: stack
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

              // estado inicial para animación
              y: -22
              opacity: 0

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
              }

              FallIn {
                id: fall
                target: parent
                fromY: -22
                toY: 0
                duration: 180
              }

              Component.onCompleted: fall.start()

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
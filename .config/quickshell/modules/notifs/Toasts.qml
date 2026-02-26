import Quickshell
import Quickshell.Wayland
import QtQuick
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

      visible: Notifs.toasts.length > 0
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      Item {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 12
        y: 4

        Column {
          spacing: 10

          Repeater {
            model: Notifs.toasts

            delegate: Rectangle {
              id: toast
              required property var modelData

              width: 320
              radius: 14
              color: "#161616"
              border.width: 1
              border.color: "#2a2a2a"

              // ✅ altura real (la clave)
              implicitHeight: content.implicitHeight + 24

              // Estado inicial “caída”
              y: -22
              opacity: 1

              Column {
                id: content
                x: 12
                y: 12
                width: toast.width - 24
                spacing: 6

                Text {
                  text: modelData.summary || "(sin título)"
                  color: "#e5e5e5"
                  font.bold: true
                  wrapMode: Text.Wrap
                  width: parent.width
                }

                Text {
                  text: modelData.body || ""
                  color: "#bdbdbd"
                  wrapMode: Text.Wrap
                  width: parent.width
                  visible: (modelData.body || "") !== ""
                }
              }

              FallIn { id: fall; target: toast; fromY: -22; toY: 0; duration: 180 }
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
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

      visible: Notifs.toastsAllowed && Notifs.toasts.length > 0
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      mask: Region { item: hitbox }

      Item {
        id: hitbox
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 12
        y: 4

        width: toastColumn.implicitWidth
        height: toastColumn.implicitHeight

        Column {
          id: toastColumn
          spacing: 10

          Repeater {
            model: Notifs.toasts

            delegate: Rectangle {
              id: toast
              required property var modelData

              width: 320
              radius: 14
              color: Colours.palette.m3background
              border.width: 1
              border.color: Colours.palette.m3outline

              implicitHeight: content.implicitHeight + 24

              y: -22
              opacity: 0

              Column {
                id: content
                x: 12
                y: 12
                width: toast.width - 24
                spacing: 6

                Text {
                  text: toast.modelData.summary || "(sin título)"
                  color: Colours.palette.m3onSurface
                  font.bold: true
                  wrapMode: Text.Wrap
                  width: parent.width
                }

                Text {
                  text: toast.modelData.body || ""
                  color: Colours.palette.m3onSurfaceVariant
                  wrapMode: Text.Wrap
                  width: parent.width
                  visible: (toast.modelData.body || "") !== ""
                }
              }

              SequentialAnimation {
                id: anim
                running: true

                ParallelAnimation {
                  NumberAnimation {
                    target: toast
                    property: "y"
                    from: -22
                    to: 0
                    duration: 180
                    easing.type: Easing.OutCubic
                  }
                  NumberAnimation {
                    target: toast
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 120
                    easing.type: Easing.OutQuad
                  }
                }

                PauseAnimation { duration: 2200 }

                ParallelAnimation {
                  NumberAnimation {
                    target: toast
                    property: "y"
                    to: 16
                    duration: 900
                    easing.type: Easing.InQuad
                  }
                  NumberAnimation {
                    target: toast
                    property: "opacity"
                    to: 0
                    duration: 900
                    easing.type: Easing.InQuad
                  }
                }

                ScriptAction { script: Notifs.dropToast(toast.modelData.key) }
              }
            }
          }
        }
      }
    }
  }
}
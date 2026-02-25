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
      id: win
      required property var modelData
      screen: modelData
      name: "notifs"

      visible: Visibility.notifsOpen

      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      anchors { top: true; bottom: true; left: true; right: true }

      property int _forceNotifsLoad: Notifs.received

      ModalOverlay {
        anchors.fill: parent
        open: Visibility.notifsOpen
        requestClose: () => Visibility.notifsOpen = false

        Rectangle {
          id: panel
          width: 360
          radius: 18
          color: "#141414"
          border.width: 1
          border.color: "#2a2a2a"

          anchors.top: parent.top
          anchors.bottom: parent.bottom
          anchors.right: parent.right
          anchors.margins: 12

          MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons }

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            Text { text: `received=${Notifs.received} tracked=${Notifs.items.length}`; color: "#aaa" }

            ListView {
              Layout.fillWidth: true
              Layout.fillHeight: true
              model: Notifs.items

              delegate: Rectangle {
                required property var modelData
                width: ListView.view.width
                height: implicitHeight
                radius: 10
                color: "#1a1a1a"
                border.width: 1
                border.color: "#262626"

                Column {
                  anchors.margins: 10
                  anchors.fill: parent
                  spacing: 4
                  Text { text: modelData.summary || "(sin título)"; color: "#e5e5e5"; font.bold: true; wrapMode: Text.Wrap }
                  Text { text: modelData.body || ""; color: "#bdbdbd"; wrapMode: Text.Wrap }
                }
              }
            } 
          }
        }
      }
    }
  }
}
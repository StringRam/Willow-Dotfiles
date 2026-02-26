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
      name: "launcher"

      visible: Visibility.launcherOpen

      exclusionMode: ExclusionMode.Ignore
      WlrLayershell.layer: WlrLayer.Overlay
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      anchors { top: true; bottom: true; left: true; right: true }

      ModalOverlay {
        anchors.fill: parent
        open: Visibility.launcherOpen
        requestClose: () => Visibility.launcherOpen = false

        Rectangle {
          id: panel
          width: 520
          height: 420
          radius: 16
          color: "#141414"
          border.width: 1
          border.color: "#2a2a2a"
          anchors.centerIn: parent

          MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons }

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 10

            TextField {
              id: query
              placeholderText: "Buscar app…"
              Layout.fillWidth: true
              focus: true
              onAccepted: {
                if (list.count > 0) {
                  const allEntries = [...DesktopEntries.applications.values];
                  entry.execute()
                  Visibility.launcherOpen = false
                }
              }
            }

            ListView {
              id: list
              Layout.fillWidth: true
              Layout.fillHeight: true
              clip: true
              spacing: 6
              model: LauncherModel { filterText: query.text }

              delegate: Rectangle {
                required property var entry
                width: ListView.view.width
                height: 44
                radius: 10
                color: ma.containsMouse ? "#1f1f1f" : "transparent"

                RowLayout {
                  anchors.fill: parent
                  anchors.margins: 10
                  Text {
                    Layout.fillWidth: true
                    text: entry.name
                    color: "#e5e5e5"
                    elide: Text.ElideRight
                  }
                }

                MouseArea {
                  id: ma
                  anchors.fill: parent
                  hoverEnabled: true
                  onClicked: {
                    entry.execute()
                    Visibility.launcherOpen = false
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
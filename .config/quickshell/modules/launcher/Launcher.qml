import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components.containers  // o como sea tu alias a ModalOverlay

ModalOverlay {
  id: overlay
  open: Visibility.launcherOpen
  requestClose: () => Visibility.launcherOpen = false

  // Panel del launcher
  Rectangle {
    id: panel
    width: 520
    height: 420
    radius: 16
    color: "#141414"
    border.width: 1
    border.color: "#2a2a2a"

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter

    // Evita que click adentro cierre el overlay
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
            const entry = list.model.get(0).entry
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
            spacing: 10

            // icon (si no lo tenés aún, lo dejamos vacío)
            // Image { source: entry.icon; width: 24; height: 24 }

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
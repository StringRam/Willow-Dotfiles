import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.components.containers

Item {
  id: root
  anchors.fill: parent

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

          // cuando se abre el launcher, enfocar input
          Component.onCompleted: forceActiveFocus()
          onVisibleChanged: if (visible) forceActiveFocus()

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
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.components.containers

ModalOverlay {
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

      RowLayout {
        Layout.fillWidth: true

        Text { text: "Notificaciones"; color: "#e5e5e5"; font.pixelSize: 16; font.bold: true }
        Item { Layout.fillWidth: true }

        Button {
          text: "Clear"
          onClicked: Notifs.clearAll()
        }
      }

      ListView {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        spacing: 8

        model: Notifs.items

        delegate: Rectangle {
          required property var modelData
          width: ListView.view.width
          radius: 12
          color: "#1a1a1a"
          border.width: 1
          border.color: "#262626"

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 6

            Text {
              text: modelData.summary || "(sin título)"
              color: "#eaeaea"
              font.bold: true
              wrapMode: Text.Wrap
            }

            Text {
              text: modelData.body || ""
              color: "#bdbdbd"
              wrapMode: Text.Wrap
              visible: (modelData.body || "") !== ""
            }

            RowLayout {
              Layout.fillWidth: true
              Item { Layout.fillWidth: true }
              Button {
                text: "Dismiss"
                onClicked: {
                  if (modelData.dismiss) modelData.dismiss()
                  else modelData.tracked = false
                }
              }
            }
          }
        }
      }
    }
  }
}
import QtQuick
import QtQuick.Controls
import qs.services

Item {
  id: root

  Column {
    anchors.fill: parent
    anchors.margins: 14
    spacing: 10

    Row {
      id: header
      width: parent.width
      spacing: 10

      Text {
        text: "Notificaciones"
        font.pixelSize: 16
        font.bold: true
        color: "#e5e5e5"
      }

      Item { width: 1; height: 1 } // spacer

      Button {
        text: "Clear"
        onClicked: Notifs.clearAll()
      }
    }

    ListView {
      width: parent.width
      height: parent.height - header.height - 10
      clip: true
      spacing: 8

      model: Notifs.items

      delegate: Rectangle {
        id: card
        required property var modelData

        width: ListView.view.width
        radius: 12
        color: "#1a1a1a"
        border.width: 1
        border.color: "#262626"

        implicitHeight: content.implicitHeight + 20

        Column {
          id: content
          anchors.fill: parent
          anchors.margins: 10
          spacing: 6

          Text {
            text: modelData.summary || "(sin título)"
            color: "#eaeaea"
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

          Row {
            width: parent.width
            spacing: 8

            Item { width: 1; height: 1 }

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
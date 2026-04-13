pragma ComponentBehavior: Bound

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
        color: Colours.palette.m3onSurface
      }

      Item { width: 1; height: 1 } // spacer

      Button {
        text: Notifs.silent ? "Silencio: ON" : "Silencio: OFF"
        checkable: true
        checked: Notifs.silent
        onToggled: Notifs.silent = checked
      }

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
        color: Colours.palette.m3surfaceContainerLow
        border.width: 1
        border.color: Colours.palette.m3outline

        implicitHeight: content.implicitHeight + 20

        Column {
          id: content
          anchors.fill: parent
          anchors.margins: 10
          spacing: 6

          Text {
            text: card.modelData.summary || "(sin título)"
            color: Colours.palette.m3onSurface
            font.bold: true
            wrapMode: Text.Wrap
            width: parent.width
          }

          Text {
            text: card.modelData.body || ""
            color: Colours.palette.m3onSurfaceVariant
            wrapMode: Text.Wrap
            width: parent.width
            visible: (card.modelData.body || "") !== ""
          }

          Row {
            width: parent.width
            spacing: 8

            Item { width: 1; height: 1 }

            Button {
              text: "Dismiss"
              onClicked: {
                const n = card.modelData.ref
                if (n && n.dismiss) n.dismiss()
                else if (n) n.tracked = false
                Notifs.dropItem(card.modelData.key)
              }
            }
          }
        }
      }
    }
  }
}
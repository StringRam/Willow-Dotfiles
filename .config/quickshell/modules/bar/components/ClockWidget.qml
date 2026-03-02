import QtQuick
import qs.services

Item {
  id: root
  implicitWidth: content.implicitWidth
  implicitHeight: content.implicitHeight

  Column {
    id: content
    spacing: 0

    Text {
      text: Time.hour
      color: Colours.palette.m3onSurface
      horizontalAlignment: Text.AlignHCenter
    }

    Text {
      text: Time.minute
      color: Colours.palette.m3onSurface
      horizontalAlignment: Text.AlignHCenter
    }
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: Visibility.toggleSidepanel()
  }
}
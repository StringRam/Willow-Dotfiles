import QtQuick

Item {
  id: root
  anchors.fill: parent

  property bool open: false
  property var requestClose: () => {}

  default property alias content: contentHost.data

  visible: open
  opacity: open ? 1 : 0

  Behavior on opacity {
    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
  }

  Rectangle {
    anchors.fill: parent
    color: "#000"
    opacity: 0.45
  }

  MouseArea {
    anchors.fill: parent
    onClicked: root.requestClose()
  }

  Item { id: contentHost; anchors.fill: parent }

  Keys.onPressed: (e) => {
    if (e.key === Qt.Key_Escape) {
      root.requestClose()
      e.accepted = true
    }
  }
  focus: open
}
import QtQuick
import QtQuick.Controls

Item {
  id: root
  anchors.fill: parent

  // Controla si se ve
  property bool open: false
  // Callback para cerrar (lo pasás desde el módulo)
  property var requestClose: () => {}

  // Te deja “inyectar” contenido
  default property alias content: contentHost.data

  visible: open
  opacity: open ? 1 : 0

  Behavior on opacity {
    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
  }

  Rectangle {
    anchors.fill: parent
    color: "#000000"
    opacity: 0.45
  }

  MouseArea {
    anchors.fill: parent
    onClicked: root.requestClose()
  }

  // Host del contenido; el contenido debe “parar” los clicks para no cerrar
  Item {
    id: contentHost
    anchors.fill: parent
  }

  // Esc para cerrar
  Keys.onPressed: (e) => {
    if (e.key === Qt.Key_Escape) {
      root.requestClose()
      e.accepted = true
    }
  }
  focus: open
}
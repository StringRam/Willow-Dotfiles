import Quickshell
import QtQuick

PopupWindow {
  id: drawer
  color: "transparent"


  // Control externo
  required property PanelWindow anchorWindow
  property bool open: false

  // Posición relativa a la ventana ancla
  property real anchorX: 0
  property real anchorY: 0

  // Hover state
  property bool hovered: hoverArea.containsMouse

  // Estilo
  property color bg: "#FFFFFF"
  property color borderColor: "#2a2a2a"
  property int radius: 16
  property int borderWidth: 1
  property int padding: 10

  // Animación (cajón “cae”)
  property int closedOffsetY: -10
  property int openOffsetY: 0

  // Propiedad intermedia animable
  property int contentOffsetY: open ? openOffsetY : closedOffsetY
  Behavior on contentOffsetY {
    NumberAnimation { duration: 140; easing.type: Easing.OutCubic }
  }

  // Fade animable (pero aplicado al contenido, no al window)
  property real contentOpacity: open ? 1 : 0
  Behavior on contentOpacity { NumberAnimation { duration: 120 } }

  // PopupWindow solo controla visibilidad
  visible: open || hovered

  anchor.window: anchorWindow
  anchor.rect.x: anchorX
  anchor.rect.y: anchorY

  Rectangle {
    id: bgRect
    anchors.fill: parent
    y: drawer.contentOffsetY
    opacity: drawer.contentOpacity

    radius: drawer.radius
    color: drawer.bg
    border.width: drawer.borderWidth
    border.color: drawer.borderColor

    Item {
      id: contentHost
      anchors.fill: parent
      anchors.margins: drawer.padding
      clip: true
    }
  }

  MouseArea {
    id: hoverArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    enabled: drawer.contentOpacity > 0.01
  }

  default property alias content: contentHost.data
}
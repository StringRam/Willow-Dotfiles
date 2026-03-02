import QtQuick

Item {
  id: root

  required property int targetW
  required property real t

  required property int topY
  required property int bottomY

  // borde derecho fijo (borde izquierdo del bar)
  required property int rightEdgeX

  width: Math.round(targetW * t)
  height: Math.max(0, bottomY - topY)

  // ✅ borde derecho constante: al cerrar va hacia la derecha (a la barra)
  x: rightEdgeX - width
  y: topY

  visible: width > 0
  opacity: t
  clip: true

  Behavior on width { NumberAnimation { duration: 210; easing.type: Easing.OutCubic } }
  // (opcional) no hace falta animar x; ya se mueve con width.
  // Behavior on x { NumberAnimation { duration: 190; easing.type: Easing.OutCubic } }
  Behavior on opacity { NumberAnimation { duration: 140 } }
}
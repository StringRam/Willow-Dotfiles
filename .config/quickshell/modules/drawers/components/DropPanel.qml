import QtQuick

Item {
  id: root

  // Inputs
  required property int targetW
  required property int targetH
  required property real t
  required property int topY

  property int drop: 18

  // Geometry
  width: targetW
  height: Math.round(targetH * t)
  y: topY + (1 - t) * (-drop)

  visible: height > 0
  opacity: t
  clip: true

  Behavior on height { NumberAnimation { duration: 210; easing.type: Easing.OutCubic } }
  Behavior on y { NumberAnimation { duration: 190; easing.type: Easing.OutCubic } }
  Behavior on opacity { NumberAnimation { duration: 140 } }
}
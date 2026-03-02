import QtQuick
import QtQuick.Shapes

// Fondo para sidepanel: izquierdo redondeado, derecho RECTO (flush con el bar)
ShapePath {
  id: root
  required property Item wrapper
  property real rounding: 18

  readonly property bool flatten: wrapper.height < rounding * 2
  readonly property real roundingY: flatten ? wrapper.height / 2 : rounding

  strokeWidth: -1

  // startX/startY los setea Backgrounds.qml
  startX: 0
  startY: 0

  // 1) bajar por el lado izquierdo con esquinas redondeadas
  PathArc {
    relativeX: root.rounding
    relativeY: root.roundingY
    radiusX: root.rounding
    radiusY: Math.min(root.rounding, root.wrapper.height)
  }

  PathLine {
    relativeX: 0
    relativeY: root.wrapper.height - root.roundingY * 2
  }

  PathArc {
    relativeX: -root.rounding
    relativeY: root.roundingY
    radiusX: root.rounding
    radiusY: Math.min(root.rounding, root.wrapper.height)
    direction: PathArc.Clockwise
  }

  // 2) ir al borde derecho COMPLETO (sin restar rounding)
  PathLine {
    relativeX: root.wrapper.width - root.rounding
    relativeY: 0
  }

  // 3) subir por el lado derecho (recto)
  PathLine {
    relativeX: 0
    relativeY: -root.wrapper.height
  }

  // 4) volver por arriba hasta el punto inicial (recto)
  PathLine {
    relativeX: -(root.wrapper.width - root.rounding)
    relativeY: 0
  }
}
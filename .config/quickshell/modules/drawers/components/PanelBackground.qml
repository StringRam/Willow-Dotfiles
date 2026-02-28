import QtQuick
import QtQuick.Shapes

ShapePath {
  id: root

  // Igual que shell-main: el ShapePath dibuja según un wrapper Item
  required property Item wrapper
  property real rounding: 18

  // Si el panel es chico, aplana roundingY para evitar glitches
  readonly property bool flatten: wrapper.height < rounding * 2
  readonly property real roundingY: flatten ? wrapper.height / 2 : rounding

  // startX/startY se setean desde afuera (como shell-main Backgrounds.qml)
  strokeWidth: -1

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
    relativeX: root.rounding
    relativeY: root.roundingY
    radiusX: root.rounding
    radiusY: Math.min(root.rounding, root.wrapper.height)
    direction: PathArc.Counterclockwise
  }

  PathLine {
    relativeX: root.wrapper.width - root.rounding * 2
    relativeY: 0
  }

  PathArc {
    relativeX: root.rounding
    relativeY: -root.roundingY
    radiusX: root.rounding
    radiusY: Math.min(root.rounding, root.wrapper.height)
    direction: PathArc.Counterclockwise
  }

  PathLine {
    relativeX: 0
    relativeY: -(root.wrapper.height - root.roundingY * 2)
  }

  PathArc {
    relativeX: root.rounding
    relativeY: -root.roundingY
    radiusX: root.rounding
    radiusY: Math.min(root.rounding, root.wrapper.height)
  }
}
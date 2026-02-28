import QtQuick

Item {
  id: root

  required property Item wrapper
  required property real rounding

  x: wrapper.x - rounding
  y: wrapper.y - rounding
  width: wrapper.width + rounding * 2
  height: wrapper.height + rounding * 2

  visible: false
}
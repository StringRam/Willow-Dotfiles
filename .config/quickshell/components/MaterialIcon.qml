import qs.services
import qs.config
import QtQuick

Text {
  id: root
  // uso: text: "\ue871" (glyph) o si usás Material Symbols por nombre con font features, lo vemos después.

  property real fill: 0
  property int grade: Colours.light ? 0 : -25

  color: Colours.palette.m3onSurface
  renderType: Text.NativeRendering
  font.family: Appearance.font.family.material
  font.pointSize: Appearance.font.size.larger
}
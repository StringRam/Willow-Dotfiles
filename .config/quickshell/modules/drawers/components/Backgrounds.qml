import QtQuick
import QtQuick.Shapes
import qs.services
import qs.modules.drawers.components as DrawersUI

Shape {
  id: root
  anchors.fill: parent
  preferredRendererType: Shape.CurveRenderer

  required property Item dashWrapper
  required property Item notifsWrapper

  property real rounding: 18
  property color panelColor: Colours.palette.m3surfaceContainerHigh

  DrawersUI.PanelBackground {
    wrapper: root.dashWrapper
    rounding: root.rounding
    // ✅ si está cerrado (height~0), no dibujar nada
    fillColor: (wrapper.width > 2 && wrapper.height > 2) ? root.panelColor : "transparent"
    startX: wrapper.x - rounding
    startY: wrapper.y - rounding
  }

  DrawersUI.PanelBackground {
    wrapper: root.notifsWrapper
    rounding: root.rounding
    fillColor: (wrapper.width > 2 && wrapper.height > 2) ? root.panelColor : "transparent"
    startX: wrapper.x - rounding
    startY: wrapper.y - rounding
  }
}
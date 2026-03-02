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

  property Item sideWrapper: null

  property real rounding: 18
  property color panelColor: Colours.palette.m3surfaceContainerHigh

  DrawersUI.PanelBackground {
    wrapper: root.dashWrapper
    rounding: root.rounding
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

  // ✅ Sidepanel: derecho recto y flush (NO wrapper.x - rounding)
  DrawersUI.SidePanelBackground {
    wrapper: root.sideWrapper ? root.sideWrapper : root.dashWrapper
    rounding: root.rounding

    fillColor: (root.sideWrapper
                && wrapper.width > 2
                && wrapper.height > 2)
              ? root.panelColor
              : "transparent"

    // pegado al bar: startX = wrapper.x (sin -rounding)
    startX: wrapper.x
    // mordida arriba para conectar con stripe
    startY: wrapper.y - rounding
  }
}
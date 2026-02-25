import Quickshell
import Quickshell.Wayland
import QtQuick
import "./StyledWindow.qml"

StyledWindow {
  // Props de StyledWindow:
  // required property string name
  // required property var screen (heredado de PanelWindow cuando lo uses con Variants)
  // visible: lo setea el módulo

  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

  anchors { top: true; bottom: true; left: true; right: true }
}
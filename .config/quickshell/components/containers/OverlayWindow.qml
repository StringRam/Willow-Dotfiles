import Quickshell
import Quickshell.Wayland
import QtQuick
import "./StyledWindow.qml"

StyledWindow {
  exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None  // <-- default seguro
  anchors { top: true; bottom: true; left: true; right: true }
}
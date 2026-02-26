import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services
import qs.components.containers
import qs.modules.launcher.components as UI

Scope {
  Variants {
    model: Quickshell.screens

    OverlayWindow {
      required property var modelData
      screen: modelData
      name: "launcher"

      visible: Visibility.launcherOpen
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      UI.LauncherContent {
        anchors.fill: parent
      }
    }
  }
}
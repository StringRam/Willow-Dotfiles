import Quickshell
import Quickshell.Wayland
import QtQuick
import qs.services
import qs.components.containers
import qs.modules.notifs.components as UI

Scope {
  Variants {
    model: Quickshell.screens

    OverlayWindow {
      required property var modelData
      screen: modelData
      name: "notifs"

      visible: Visibility.notifsOpen
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      UI.NotifContent {
        anchors.fill: parent
      }
    }
  }
}
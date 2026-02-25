import Quickshell
import QtQuick
import qs.modules.bar
import qs.modules.anchorPanel
import qs.modules.launcher
import qs.modules.notifs
import qs.services

  Scope {
  Component.onCompleted: console.log("Notifs loaded:", Notifs.items.length)

  Bar {}
  AnchorPanel {}
  Launcher {}
  NotifCenter {}
  Toasts {}   // lo agregamos abajo
}
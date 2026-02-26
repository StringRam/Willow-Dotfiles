import Quickshell
import QtQuick
import "./modules/anchorpanel"
import "./modules/bar"
import "./modules/launcher"
import "./modules/notifs"
import "./modules/toasts"
import "./services"

Scope {
  Component.onCompleted: console.log("Notifs loaded:", Notifs.items.length)

  Bar {}
  AnchorPanel {}
  Launcher {}
  NotifCenter {}
  Toasts {}
}
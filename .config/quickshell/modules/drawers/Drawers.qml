pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import qs.modules.bar as BarUI
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI
import qs.modules.launcher as LauncherUI
import qs.services
import qs.modules.drawers.components as DrawersUI

Scope {
  LauncherUI.Launcher {}

  Variants {
    model: Quickshell.screens

    delegate: Component {
      Item {
        id: root
        required property var modelData

        // ✅ Host fullscreen: TODO lo que se ve (dash/notifs) va adentro
        DrawersUI.DrawerHost {
          id: host
          screenModel: root.modelData
          stripeGap: 9

          // Panels (children del host)
          DrawersUI.DropPanel {
            id: notifsWrapper
            x: 12
            targetW: 360
            targetH: 520
            t: Visibility.notifsOpen ? 1 : 0
            topY: host.drawerTop

            NotifsUI.NotifContent { anchors.fill: parent }
          }

          DrawersUI.DropPanel {
            id: dashWrapper
            targetW: 520
            targetH: 320
            t: Visibility.dashOpen ? 1 : 0
            topY: host.drawerTop
            x: (host.width - width) / 2

            // Si tu DashboardContent requiere `state`, reinsertalo acá como antes:
            PersistentProperties {
              id: dashState
              property int currentTab: 0
              reloadableId: "willowDashState"
            }

            DashUI.DashboardContent {
              anchors.fill: parent
              state: dashState
            }
          }

          // Hitboxes (children del host, usan rounding real del background)
          DrawersUI.Hitbox { id: notifsHitbox; wrapper: notifsWrapper; rounding: host.rounding }
          DrawersUI.Hitbox { id: dashHitbox; wrapper: dashWrapper; rounding: host.rounding }

          // Pasar refs al host (mask + hover)
          notifsWrapper: notifsWrapper
          dashWrapper: dashWrapper
          notifsHitbox: notifsHitbox
          dashHitbox: dashHitbox
        }

        // Right bar como antes
        PanelWindow {
          id: bar
          screen: root.modelData

          anchors { top: true; right: true; bottom: true }
          implicitWidth: 40
          exclusiveZone: implicitWidth
          aboveWindows: true
          color: "transparent"

          Rectangle { anchors.fill: parent; color: Colours.palette.m3surfaceContainer }

          BarUI.BarContent {
            anchors.fill: parent
            parentWindow: bar
          }
        }
      }
    }
  }
}
pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

import qs.modules.bar as BarUI
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI
import qs.modules.launcher as LauncherUI
import qs.modules.sidepanel as SideUI
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

        DrawersUI.DrawerHost {
          id: host
          screenModel: root.modelData
          stripeGap: 9

          // NOTIFS
          DrawersUI.DropPanel {
            id: notifsWrapper
            x: 12
            targetW: 360
            targetH: 520
            t: Visibility.notifsOpen ? 1 : 0
            topY: host.drawerTop

            NotifsUI.NotifContent { anchors.fill: parent }
          }

          // DASH
          DrawersUI.DropPanel {
            id: dashWrapper
            t: Visibility.dashOpen ? 1 : 0
            topY: host.drawerTop
            x: (host.width - width) / 2

            targetW: Math.round(dashContent.implicitWidth)
            targetH: Math.round(dashContent.implicitHeight)

            PersistentProperties {
              id: dashState
              property int currentTab: 0
              reloadableId: "willowDashState"
            }

            DashUI.DashboardContent {
              id: dashContent
              anchors.fill: parent
              state: dashState
            }
          }

          // ✅ CLICK-OUT SCRIM (cierra el sidepanel al clickear fuera)
          // Lo ponemos ANTES del sideWrapper para que quede debajo del panel
          Item {
            id: sideScrim
            anchors.fill: parent
            visible: sideWrapper.t > 0
            z: sideWrapper.z - 1

            MouseArea {
              anchors.fill: parent
              onClicked: Visibility.sidepanelOpen = false
            }
          }

          // ✅ SIDEPANEL (sale desde la derecha)
          DrawersUI.SlidePanel {
            id: sideWrapper
            t: Visibility.sidepanelOpen ? 1 : 0

            // ✅ NO tocar el ancho: esto era lo que te funcionaba
            targetW: 360

            topY: host.drawerTop
            bottomY: host.height + host.rounding
            rightEdgeX: host.width + 18

            // Importante: el panel está arriba del scrim
            z: 50

            SideUI.SidePanel {
              anchors.fill: parent
              inset: host.rounding
            }
          }

          // HITBOXES
          DrawersUI.Hitbox { id: notifsHitbox; wrapper: notifsWrapper; rounding: host.rounding }
          DrawersUI.Hitbox { id: dashHitbox; wrapper: dashWrapper; rounding: host.rounding }
          DrawersUI.Hitbox { id: sideHitbox; wrapper: sideWrapper; rounding: host.rounding }

          // refs al host (mask + hover)
          notifsWrapper: notifsWrapper
          dashWrapper: dashWrapper
          notifsHitbox: notifsHitbox
          dashHitbox: dashHitbox

          sideWrapper: sideWrapper
          sideHitbox: sideHitbox
        }

        // Right bar
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
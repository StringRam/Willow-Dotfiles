pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.modules.drawers.components as DrawersUI
import qs.modules.bar as BarUI
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI
import qs.modules.launcher as LauncherUI
import qs.services

Scope {
  // ✅ Host del launcher (OverlayWindow) — vive junto al resto de “ventanas” del shell
  LauncherUI.Launcher {}

  Variants {
    model: Quickshell.screens

    delegate: Component {
      Item {
        id: root
        required property var modelData  // ✅ modelData llega acá (root del delegate)

        // --------- TOP STRIPE HOST (5px) ----------
        PanelWindow {
          id: topHost
          screen: root.modelData

          anchors { top: true; left: true; right: true }
          implicitHeight: 5
          exclusiveZone: 0
          aboveWindows: true
          color: "transparent"

          DrawersUI.TopStripe {
            anchors.fill: parent
            stripeHeight: 5
            hitHeight: 14
          }

          DrawersUI.Drawer {
            id: notifsDrawer
            anchorWindow: topHost
            open: Visibility.notifsOpen
            implicitWidth: 360
            implicitHeight: 520
            anchorX: 12
            anchorY: topHost.height

            onHoveredChanged: {
              Visibility.notifsPanelHovered = hovered
              Visibility.updateNotifsHover()
            }

            NotifsUI.NotifContent { anchors.fill: parent }
          }

          DrawersUI.Drawer {
            id: dashDrawer
            anchorWindow: topHost
            open: Visibility.dashOpen
            implicitWidth: 520
            implicitHeight: 320
            anchorX: topHost.width / 2 - implicitWidth / 2
            anchorY: topHost.height

            onHoveredChanged: {
              Visibility.dashPanelHovered = hovered
              Visibility.updateDashHover()
            }

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
        }

        // --------- RIGHT BAR HOST (vertical) ----------
        PanelWindow {
          id: bar
          screen: root.modelData

          anchors { top: true; right: true; bottom: true }
          implicitWidth: 40
          exclusiveZone: implicitWidth
          aboveWindows: true
          color: "transparent"

          Rectangle {
            anchors.fill: parent
            color: Colours.palette.m3surfaceContainer
          }

          BarUI.BarContent {
            anchors.fill: parent
            parentWindow: bar
          }
        }
      }
    }
  }
}
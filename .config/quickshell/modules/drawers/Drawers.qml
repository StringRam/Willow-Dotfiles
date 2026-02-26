pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import qs.modules.drawers.components as DrawersUI
import qs.modules.bar as BarUI
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI
import qs.services

Scope {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      Item {
        // --------- 1) TOP ANCHOR WINDOW (para drawers) ----------
        PanelWindow {
          id: topHost
          required property var modelData
          screen: modelData

          anchors { top: true; left: true; right: true }
          implicitHeight: 4          // finito: solo anchor
          exclusiveZone: 0           // no reserva espacio
          aboveWindows: true
          color: "transparent"

          // Drawers DIRECTOS (como ya te funciona)
          DrawersUI.Drawer {
            id: notifsDrawer
            anchorWindow: topHost
            open: Visibility.notifsOpen
            width: 360
            height: 520
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
            width: 520
            height: 320
            anchorX: topHost.width / 2 - width / 2
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

        // --------- 2) RIGHT BAR WINDOW (restaurada) ----------
        PanelWindow {
          id: bar
          required property var modelData
          screen: modelData

          anchors { top: true; right: true; bottom: true }

          implicitWidth: 40
          exclusiveZone: implicitWidth  // reserva espacio a la derecha
          aboveWindows: true
          color: "transparent"

          // Fondo (si querés, podés moverlo al content)
          Rectangle {
            anchors.fill: parent
            color: Colours.palette.m3surfaceContainer
          }

          // Contenido original (embebible)
          BarUI.BarContent {
            anchors.fill: parent
            parentWindow: rightBar
          }
        }
      }
    }
  }
}
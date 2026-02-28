pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.modules.drawers.components as DrawersUI
import qs.modules.bar as BarUI
import qs.modules.notifs.components as NotifsUI
import qs.modules.dashboard.components as DashUI
import qs.modules.launcher as LauncherUI
import qs.services

Scope {
  LauncherUI.Launcher {}

  Variants {
    model: Quickshell.screens

    delegate: Component {
      Item {
        id: root
        required property var modelData

        // ---------- FULLSCREEN HOST (pero click-through salvo paneles) ----------
        PanelWindow {
          id: host
          screen: root.modelData

          anchors { top: true; bottom: true; left: true; right: true }
          exclusiveZone: 0
          aboveWindows: true
          color: "transparent"

          // --- Stripe (hotspot) ---
          Item {
            id: stripeHit
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 14

            DrawersUI.TopStripe {
              anchors.fill: parent
              stripeHeight: 5
              hitHeight: 14
            }
          }

          // ✅ Ajuste real de anclaje
          property int stripeGap: 9
          readonly property int drawerTop: stripeHit.height + stripeGap

          // Fondo detrás de wrappers (no intercepta clicks: lo controla mask)
          DrawersUI.Backgrounds {
            id: backgrounds
            anchors.fill: parent
            dashWrapper: dashWrapper
            notifsWrapper: notifsWrapper
          }

          // ---------- NOTIFS WRAPPER (shell-main style: tamaño -> 0) ----------
          Item {
            id: notifsWrapper
            x: 12

            readonly property int targetW: 360
            readonly property int targetH: 520

            property real t: Visibility.notifsOpen ? 1 : 0

            width: targetW
            height: Math.round(targetH * t)

            property int drop: 18
            y: host.drawerTop + (1 - t) * (-drop)

            visible: height > 0
            opacity: t

            Behavior on height { NumberAnimation { duration: 210; easing.type: Easing.OutCubic } }
            Behavior on y { NumberAnimation { duration: 190; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 140 } }

            clip: true
            NotifsUI.NotifContent { anchors.fill: parent }
          }

          // ---------- DASHBOARD WRAPPER (shell-main style: tamaño -> 0) ----------
          Item {
            id: dashWrapper
            readonly property int targetW: 520
            readonly property int targetH: 320

            property real t: Visibility.dashOpen ? 1 : 0

            width: targetW
            height: Math.round(targetH * t)

            x: (host.width - width) / 2

            property int drop: 18
            y: host.drawerTop + (1 - t) * (-drop)

            visible: height > 0
            opacity: t

            Behavior on height { NumberAnimation { duration: 210; easing.type: Easing.OutCubic } }
            Behavior on y { NumberAnimation { duration: 190; easing.type: Easing.OutCubic } }
            Behavior on opacity { NumberAnimation { duration: 140 } }

            PersistentProperties {
              id: dashState
              property int currentTab: 0
              reloadableId: "willowDashState"
            }

            clip: true
            DashUI.DashboardContent {
              anchors.fill: parent
              state: dashState
            }
          }

          // ---------- HITBOXES (deben abarcar el background redondeado) ----------
          Item {
            id: notifsHitbox
            x: notifsWrapper.x - backgrounds.rounding
            y: notifsWrapper.y - backgrounds.rounding
            width: notifsWrapper.width + backgrounds.rounding * 2
            height: notifsWrapper.height + backgrounds.rounding * 2
            visible: false
          }

          Item {
            id: dashHitbox
            x: dashWrapper.x - backgrounds.rounding
            y: dashWrapper.y - backgrounds.rounding
            width: dashWrapper.width + backgrounds.rounding * 2
            height: dashWrapper.height + backgrounds.rounding * 2
            visible: false
          }

          // ✅ CLAVE: el window NO bloquea clicks excepto donde diga el mask
          mask: Region {
            intersection: Intersection.Combine
            regions: [
              Region { item: stripeHit },
              Region { item: (dashWrapper.height > 0 ? dashHitbox : null) },
              Region { item: (notifsWrapper.height > 0 ? notifsHitbox : null) }
            ]
          }

          // ---------- HOVER DETECTION (sobre hitboxes, no sobre wrapper) ----------
          MouseArea {
            anchors.fill: notifsHitbox
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            enabled: notifsWrapper.height > 0

            onEntered: {
              Visibility.notifsPanelHovered = true
              Visibility.updateNotifsHover()
            }
            onExited: {
              Visibility.notifsPanelHovered = false
              Visibility.updateNotifsHover()
            }
          }

          MouseArea {
            anchors.fill: dashHitbox
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            enabled: dashWrapper.height > 0

            onEntered: {
              Visibility.dashPanelHovered = true
              Visibility.updateDashHover()
            }
            onExited: {
              Visibility.dashPanelHovered = false
              Visibility.updateDashHover()
            }
          }
        }

        // ---------- RIGHT BAR ----------
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
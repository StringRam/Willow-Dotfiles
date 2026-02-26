pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property bool launcherOpen: false

  // =======================
  // NOTIFS (hover + pin)
  // =======================
  property bool notifsPinned: false
  property bool notifsHotspotHovered: false
  property bool notifsPanelHovered: false
  property bool notifsHoverHold: false
  readonly property bool notifsOpen: notifsPinned || notifsHoverHold

  // Cierre “suave”: si hay hover, mantener; si no, cerrar con delay + re-check
  Timer {
    id: notifsCloseTimer
    interval: 160
    repeat: false
    onTriggered: {
      if (!root.notifsPinned && !(root.notifsHotspotHovered || root.notifsPanelHovered)) {
        root.notifsHoverHold = false
      }
    }
  }

  function updateNotifsHover() {
    // Si está pinned, siempre abierto
    if (notifsPinned) {
      notifsHoverHold = true
      notifsCloseTimer.stop()
      return
    }

    // Si hay hover en hotspot o panel, abrir/hold inmediato
    if (notifsHotspotHovered || notifsPanelHovered) {
      notifsHoverHold = true
      notifsCloseTimer.stop()
      return
    }

    // Si no hay hover, cerrar con delay (y re-check)
    notifsCloseTimer.restart()
  }

  function toggleNotifsPinned() {
    notifsPinned = !notifsPinned
    // al pin/unpin, reevaluar estado
    updateNotifsHover()
  }

  function closeNotifs() {
    notifsPinned = false
    notifsHotspotHovered = false
    notifsPanelHovered = false
    notifsHoverHold = false
    notifsCloseTimer.stop()
  }

  // Compat por si algún lugar llama esto
  function toggleNotifs() { toggleNotifsPinned() }

  // =======================
  // DASHBOARD (hover + pin opcional)
  // =======================
  property bool dashPinned: false
  property bool dashHotspotHovered: false
  property bool dashPanelHovered: false
  property bool dashHoverHold: false
  readonly property bool dashOpen: dashPinned || dashHoverHold

  Timer {
    id: dashCloseTimer
    interval: 160
    repeat: false
    onTriggered: {
      if (!root.dashPinned && !(root.dashHotspotHovered || root.dashPanelHovered)) {
        root.dashHoverHold = false
      }
    }
  }

  function updateDashHover() {
    if (dashPinned) {
      dashHoverHold = true
      dashCloseTimer.stop()
      return
    }
    if (dashHotspotHovered || dashPanelHovered) {
      dashHoverHold = true
      dashCloseTimer.stop()
      return
    }
    dashCloseTimer.restart()
  }

  function toggleDashPinned() {
    dashPinned = !dashPinned
    updateDashHover()
  }

  function closeDash() {
    dashPinned = false
    dashHotspotHovered = false
    dashPanelHovered = false
    dashHoverHold = false
    dashCloseTimer.stop()
  }

  // =======================
  // GLOBAL
  // =======================
  function closeAll() {
    launcherOpen = false
    closeNotifs()
    closeDash()
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }
}
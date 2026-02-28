pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  // =======================
  // LAUNCHER
  // =======================
  property bool launcherOpen: false

  // =======================
  // SIDEPANEL (drawer desde la barra lateral)
  // =======================
  property bool sidepanelOpen: false

  // =======================
  // SESSION MENU (logout/reboot/etc)
  // =======================
  property bool sessionOpen: false

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
    if (notifsPinned) {
      notifsHoverHold = true
      notifsCloseTimer.stop()
      return
    }

    if (notifsHotspotHovered || notifsPanelHovered) {
      notifsHoverHold = true
      notifsCloseTimer.stop()
      return
    }

    notifsCloseTimer.restart()
  }

  function toggleNotifsPinned() {
    notifsPinned = !notifsPinned
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
    sidepanelOpen = false
    sessionOpen = false
    closeNotifs()
    closeDash()
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }

  function toggleSidepanel() {
    const next = !sidepanelOpen
    closeAll()
    sidepanelOpen = next
  }

  function toggleSession() {
    const next = !sessionOpen
    closeAll()
    sessionOpen = next
  }
}
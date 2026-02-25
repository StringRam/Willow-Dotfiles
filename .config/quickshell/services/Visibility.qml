pragma Singleton
import QtQuick

Singleton {
  id: root

  property bool launcherOpen: false
  property bool notifsOpen: false
  property bool powerOpen: false

  function closeAll() {
    launcherOpen = false
    notifsOpen = false
    powerOpen = false
  }

  function toggleLauncher() {
    const next = !launcherOpen
    closeAll()
    launcherOpen = next
  }

  function toggleNotifs() {
    const next = !notifsOpen
    closeAll()
    notifsOpen = next
  }

  function togglePower() {
    const next = !powerOpen
    closeAll()
    powerOpen = next
  }
}
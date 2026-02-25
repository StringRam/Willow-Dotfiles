pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
  id: root

  // Debug
  property int received: 0

  // Historial (NotifCenter)
  readonly property var items: server.trackedNotifications

  // Toasts: lista simple
  property var toasts: []

  function pushToast(n) {
    const t = {
      key: Date.now() + Math.random(),
      summary: n.summary ?? "",
      body: n.body ?? ""
    }
    toasts = [t, ...toasts].slice(0, 3)
  }

  function dropToast(key) {
    toasts = toasts.filter(t => t.key !== key)
  }

  function clearAll() {
    // si existe dismiss, mejor; sino des-track
    for (let i = items.length - 1; i >= 0; i--) {
      const n = items[i]
      if (n.dismiss) n.dismiss()
      else n.tracked = false
    }
  }

  NotificationServer {
    id: server
    onNotification: (n) => {
      root.received++
      console.log("[Notifs] got:", n.summary, "|", n.body)
      n.tracked = true
      root.pushToast(n)
    }
  }
}
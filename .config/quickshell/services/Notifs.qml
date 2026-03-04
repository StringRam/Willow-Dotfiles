pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
  id: root

  // Debug
  property int received: 0

  // Historial (NotifCenter)
  // Guardamos nuestras propias refs para poder operar (clear/dismiss) sin pelear
  // con la estructura interna de trackedNotifications.
  property var items: []

  // Toasts: lista simple
  property var toasts: []

  function pushToast(n) {
    const t = {
      key: Date.now() + Math.random(),
      summary: n.summary ?? "",
      body: n.body ?? ""
    }
    toasts = [t, ...toasts].slice(0, 3)
    console.log("[Toasts] count=", toasts.length, "last=", t.summary)
  }

  function dropToast(key) {
    toasts = toasts.filter(t => t.key !== key)
  }

  function dropItem(key) {
    items = items.filter(it => it.key !== key)
  }

  function clearAll() {
    // dismiss si existe; si no, des-track. Luego limpiamos nuestro modelo.
    for (let i = items.length - 1; i >= 0; i--) {
      const it = items[i]
      const n = it.ref
      if (!n) continue
      if (n.dismiss) n.dismiss()
      else n.tracked = false
    }
    items = []
  }

  NotificationServer {
    id: server
    onNotification: (n) => {
      root.received++
      console.log("[Notifs] got:", n.summary, "|", n.body)
      n.tracked = true

      const it = {
        key: Date.now() + Math.random(),
        summary: n.summary ?? "",
        body: n.body ?? "",
        ref: n
      }

      // prepend
      root.items = [it, ...root.items]
      root.pushToast(n)
    }
  }
}
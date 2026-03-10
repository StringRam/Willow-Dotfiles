pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

import qs.services

Singleton {
  id: root

  property int received: 0

  // historial persistente para NotifCenter
  property var items: []

  // preferencia del usuario
  property bool silent: false

  // transitorios visibles
  property var toasts: []

  // regla final de visibilidad de toasts
  readonly property bool toastsAllowed: !root.silent && !Visibility.notifsOpen

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

  function clearToasts() {
    toasts = []
  }

  function dropItem(key) {
    items = items.filter(it => it.key !== key)
  }

  function clearAll() {
    for (let i = items.length - 1; i >= 0; i--) {
      const it = items[i]
      const n = it.ref
      if (!n) continue
      if (n.dismiss) n.dismiss()
      else n.tracked = false
    }

    items = []
    clearToasts()
  }

  // Cuando el NotifCenter se abre, limpiamos cualquier toast visible.
  Connections {
    target: Visibility

    function onNotifsOpenChanged() {
      if (Visibility.notifsOpen) {
        root.clearToasts()
      }
    }
  }

  NotificationServer {
    id: server

    onNotification: (n) => {
      root.received++
      console.log("[Notifs] got:", n.summary, "|", n.body)

      // Siempre trackeamos para el centro de notificaciones
      n.tracked = true

      const it = {
        key: Date.now() + Math.random(),
        summary: n.summary ?? "",
        body: n.body ?? "",
        ref: n
      }

      root.items = [it, ...root.items]

      // Solo mostramos toast si está permitido por UX + preferencia de usuario
      if (root.toastsAllowed) {
        root.pushToast(n)
      }
    }
  }
}
pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
  id: root

  property int received: 0
  property string lastSummary: ""
  property string lastBody: ""

  // toasts: lista simple de objetos { id, summary, body, createdAt }
  property var toasts: []

  function pushToast(n) {
    const t = {
      key: Date.now() + Math.random(),
      summary: n.summary ?? "",
      body: n.body ?? ""
    }
    toasts = [t, ...toasts].slice(0, 3) // max 3 a la vez
  }

  function dropToast(key) {
    toasts = toasts.filter(t => t.key !== key)
  }

  NotificationServer {
    id: server
    onNotification: (n) => {
      root.received++
      root.lastSummary = n.summary ?? ""
      root.lastBody = n.body ?? ""
      console.log("[Notifs] got:", root.lastSummary, "|", root.lastBody)

      n.tracked = true
      root.pushToast(n)
    }
  }

  readonly property var items: server.trackedNotifications
}
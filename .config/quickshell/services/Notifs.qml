pragma Singleton
import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
  id: root

  property int received: 0
  property string lastSummary: ""
  property string lastBody: ""

  NotificationServer {
    id: server

    onNotification: (n) => {
      root.received++
      root.lastSummary = n.summary ?? ""
      root.lastBody = n.body ?? ""
      console.log("[Notifs] got:", root.lastSummary, "|", root.lastBody)

      n.tracked = true
    }
  }

  readonly property var items: server.trackedNotifications
}
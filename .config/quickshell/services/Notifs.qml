pragma Singleton
import QtQuick
import Quickshell.Services.Notifications

Singleton {
  id: root

  NotificationServer {
    id: server

    onNotification: (n) => {
      // Guardar en historial
      n.tracked = true

      // Si querés popups “toast” luego, este es el hook
    }
  }

  // Exponer lista
  readonly property var items: server.trackedNotifications

  function clearAll() {
    // trackedNotifications son objetos Notification; “dismiss” existe en Notification
    // Si tu versión no lo tiene, hacemos tracked=false o close().
    for (let i = items.length - 1; i >= 0; i--) {
      const n = items[i]
      if (n.dismiss) n.dismiss()
      else n.tracked = false
    }
  }
}
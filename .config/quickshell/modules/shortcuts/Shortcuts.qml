import Quickshell
import Quickshell.Io
import QtQuick
import qs.services

Scope {
  IpcHandler {
    // Se invoca con: qs ipc call visibility <func>
    target: "visibility"

    function closeAll(): void {
      Visibility.closeAll()
    }

    function toggleLauncher(): void {
      Visibility.toggleLauncher()
    }

    function openLauncher(): void {
      Visibility.closeAll()
      Visibility.launcherOpen = true
    }

    function toggleSidepanel(): void {
      Visibility.toggleSidepanel()
    }

    function openSidepanel(): void {
      Visibility.closeAll()
      Visibility.sidepanelOpen = true
    }

    function toggleSession(): void {
      Visibility.toggleSession()
    }

    function openSession(): void {
      Visibility.closeAll()
      Visibility.sessionOpen = true
    }
  }
}
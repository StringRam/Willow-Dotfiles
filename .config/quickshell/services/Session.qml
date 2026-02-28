pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  // Cambiá estos comandos a tu setup real (hyprlock, swaylock, loginctl, etc)
  property string cmdLock: "hyprlock"
  property string cmdLogout: "hyprctl dispatch exit"
  property string cmdReboot: "systemctl reboot"
  property string cmdPoweroff: "systemctl poweroff"

  function run(cmd: string): void {
    if (!cmd || cmd.trim().length === 0) return
    // Usamos sh -lc para permitir comandos compuestos y PATH de usuario
    Process.exec(["sh", "-lc", cmd])
  }

  function lock(): void { run(cmdLock) }
  function logout(): void { run(cmdLogout) }
  function reboot(): void { run(cmdReboot) }
  function poweroff(): void { run(cmdPoweroff) }
}
pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property string hour: "--"
  property string minute: "--"

  Process {
    id: dateProc
    command: ["date", "+%H %M"]

    stdout: StdioCollector {
      onStreamFinished: {
        const parts = this.text.trim().split(/\s+/)
        root.hour = parts[0] ?? "--"
        root.minute = parts[1] ?? "--"
      }
    }
  }

  // Tick inicial
  Component.onCompleted: dateProc.running = true

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
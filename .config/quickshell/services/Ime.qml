pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

// IME status helper.
// Reads the active fcitx5 input method engine name via `fcitx5-remote -n`
// and exposes a tiny label intended for the bar (EN / JP / あ).
//
// Docs: Quickshell.Io.Process + StdioCollector
// https://quickshell.outfoxxed.me/docs/master/types/Quickshell.Io/Process/

Singleton {
  id: root

  // Raw engine name returned by fcitx5-remote (e.g. "mozc", "keyboard-us", ...)
  property string engine: ""

  // Label for UI (minimal)
  property string label: "EN"

  // Whether we successfully queried fcitx5 at least once.
  property bool available: false

  function mapEngineToLabel(name) {
    const s = (name || "").toLowerCase()

    // Common Japanese engines
    if (s.includes("mozc") || s.includes("anthy") || s.includes("skk")) return "あ"

    // Some setups expose layout engines like keyboard-jp
    if (s.includes("keyboard") && (s.includes("jp") || s.includes("japanese"))) return "JP"

    // Default / fallback
    return "EN"
  }

  Process {
    id: imeProc

    // Use a shell so we can gracefully fallback when fcitx5 isn't running.
    command: ["sh", "-lc", "fcitx5-remote -n 2>/dev/null || echo EN"]

    stdout: StdioCollector {
      onStreamFinished: {
        const text = (this.text || "").trim()
        root.engine = text
        root.label = root.mapEngineToLabel(text)
        root.available = true
      }
    }
  }

  Component.onCompleted: imeProc.running = true

  Timer {
    interval: 700
    running: true
    repeat: true
    onTriggered: imeProc.running = true
  }
}

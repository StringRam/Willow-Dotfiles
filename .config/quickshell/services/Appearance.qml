pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  // ---- Spacing (distancia entre elementos) ----
  readonly property var spacing: ({
    tiny: 4,
    small: 8,
    normal: 12,
    large: 16,
    xlarge: 20
  })

  // ---- Padding (márgenes internos) ----
  readonly property var padding: ({
    tiny: 6,
    small: 10,
    normal: 14,
    large: 18
  })

  // ---- Rounding (radios) ----
  readonly property var rounding: ({
    small: 8,
    normal: 12,
    large: 16,
    xlarge: 22,
    full: 999
  })
}
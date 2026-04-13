pragma Singleton
import QtQuick

QtObject {
  id: root

  // si después querés theme claro/oscuro real, lo conectamos acá
  property bool light: false

  readonly property QtObject palette: QtObject {
    // Material-ish (ajustable)
    readonly property color m3primary: "#7aa2f7"
    readonly property color m3onSurface: "#e6e6e6"
    readonly property color m3onSurfaceVariant: "#bdbdbd"
    readonly property color m3onSurfaceMuted: "#6f6f6f"
    readonly property color m3outlineVariant: "#3a3a3a"
    readonly property color m3outline: "#2a2a2a"

    readonly property color m3background: "#141414"
    readonly property color m3surface: "#2b3439"
    readonly property color m3surfaceContainer: "#1b2030"
    readonly property color m3surfaceContainerHigh: "#1b2030"
    readonly property color m3surfaceContainerLow: "#1a1a1a"
    readonly property color m3surfaceHighlight: "#1f1f1f"
  }

  // Alias para compat mental con shell-main (tPalette.*)
  readonly property QtObject tPalette: QtObject {
    readonly property color m3surfaceContainer: root.palette.m3surfaceContainer
  }

  // Aplica un alpha a un color de paleta sin Qt.rgba(c.r, c.g, c.b, a) verboso
  function withAlpha(c, a) {
    return Qt.rgba(c.r, c.g, c.b, a)
  }
}
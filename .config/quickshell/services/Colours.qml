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
    readonly property color m3outlineVariant: "#3a3a3a"

    readonly property color m3surface: "#0f1115"
    readonly property color m3surfaceContainer: "#161a22"
    readonly property color m3surfaceContainerHigh: "#1b2030"
  }

  // Alias para compat mental con shell-main (tPalette.*)
  readonly property QtObject tPalette: QtObject {
    readonly property color m3surfaceContainer: root.palette.m3surfaceContainer
  }
}
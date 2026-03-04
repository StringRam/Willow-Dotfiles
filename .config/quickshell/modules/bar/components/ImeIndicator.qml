import QtQuick
import qs.services

// Minimal IME indicator for the bar (under Workspaces).
// Driven by qs.services.Ime.

Rectangle {
  id: root

  // Keep it subtle: smaller than workspace chips.
  width: 28
  height: 18
  radius: 6

  color: Colours.palette.m3surfaceContainer
  border.width: 1
  border.color: Colours.palette.m3outlineVariant

  // If fcitx isn't available yet, dim it.
  opacity: Ime.available ? 1.0 : 0.6

  Text {
    anchors.centerIn: parent
    text: Ime.label
    color: Colours.palette.m3onSurface
    font.pixelSize: 11
    font.bold: true
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }
}

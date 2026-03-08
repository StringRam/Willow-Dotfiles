pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services

StyledRect {
  id: root
  required property var event

  radius: Appearance.rounding.large
  color: Colours.palette.m3surfaceContainer
  border.width: 1
  border.color: Colours.palette.m3outlineVariant

  property int _innerPad: Appearance.padding.large
  implicitHeight: content.implicitHeight + _innerPad * 2

  ColumnLayout {
    id: content
    x: root._innerPad
    y: root._innerPad
    width: parent.width - root._innerPad * 2
    spacing: Appearance.spacing.small

    StyledText {
      Layout.fillWidth: true
      font.pixelSize: 14
      font.bold: true
      text: root.event ? (root.event.summary || "(sin título)") : "Seleccioná un bloque"
    }

    StyledText {
      Layout.fillWidth: true
      visible: !!root.event
      wrapMode: Text.Wrap
      color: Qt.rgba(
        Colours.palette.m3onSurface.r,
        Colours.palette.m3onSurface.g,
        Colours.palette.m3onSurface.b,
        0.72
      )
      text: root.event
        ? (Qt.formatDate(root.event.day, "dddd d MMM")
           + " · "
           + Qt.formatTime(root.event.start, "HH:mm")
           + "–"
           + Qt.formatTime(root.event.end, "HH:mm"))
        : ""
    }

    StyledText {
      Layout.fillWidth: true
      visible: !root.event
      wrapMode: Text.Wrap
      color: Qt.rgba(
        Colours.palette.m3onSurface.r,
        Colours.palette.m3onSurface.g,
        Colours.palette.m3onSurface.b,
        0.65
      )
      text: "Tocá un bloque en Schedule para ver sus detalles acá."
    }
  }
}
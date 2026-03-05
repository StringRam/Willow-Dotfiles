pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls

import qs.components
import qs.config
import qs.services

Rectangle {
  id: root

  required property int dayNumber
  required property bool inMonth
  required property bool isToday
  required property bool isSelected

  signal clicked()

  radius: Appearance.rounding.small
  color: root.isSelected
    ? Qt.rgba(Colours.palette.m3primary.r, Colours.palette.m3primary.g, Colours.palette.m3primary.b, 0.22)
    : (root.isToday && root.inMonth)
      ? Qt.rgba(1, 1, 1, 0.06)
      : "transparent"

  border.width: (root.isToday && root.inMonth) ? 1 : 0
  border.color: Colours.palette.m3outlineVariant

  implicitWidth: 34
  implicitHeight: 28

  opacity: root.inMonth ? 1 : 0.35

  Text {
    anchors.centerIn: parent
    text: root.dayNumber > 0 ? String(root.dayNumber) : ""
    color: Colours.palette.m3onSurface
    font.family: Appearance.font.family.ui
    font.pixelSize: 12
  }

  MouseArea {
    anchors.fill: parent
    enabled: root.inMonth && root.dayNumber > 0
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}

pragma ComponentBehavior: Bound

import QtQuick
import qs.components
import qs.services

Item {
  id: root

  required property var state
  // lo dejamos aunque no lo usemos, para no romper imports existentes
  required property real nonAnimWidth

  property int count: 4
  readonly property real cellWidth: width / count
  readonly property int currentIndex: root.state.currentTab ?? 0

  implicitHeight: 34 + 5 + 3 + 1  // tabs + gap + indicator + separator

  // ---------- Tabs row ----------
  Row {
    id: row
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: 34
    spacing: 0

    function labelFor(i) {
      switch (i) {
      case 0: return "Dashboard"
      case 1: return "Media"
      case 2: return "Performance"
      case 3: return "Weather"
      default: return "Tab"
      }
    }

    Repeater {
      model: root.count

      delegate: Item {
        id: cell
        required property int index

        width: root.cellWidth
        height: row.height

        // opcional: feedback visual (hover/active)
        StyledRect {
          anchors.fill: parent
          radius: Appearance.rounding.full
          color: (root.currentIndex === index)
                   ? Qt.alpha(Colours.palette.m3primary, 0.12)
                   : "transparent"
        }

        StyledText {
          anchors.centerIn: parent
          text: row.labelFor(index)
        }

        MouseArea {
          anchors.fill: parent
          onClicked: root.state.currentTab = index
        }
      }
    }
  }

  // ---------- Indicator ----------
  Item {
    id: indicator
    anchors.top: row.bottom
    anchors.topMargin: 5
    height: 3
    width: root.cellWidth
    x: root.cellWidth * root.currentIndex
    clip: true

    StyledRect {
      anchors.fill: parent
      color: Colours.palette.m3primary
      radius: Appearance.rounding.full
    }

    Behavior on x { Anim {} }
    Behavior on width { Anim {} }
  }

  // ---------- Separator ----------
  StyledRect {
    anchors.top: indicator.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 1
    color: Colours.palette.m3outlineVariant
  }
}
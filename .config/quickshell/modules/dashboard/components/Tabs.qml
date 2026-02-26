pragma ComponentBehavior: Bound

import qs.components
import qs.config
import qs.services
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls

Item {
  id: root

  required property real nonAnimWidth
  required property var state
  readonly property alias count: bar.count

  implicitHeight: bar.implicitHeight + indicator.implicitHeight + indicator.anchors.topMargin + separator.implicitHeight

  TabBar {
    id: bar
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    currentIndex: root.state.currentTab ?? 0
    background: null

    onCurrentIndexChanged: root.state.currentTab = currentIndex

    TabButton {
      background: null
      contentItem: StyledText { text: "Dashboard" }
      onClicked: root.state.currentTab = 0
    }
    TabButton {
      background: null
      contentItem: StyledText { text: "Media" }
      onClicked: root.state.currentTab = 1
    }
    TabButton {
      background: null
      contentItem: StyledText { text: "Performance" }
      onClicked: root.state.currentTab = 2
    }
    TabButton {
      background: null
      contentItem: StyledText { text: "Weather" }
      onClicked: root.state.currentTab = 3
    }
  }

  Item {
    id: indicator
    anchors.top: bar.bottom
    anchors.topMargin: 5

    implicitWidth: bar.currentItem?.implicitWidth ?? 0
    implicitHeight: 3

    x: {
      const tab = bar.currentItem;
      if (!tab) return 0;
      const width = (root.nonAnimWidth - bar.spacing * (bar.count - 1)) / bar.count;
      return width * tab.TabBar.index + (width - tab.implicitWidth) / 2;
    }

    clip: true

    StyledRect {
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      implicitHeight: parent.implicitHeight * 2
      color: Colours.palette.m3primary
      radius: Appearance.rounding.full
    }

    Behavior on x { Anim {} }
    Behavior on implicitWidth { Anim {} }
  }

  StyledRect {
    id: separator
    anchors.top: indicator.bottom
    anchors.left: parent.left
    anchors.right: parent.right

    implicitHeight: 1
    color: Colours.palette.m3outlineVariant
  }
}
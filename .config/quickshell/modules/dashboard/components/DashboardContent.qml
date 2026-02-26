pragma ComponentBehavior: Bound

import qs.components
import qs.config
import qs.services
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Item {
  id: root

  // igual que Caelestia: estado externo (persistible) para tabs
  required property var state

  readonly property real nonAnimWidth: view.implicitWidth + viewWrapper.anchors.margins * 2
  readonly property real nonAnimHeight: tabs.implicitHeight + tabs.anchors.topMargin + view.implicitHeight + viewWrapper.anchors.margins * 2

  implicitWidth: nonAnimWidth
  implicitHeight: nonAnimHeight

  Tabs {
    id: tabs
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.topMargin: Appearance.padding.normal
    anchors.margins: Appearance.padding.large

    nonAnimWidth: root.nonAnimWidth - anchors.margins * 2
    state: root.state
  }

  ClippingRectangle {
    id: viewWrapper

    anchors.top: tabs.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    anchors.margins: Appearance.padding.large

    radius: Appearance.rounding.normal
    color: "transparent"

    Flickable {
      id: view

      readonly property int currentIndex: root.state.currentTab ?? 0
      readonly property Item currentItem: row.children[currentIndex]

      anchors.fill: parent
      flickableDirection: Flickable.HorizontalFlick

      implicitWidth: currentItem?.implicitWidth ?? 520
      implicitHeight: currentItem?.implicitHeight ?? 320

      contentX: currentItem?.x ?? 0
      contentWidth: row.implicitWidth
      contentHeight: row.implicitHeight

      onContentXChanged: {
        if (!moving || !currentItem) return;
        const x = contentX - currentItem.x;
        if (x > currentItem.implicitWidth / 2)
          root.state.currentTab = Math.min((root.state.currentTab ?? 0) + 1, tabs.count - 1);
        else if (x < -currentItem.implicitWidth / 2)
          root.state.currentTab = Math.max((root.state.currentTab ?? 0) - 1, 0);
      }

      onDragEnded: {
        if (!currentItem) return;
        const x = contentX - currentItem.x;
        if (x > currentItem.implicitWidth / 10)
          root.state.currentTab = Math.min((root.state.currentTab ?? 0) + 1, tabs.count - 1);
        else if (x < -currentItem.implicitWidth / 10)
          root.state.currentTab = Math.max((root.state.currentTab ?? 0) - 1, 0);
        else
          contentX = Qt.binding(() => currentItem.x);
      }

      RowLayout {
        id: row

        DashboardPane { index: 0; sourceComponent: Dash {} }
        DashboardPane { index: 1; sourceComponent: MediaPane {} }
        DashboardPane { index: 2; sourceComponent: PerformancePane {} }
        DashboardPane { index: 3; sourceComponent: WeatherPane {} }
      }

      Behavior on contentX { Anim {} }
    }
  }

  Behavior on implicitWidth {
    Anim {
      duration: Appearance.anim.durations.large
      easing.bezierCurve: Appearance.anim.curves.emphasized
    }
  }

  Behavior on implicitHeight {
    Anim {
      duration: Appearance.anim.durations.large
      easing.bezierCurve: Appearance.anim.curves.emphasized
    }
  }

  component DashboardPane: Loader {
    required property int index
    Layout.alignment: Qt.AlignTop
    Component.onCompleted: active = true
  }

  // ---- panes (stubs) ----
  component MediaPane: Item {
    implicitWidth: 520
    implicitHeight: 320
    StyledRect {
      anchors.fill: parent
      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      StyledText {
        anchors.centerIn: parent
        text: "Media (stub)"
      }
    }
  }

  component PerformancePane: Item {
    implicitWidth: 520
    implicitHeight: 320
    StyledRect {
      anchors.fill: parent
      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      StyledText {
        anchors.centerIn: parent
        text: "Performance (stub)"
      }
    }
  }

  component WeatherPane: Item {
    implicitWidth: 520
    implicitHeight: 320
    StyledRect {
      anchors.fill: parent
      radius: Appearance.rounding.large
      color: Colours.palette.m3surfaceContainer
      StyledText {
        anchors.centerIn: parent
        text: "Weather (stub)"
      }
    }
  }
}
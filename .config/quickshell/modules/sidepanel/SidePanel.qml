import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: root
  anchors.fill: parent

  property int inset: 18

  ColumnLayout {
    anchors.fill: parent

    anchors.leftMargin: Appearance.padding.normal + root.inset
    anchors.rightMargin: Appearance.padding.normal
    anchors.topMargin: Appearance.padding.normal
    anchors.bottomMargin: Appearance.padding.normal

    spacing: Appearance.spacing.small

    StyledText { text: "Sidepanel"; font.pixelSize: 16 }
    StyledText { text: "Tronco → ramas (WIP)" }
    Item { Layout.fillHeight: true }
  }
}
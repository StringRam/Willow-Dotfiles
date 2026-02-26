import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

Item {
  id: root
  implicitHeight: 5
  implicitWidth: 800

  RowLayout {
    anchors.fill: parent
    anchors.leftMargin: 12
    anchors.rightMargin: 12
    spacing: 10

    // placeholder: después movemos Workspaces/Tray/etc
    StyledText { text: "Willow" }

    Item { Layout.fillWidth: true }

    // reloj simple para confirmar visible
    StyledText { text: Qt.formatDateTime(new Date(), "HH:mm") }
  }
}
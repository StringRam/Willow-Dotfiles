import QtQuick
import QtQuick.Layouts
import "components"
import Quickshell

ColumnLayout {
  id: root
  spacing: 10
  anchors.margins: 6
  anchors.fill: parent

  // Para SystemTray (tu componente lo requiere)
  required property PanelWindow parentWindow

  Workspaces {
    Layout.alignment: Qt.AlignHCenter
  }

  Item { Layout.fillHeight: true } // spacer

  ClockWidget {
    Layout.alignment: Qt.AlignHCenter
  }

  Item { Layout.fillHeight: true } // spacer

  SystemTray {
    Layout.alignment: Qt.AlignHCenter
    parentWindow: root.parentWindow
  }

  BatteryIndicator {
    Layout.alignment: Qt.AlignHCenter
  }

  Text {
    text: "⌘"
    color: "#e5e5e5"
    font.pixelSize: 18
    horizontalAlignment: Text.AlignHCenter
    width: parent.width

    MouseArea {
      anchors.fill: parent
      onClicked: Visibility.toggleLauncher()
    }
  }
}
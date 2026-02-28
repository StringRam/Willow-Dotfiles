import QtQuick
import QtQuick.Layouts
import "components"
import Quickshell

ColumnLayout {
  id: root
  spacing: 10
  anchors.fill: parent

  // padding lateral base
  anchors.leftMargin: 5
  anchors.rightMargin: 5

  // ✅ padding extra arriba/abajo
  anchors.topMargin: 12
  anchors.bottomMargin: 12

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
}
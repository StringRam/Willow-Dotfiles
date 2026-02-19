import Quickshell
import QtQuick
import QtQuick.Layouts
import "components"

Scope {
  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 30

      RowLayout {
        anchors.fill: parent
        anchors.margins: 6

        Workspaces {
          id: workspaceDisplay
          Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        }

        Item { Layout.fillWidth: true }

        ClockWidget {
          id: clock
          Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }

        Item { Layout.fillWidth: true }

        SystemTray {
          id: systemTray
          Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }

        BatteryIndicator {
          id: batteryIndicator
          Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
      }
    }
  }
}
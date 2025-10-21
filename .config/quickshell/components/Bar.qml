import Quickshell
import QtQuick
import QtQuick.Layouts
import "components"
import "components/workspaces"

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

      // Barra principal
      RowLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 10

        Workspaces {
          id: workspaceDisplay
          count: 5
          Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
        }

        Item { Layout.fillWidth: true }

        ClockWidget {
          id: clock
          Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
        }

        Item { Layout.fillWidth: true }

        Tray {
          id: systemTray
          Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
      }
    }
  }
}

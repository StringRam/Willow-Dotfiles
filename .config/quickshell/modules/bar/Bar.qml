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
        right: true
        bottom: true
      }

      // Ancho de la barra (ajustá a gusto)
      implicitWidth: 44

      // Reservar espacio en el lado derecho
      // (con 3 anchors: top+right+bottom, el zone aplica)
      exclusiveZone: implicitWidth

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 6
        spacing: 10

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
        }

        BatteryIndicator {
          Layout.alignment: Qt.AlignHCenter
        }
      }
    }
  }
}
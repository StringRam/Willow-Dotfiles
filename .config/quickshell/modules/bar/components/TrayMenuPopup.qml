import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.components.containers

// Menú custom: overlay fullscreen + panel de menú
Scope {
  id: root

  // ===== API pública (la usa SystemTray.qml) =====
  property var menuHandle: null        // QsMenuHandle
  property int anchorX: 0
  property int anchorY: 0
  property int menuWidth: 320
  property int rowHeight: 34
  property int pad: 8
  property int radius: 12

  // Para multi-monitor: mostrarse solo en el screen de la barra
  property var targetScreen: null

  function closeMenu() { root.menuHandle = null }

  Variants {
    model: Quickshell.screens

    OverlayWindow {
      id: overlay
      required property var modelData
      screen: modelData
      name: "trayMenu"

      // Visible solo si hay menú y este es el screen correcto
      visible: root.menuHandle !== null && (root.targetScreen === null || root.targetScreen === modelData)

      // No robar foco
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      QsMenuOpener {
        id: opener
        menu: root.menuHandle
      }

      // Click afuera cierra
      MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onPressed: root.closeMenu()
      }

      Rectangle {
        id: bg
        x: root.anchorX
        y: root.anchorY
        width: root.menuWidth
        radius: root.radius
        clip: true
        color: "#141414"
        border.width: 1
        border.color: "#2a2a2a"

        implicitHeight: col.implicitHeight + root.pad * 2

        // Evitar que click adentro cierre
        MouseArea {
          anchors.fill: parent
          acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
          onPressed: (e) => e.accepted = true
        }

        Column {
          id: col
          x: root.pad
          y: root.pad
          width: bg.width - root.pad * 2
          spacing: 2

          Repeater {
            model: opener.children

            delegate: Item {
              id: row
              required property QsMenuEntry modelData

              width: col.width
              implicitHeight: modelData.isSeparator ? 10 : root.rowHeight

              Rectangle {
                visible: row.modelData.isSeparator
                x: 6
                width: row.width - 12
                height: 1
                y: 4
                color: "#2a2a2a"
              }

              Rectangle {
                id: itemBg
                anchors.fill: parent
                visible: !row.modelData.isSeparator
                radius: 8
                color: ma.containsMouse ? "#1f1f1f" : "transparent"
                opacity: row.modelData.enabled ? 1 : 0.45
              }

              RowLayout {
                anchors.fill: parent
                anchors.margins: 6
                spacing: 8
                visible: !row.modelData.isSeparator

                Text {
                  text: row.modelData.buttonType !== 0
                        ? (row.modelData.checkState === Qt.Checked ? "●" : "○")
                        : ""
                  color: "#cfcfcf"
                  Layout.preferredWidth: 16
                  horizontalAlignment: Text.AlignHCenter
                }

                Text {
                  text: row.modelData.text
                  color: "#e5e5e5"
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                Text {
                  text: row.modelData.hasChildren ? "›" : ""
                  color: "#9a9a9a"
                  Layout.preferredWidth: 14
                  horizontalAlignment: Text.AlignRight
                }
              }

              MouseArea {
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                enabled: !row.modelData.isSeparator && row.modelData.enabled

                onClicked: {
                  if (row.modelData.hasChildren) {
                    console.log("[tray menu] submenu:", row.modelData.text)
                    return
                  }
                  row.modelData.triggered()
                  root.closeMenu()
                }
              }
            }
          }
        }
      }
    }
  }
}
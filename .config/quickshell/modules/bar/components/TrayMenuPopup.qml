import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import qs.services
import qs.components.containers

Scope {
  id: root

  // ===== API pública =====
  property var menuHandle: null
  property int anchorX: 0
  property int anchorY: 0

  property int menuWidth: 320
  property int rowHeight: 34
  property int pad: 8
  property int radius: 12
  property int menuCount: 0

  property var targetScreen: null

  // ✅ margen de pantalla (mismo que gap de la barra)
  property int edgeMargin: 4

  function closeMenu() { root.menuHandle = null }

  // ✅ clamp helpers
  function clamp(v, lo, hi) { return Math.max(lo, Math.min(v, hi)) }

  // ✅ corrige anchorY cuando ya conocemos el alto real
  function adjustToScreen(menuH) {
    const sw = (root.targetScreen && root.targetScreen.width) ? root.targetScreen.width : 1920
    const sh = (root.targetScreen && root.targetScreen.height) ? root.targetScreen.height : 1080

    // X (por si acaso)
    root.anchorX = clamp(root.anchorX, root.edgeMargin, sw - root.menuWidth - root.edgeMargin)

    // Y usando alto REAL del bg
    const maxY = sh - menuH - root.edgeMargin
    root.anchorY = clamp(root.anchorY, root.edgeMargin, maxY)
  }

  Variants {
    model: Quickshell.screens

    OverlayWindow {
      id: overlay
      required property var modelData
      screen: modelData
      name: "trayMenu"

      visible: root.menuHandle !== null && (root.targetScreen === null || root.targetScreen === modelData)
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

      QsMenuOpener {
        id: opener
        menu: root.menuHandle
        onChildrenChanged: {
          root.menuCount = opener.children.length
          // cuando cambia el contenido, re-ajustar con alto real (luego del layout)
          Qt.callLater(() => root.adjustToScreen(bg.implicitHeight))
        }
        Component.onCompleted: {
          root.menuCount = opener.children.length
          Qt.callLater(() => root.adjustToScreen(bg.implicitHeight))
        }
      }

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
        color: Colours.palette.m3background
        border.width: 1
        border.color: Colours.palette.m3outline

        implicitHeight: col.implicitHeight + root.pad * 2

        // ✅ si el alto cambia (por ejemplo, otro menú), ajustar
        onImplicitHeightChanged: Qt.callLater(() => root.adjustToScreen(bg.implicitHeight))

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
                color: Colours.palette.m3outline
              }

              Rectangle {
                id: itemBg
                anchors.fill: parent
                visible: !row.modelData.isSeparator
                radius: 8
                color: ma.containsMouse ? Colours.palette.m3surfaceHighlight : "transparent"
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
                  color: Colours.palette.m3onSurfaceVariant
                  Layout.preferredWidth: 16
                  horizontalAlignment: Text.AlignHCenter
                }

                Text {
                  text: row.modelData.text
                  color: Colours.palette.m3onSurface
                  elide: Text.ElideRight
                  Layout.fillWidth: true
                }

                Text {
                  text: row.modelData.hasChildren ? "›" : ""
                  color: Colours.palette.m3onSurfaceMuted
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
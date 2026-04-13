pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.config
import qs.components.containers

Scope {
  Variants {
    model: Quickshell.screens

    OverlayWindow {
      required property var modelData
      screen: modelData
      name: "wallpaperPicker"

      visible: Visibility.wallpaperPickerOpen
      WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

      ModalOverlay {
        anchors.fill: parent
        open: Visibility.wallpaperPickerOpen
        requestClose: () => Visibility.wallpaperPickerOpen = false

        Rectangle {
          id: panel
          width: 660
          height: 540
          radius: Appearance.rounding.large
          color: Colours.palette.m3background
          border.width: 1
          border.color: Colours.palette.m3outline
          anchors.centerIn: parent

          // Consume clicks so they don't fall through to the scrim
          MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons }

          ColumnLayout {
            anchors.fill: parent
            anchors.margins: Appearance.padding.large
            spacing: Appearance.spacing.normal

            // ---- Header ----
            RowLayout {
              Layout.fillWidth: true

              Text {
                text: "Wallpapers"
                color: Colours.palette.m3onSurface
                font.family: Appearance.font.family.ui
                font.pixelSize: 16
                font.bold: true
              }

              Item { Layout.fillWidth: true }

              Text {
                text: Wallpapers.files.length + " imágenes"
                color: Colours.palette.m3onSurfaceVariant
                font.family: Appearance.font.family.ui
                font.pixelSize: Appearance.font.size.normal
              }
            }

            // ---- Búsqueda ----
            TextField {
              id: searchField
              Layout.fillWidth: true
              placeholderText: "Filtrar…"
              font.family: Appearance.font.family.ui

              Connections {
                target: Visibility
                function onWallpaperPickerOpenChanged() {
                  if (Visibility.wallpaperPickerOpen) {
                    searchField.text = ""
                    searchField.forceActiveFocus()
                    Wallpapers.scan()
                  }
                }
              }

              Keys.onPressed: (ev) => {
                if (ev.key === Qt.Key_Escape) {
                  Visibility.wallpaperPickerOpen = false
                  ev.accepted = true
                }
              }
            }

            // ---- Grid de thumbnails ----
            ScrollView {
              Layout.fillWidth: true
              Layout.fillHeight: true
              clip: true

              GridView {
                id: grid
                anchors.fill: parent

                readonly property int columns: 3
                cellWidth: Math.floor(width / columns)
                cellHeight: Math.floor(cellWidth * 9 / 16) + 28
                clip: true

                // Modelo: array filtrado de rutas
                model: {
                  const q = searchField.text.toLowerCase().trim()
                  if (q === "") return Wallpapers.files
                  return Wallpapers.files.filter(
                    f => f.split("/").pop().toLowerCase().includes(q)
                  )
                }

                delegate: Item {
                  id: cell
                  required property string modelData
                  required property int index

                  width: grid.cellWidth
                  height: grid.cellHeight

                  readonly property bool isCurrent: cell.modelData === Wallpapers.current

                  Rectangle {
                    id: thumb
                    anchors.fill: parent
                    anchors.margins: 4
                    radius: Appearance.rounding.normal
                    clip: true
                    color: Colours.palette.m3surfaceContainerLow

                    // Borde de selección
                    border.width: cell.isCurrent ? 2 : 0
                    border.color: Colours.palette.m3primary

                    // Imagen
                    Image {
                      id: img
                      anchors.top: parent.top
                      anchors.left: parent.left
                      anchors.right: parent.right
                      height: parent.height - nameLabel.height
                      source: "file://" + cell.modelData
                      fillMode: Image.PreserveAspectCrop
                      asynchronous: true
                      smooth: true
                    }

                    // Placeholder mientras carga
                    Rectangle {
                      anchors.fill: img
                      color: Colours.palette.m3surfaceContainerLow
                      visible: img.status === Image.Loading || img.status === Image.Error

                      Text {
                        anchors.centerIn: parent
                        text: img.status === Image.Error ? "✕" : "⋯"
                        color: Colours.palette.m3onSurfaceMuted
                        font.pixelSize: 18
                      }
                    }

                    // Nombre del archivo
                    Rectangle {
                      id: nameLabel
                      anchors.bottom: parent.bottom
                      anchors.left: parent.left
                      anchors.right: parent.right
                      height: 28
                      color: Qt.rgba(0, 0, 0, 0.6)

                      Text {
                        anchors.fill: parent
                        leftPadding: Appearance.padding.small
                        rightPadding: Appearance.padding.small
                        verticalAlignment: Text.AlignVCenter
                        text: cell.modelData.split("/").pop().replace(/\.[^.]+$/, "")
                        color: "white"
                        font.family: Appearance.font.family.ui
                        font.pixelSize: Appearance.font.size.smaller
                        elide: Text.ElideRight
                      }
                    }

                    // Overlay de hover
                    Rectangle {
                      anchors.fill: parent
                      radius: thumb.radius
                      color: Qt.rgba(1, 1, 1, thumbArea.containsMouse ? 0.08 : 0)

                      Behavior on color {
                        ColorAnimation { duration: 120 }
                      }
                    }

                    MouseArea {
                      id: thumbArea
                      anchors.fill: parent
                      hoverEnabled: true
                      cursorShape: Qt.PointingHandCursor
                      onClicked: Wallpapers.apply(cell.modelData)
                    }
                  }
                }
              }
            }

            // ---- Footer: wallpaper activo ----
            Text {
              Layout.fillWidth: true
              text: Wallpapers.current !== ""
                    ? "Activo: " + Wallpapers.current.split("/").pop()
                    : "Sin wallpaper activo"
              color: Colours.palette.m3onSurfaceMuted
              font.family: Appearance.font.family.ui
              font.pixelSize: Appearance.font.size.smaller
              elide: Text.ElideLeft
            }
          }
        }
      }
    }
  }
}

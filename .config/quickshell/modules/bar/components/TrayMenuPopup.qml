import Quickshell
import QtQuick
import QtQuick.Layouts

// Menú custom para SystemTrayItem.menu (QsMenuHandle)
PopupWindow {
  id: popup

  // Lo setea SystemTray
  required property PanelWindow parentWindow
  property var menuHandle: null   // QsMenuHandle
  property int anchorX: 0
  property int anchorY: 0
  property int maxWidth: 260

  visible: menuHandle !== null

  anchor.window: parentWindow
  anchor.rect.x: anchorX
  anchor.rect.y: anchorY

  // Lee children del menú actual
  QsMenuOpener {
    id: opener
    menu: popup.menuHandle
  }

  Rectangle {
    id: bg
    width: popup.maxWidth
    radius: 10
    color: "#141414"
    border.width: 1
    border.color: "#2a2a2a"

    // alto dinámico: suma delegates
    implicitHeight: col.implicitHeight + 12

    Column {
      id: col
      x: 6
      y: 6
      width: bg.width - 12
      spacing: 2

      Repeater {
        model: opener.children

        delegate: Item {
          id: row
          required property QsMenuEntry modelData

          width: col.width
          implicitHeight: modelData.isSeparator ? 9 : 30

          // Separador
          Rectangle {
            visible: row.modelData.isSeparator
            x: 6
            width: row.width - 12
            height: 1
            y: 4
            color: "#2a2a2a"
          }

          // Item normal
          Rectangle {
            id: itemBg
            anchors.fill: parent
            visible: !row.modelData.isSeparator
            radius: 8
            color: ma.containsMouse ? "#1f1f1f" : "transparent"
            opacity: row.modelData.enabled ? 1 : 0.5
          }

          RowLayout {
            anchors.fill: parent
            anchors.margins: 6
            spacing: 8
            visible: !row.modelData.isSeparator

            // Indicador checkbox/radio (mínimo)
            Text {
              text: row.modelData.buttonType !== 0
                    ? (row.modelData.checkState === Qt.Checked ? "●" : "○")
                    : ""
              color: "#cfcfcf"
              Layout.preferredWidth: 16
              horizontalAlignment: Text.AlignHCenter
            }

            // Texto
            Text {
              text: row.modelData.text
              color: "#e5e5e5"
              elide: Text.ElideRight
              Layout.fillWidth: true
            }

            // Flecha submenu
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
                // MVP: por ahora no abrimos submenú (lo hacemos en el siguiente paso)
                // podés loguear para ver cuáles lo requieren:
                console.log("[tray menu] submenu:", row.modelData.text)
                return
              }

              // Ejecutar acción del menú
              row.modelData.triggered()   // signal invocable en QML :contentReference[oaicite:2]{index=2}
              popup.menuHandle = null
            }
          }
        }
      }
    }
  }

  // Cerrar con Escape o click afuera (simple)
  Keys.onPressed: (e) => {
    if (e.key === Qt.Key_Escape) {
      popup.menuHandle = null
      e.accepted = true
    }
  }

  MouseArea {
    // click afuera: como PopupWindow no tiene overlay, usamos un truco:
    // si el popup pierde focus por click, normalmente se cierra en algunos setups,
    // pero para asegurar, podés cerrar con right click de nuevo desde el tray.
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
  }
}
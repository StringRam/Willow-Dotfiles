import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.services
import qs.components.containers
import qs.modules.launcher.components as UI

Item {
  id: root
  anchors.fill: parent

  // Historial persistente (rofi-like)
  PersistentProperties {
    id: hist
    reloadableId: "willowLauncherHistory"
    property var recentKeys: [] // ["app:firefox.desktop", "run:htop", ...]
  }

  function pushHistory(key) {
    if (!key) return
    const arr = hist.recentKeys ? hist.recentKeys.slice(0) : []
    const idx = arr.indexOf(key)
    if (idx >= 0) arr.splice(idx, 1)
    arr.unshift(key)
    // cap
    if (arr.length > 50) arr.length = 50
    hist.recentKeys = arr
  }

  function ensureFocus() {
    query.forceActiveFocus()
    query.selectAll()
  }

  function closeLauncher() { Visibility.launcherOpen = false }

  function setMode(m) {
    launcherModel.mode = m
    list.currentIndex = 0
  }

  function parseQuery(text) {
    const raw = (text || "")
    const t = raw.trim()

    if (t.startsWith(">") || t.startsWith(":")) return { mode: "run", q: t.slice(1).trim() }
    if (t.startsWith("w:") || t.startsWith("w ")) return { mode: "window", q: t.slice(2).trim() }
    if (t.startsWith("a:") || t.startsWith("a ")) return { mode: "drun", q: t.slice(2).trim() }
    if (t.startsWith("bg:") || t.startsWith("bg ")) return { mode: "wallpaper", q: t.slice(3).trim() }

    return { mode: launcherModel.mode, q: raw }
  }

  function execItem(obj) {
    if (!obj) return

    if (obj.kind === "app" && obj.entry) {
      pushHistory(obj.key)
      obj.entry.execute()
      closeLauncher()
      return
    }

    if (obj.kind === "win" && obj.client) {
      pushHistory(obj.key)
      const addr = obj.client.address || obj.client.addr || ""
      if (addr !== "") {
        Quickshell.execDetached(["sh", "-c", `hyprctl dispatch focuswindow address:${addr}`])
        closeLauncher()
      }
      return
    }

    if (obj.kind === "run") {
      const cmd = obj.command || ""
      if (cmd.trim() !== "") {
        pushHistory(obj.key)
        Quickshell.execDetached(["sh", "-lc", cmd])
        closeLauncher()
      }
      return
    }

    if (obj.kind === "wallpaper" && obj.path) {
      Wallpapers.apply(obj.path)
      closeLauncher()
      return
    }
  }

  function execSelected() {
    if (list.count <= 0) return
    const idx = Math.max(0, list.currentIndex)
    execItem(list.model.get(idx))
  }

  ModalOverlay {
    anchors.fill: parent
    open: Visibility.launcherOpen
    requestClose: closeLauncher

    Rectangle {
      id: panel
      width: 600
      height: 500
      radius: 16
      color: Colours.palette.m3background
      border.width: 1
      border.color: Colours.palette.m3outline
      anchors.centerIn: parent

      MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons }

      ColumnLayout {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        RowLayout {
          Layout.fillWidth: true
          spacing: 8

          Text {
            text: ({ drun: "Apps", window: "Windows", run: "Run", wallpaper: "Wallpapers" })[launcherModel.mode] ?? "Apps"
            color: Colours.palette.m3onSurfaceVariant
          }
          Item { Layout.fillWidth: true }
          Text { text: "Tab: modo  |  Ctrl+1/2/3/4  |  bg:  |  Esc"; color: Colours.palette.m3onSurfaceMuted }
        }

        TextField {
          id: query
          placeholderText: "Buscar…"
          Layout.fillWidth: true

          Connections {
            target: Visibility
            function onLauncherOpenChanged() {
              if (Visibility.launcherOpen) {
                query.text = ""
                list.currentIndex = 0
                ensureFocus()
                // refresco por si history cambió
                launcherModel.history = hist.recentKeys
              }
            }
          }

          onTextChanged: {
            const p = parseQuery(text)
            launcherModel.mode = p.mode
            launcherModel.filterText = p.q
            launcherModel.history = hist.recentKeys
            list.currentIndex = 0
          }

          Keys.onPressed: (ev) => {
            if (ev.key === Qt.Key_Escape) { closeLauncher(); ev.accepted = true; return }

            if (ev.key === Qt.Key_Down) { list.currentIndex = Math.min(list.count - 1, list.currentIndex + 1); ev.accepted = true; return }
            if (ev.key === Qt.Key_Up) { list.currentIndex = Math.max(0, list.currentIndex - 1); ev.accepted = true; return }

            if (ev.key === Qt.Key_Return || ev.key === Qt.Key_Enter) { execSelected(); ev.accepted = true; return }

            if (ev.key === Qt.Key_Tab) {
              const cycle = ["drun", "window", "run", "wallpaper"]
              const next = cycle[(cycle.indexOf(launcherModel.mode) + 1) % cycle.length]
              setMode(next)
              launcherModel.history = hist.recentKeys
              ev.accepted = true
              return
            }

            if (ev.modifiers & Qt.ControlModifier) {
              if (ev.key === Qt.Key_1) { setMode("drun"); launcherModel.history = hist.recentKeys; ev.accepted = true; return }
              if (ev.key === Qt.Key_2) { setMode("window"); launcherModel.history = hist.recentKeys; ev.accepted = true; return }
              if (ev.key === Qt.Key_3) { setMode("run"); launcherModel.history = hist.recentKeys; ev.accepted = true; return }
              if (ev.key === Qt.Key_4) { setMode("wallpaper"); launcherModel.history = hist.recentKeys; ev.accepted = true; return }
            }
          }
        }

        ListView {
          id: list
          Layout.fillWidth: true
          Layout.fillHeight: true
          clip: true
          spacing: 6
          currentIndex: 0

          model: UI.LauncherModel {
            id: launcherModel
            filterText: ""
            mode: "drun"
            limit: 70
            history: hist.recentKeys
          }

          delegate: Rectangle {
            width: ListView.view.width
            height: 46
            radius: 10

            readonly property bool active: (index === list.currentIndex)
            color: active ? Colours.palette.m3surfaceHighlight : (ma.containsMouse ? Colours.palette.m3surfaceContainerLow : "transparent")

            RowLayout {
              anchors.fill: parent
              anchors.margins: 10
              spacing: 10

              // Icono: thumbnail para wallpapers, icono de tema para el resto
              Item {
                width: 26
                height: 26
                Layout.alignment: Qt.AlignVCenter

                Image {
                  anchors.fill: parent
                  visible: model.kind === "wallpaper"
                  source: visible ? ("file://" + (model.path || "")) : ""
                  fillMode: Image.PreserveAspectCrop
                  asynchronous: true
                }

                IconImage {
                  anchors.fill: parent
                  visible: model.kind !== "wallpaper" && (model.icon || "") !== ""
                  source: visible ? Quickshell.iconPath(model.icon, true) : ""
                }
              }

              Text {
                Layout.fillWidth: true
                text: model.label
                color: Colours.palette.m3onSurface
                elide: Text.ElideRight
              }

              // Indicador de wallpaper activo
              Text {
                visible: model.kind === "wallpaper" && (model.path || "") === Wallpapers.current
                text: "✓"
                color: Colours.palette.m3primary
                font.pixelSize: 14
              }
            }

            MouseArea {
              id: ma
              anchors.fill: parent
              hoverEnabled: true
              onEntered: list.currentIndex = index
              onClicked: execItem(list.model.get(index))
            }
          }
        }
      }
    }
  }
}
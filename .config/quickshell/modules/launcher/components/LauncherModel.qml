import QtQuick
import Quickshell
import Quickshell.Hyprland

ListModel {
  id: root
  property string filterText: ""
  property string mode: "drun" // "drun" | "run" | "window"

  function rebuild() {
    clear()
    const q = (filterText || "").toLowerCase().trim()

    if (mode === "drun") {
      const apps = [...DesktopEntries.applications.values]
      for (let i = 0; i < apps.length; i++) {
        const e = apps[i]
        const name = (e.name || "").toLowerCase()
        if (q === "" || name.includes(q)) append({ kind: "app", entry: e, label: e.name })
        if (count >= 40) break
      }
      return
    }

    if (mode === "window") {
      const clients = [...Hyprland.clients.values] // en Hyprland QML suele ser .values
      for (let i = 0; i < clients.length; i++) {
        const c = clients[i]
        const title = (c.title || "")
        const klass = (c.class || "")
        const label = `${title} — ${klass}`.trim()
        if (q === "" || label.toLowerCase().includes(q)) append({ kind: "win", client: c, label })
        if (count >= 40) break
      }
      return
    }

    if (mode === "run") {
      // En run no “listamos” todo; solo mostramos una entrada “Run: …”
      if (q !== "") append({ kind: "run", label: `Run: ${filterText}` })
      return
    }
  }

  onFilterTextChanged: rebuild()
  onModeChanged: rebuild()
  Component.onCompleted: rebuild()
}
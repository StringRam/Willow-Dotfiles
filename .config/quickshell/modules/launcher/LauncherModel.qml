import QtQuick
import Quickshell

ListModel {
  id: root
  property string filterText: ""

  function rebuild() {
    clear()
    const q = (filterText || "").toLowerCase().trim()
    const apps = DesktopEntries.applications

    for (let i = 0; i < apps.length; i++) {
      const e = apps[i]
      const name = (e.name || "").toLowerCase()
      if (q === "" || name.indexOf(q) !== -1) {
        append({ entry: e })
      }
      if (count >= 30) break
    }
  }

  onFilterTextChanged: rebuild()
  Component.onCompleted: rebuild()
}
import QtQuick
import Quickshell
import Quickshell.Hyprland

ListModel {
  id: root

  property string filterText: ""
  property string mode: "drun" // "drun" | "run" | "window"
  property int limit: 60

  // Historial (keys) desde LauncherContent (PersistentProperties)
  property var history: [] // ej: ["app:firefox.desktop", "run:htop", ...]

  // --- fuzzy scoring ---
  function _isWordStart(s, idx) {
    if (idx <= 0) return true
    const c = s[idx - 1]
    return c === " " || c === "-" || c === "_" || c === "/" || c === "."
  }

  function fuzzyScore(query, text) {
    const q = (query || "").toLowerCase().trim()
    const t = (text || "").toLowerCase()

    if (q.length === 0) return 0

    let ti = 0
    let score = 0
    let streak = 0

    for (let qi = 0; qi < q.length; qi++) {
      const qc = q[qi]
      let found = -1
      while (ti < t.length) {
        if (t[ti] === qc) { found = ti; break }
        ti++
      }
      if (found === -1) return -1e9

      // base
      score += 10

      // bonus: consecutivo
      if (qi > 0 && found === (tiPrev + 1)) {
        streak += 1
        score += 18 + Math.min(12, streak * 2)
      } else {
        streak = 0
      }

      // bonus: inicio de palabra
      if (_isWordStart(t, found)) score += 16

      // penalización leve por saltos grandes
      if (qi > 0) score -= Math.min(8, Math.max(0, found - tiPrev - 1))

      var tiPrev = found
      ti = found + 1
    }

    // bonus: query corta y match temprano
    score += Math.max(0, 30 - (tiPrev || 0))
    return score
  }

  function historyBoost(key) {
    if (!history || history.length === 0) return 0
    const idx = history.indexOf(key)
    if (idx < 0) return 0
    // más reciente = más boost
    return 500 - idx * 8
  }

  function rebuild() {
    clear()
    const raw = filterText || ""
    const q = raw.trim()

    if (mode === "run") {
      if (q !== "") {
        const key = "run:" + q
        append({
          kind: "run",
          key,
          label: q,
          icon: "utilities-terminal",
          command: q,
          score: 100 + historyBoost(key)
        })
      }
      return
    }

    if (mode === "window") {
      const clients = [...Hyprland.clients.values]
      for (let i = 0; i < clients.length; i++) {
        const c = clients[i]
        const title = (c.title || "")
        const klass = (c.class || "")
        const label = `${title} — ${klass}`.trim()
        const key = "win:" + (c.address || c.addr || label)

        const s = fuzzyScore(q, label) + historyBoost(key)
        if (q === "" || s > -1e8) {
          append({
            kind: "win",
            key,
            label,
            icon: "window",
            client: c,
            score: s
          })
        }
      }

      // ordenar por score desc
      const arr = []
      for (let i = 0; i < count; i++) arr.push(get(i))
      arr.sort((a, b) => (b.score - a.score) || a.label.localeCompare(b.label))

      clear()
      for (let i = 0; i < arr.length && i < limit; i++) append(arr[i])
      return
    }

    // drun
    const apps = [...DesktopEntries.applications.values]
    const arr = []

    for (let i = 0; i < apps.length; i++) {
      const e = apps[i]
      const name = (e.name || "")
      const exec = (e.exec || "")
      const icon = (e.icon || "")
      const id = (e.desktopId || e.id || name)

      const label = name
      const key = "app:" + id

      // fuzzy sobre name + exec (rofi-like)
      const s = Math.max(
        fuzzyScore(q, name),
        fuzzyScore(q, exec)
      ) + historyBoost(key)

      if (q === "" || s > -1e8) {
        arr.push({
          kind: "app",
          key,
          label,
          icon,
          entry: e,
          score: s
        })
      }
    }

    arr.sort((a, b) => (b.score - a.score) || a.label.localeCompare(b.label))
    for (let i = 0; i < arr.length && i < limit; i++) append(arr[i])
  }

  onFilterTextChanged: rebuild()
  onModeChanged: rebuild()
  onHistoryChanged: rebuild()
  Component.onCompleted: rebuild()
}
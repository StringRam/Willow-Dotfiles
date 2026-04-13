pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  // Directorio donde viven los wallpapers (bash expande $HOME).
  // Editar aquí si usás un path diferente.
  readonly property string wallpaperDir: "$HOME/.config/hypr/Images"
  readonly property string hyprpaperConf: "$HOME/.config/hypr/hyprpaper.conf"

  // Lista de rutas absolutas, ordenadas, listas para usar como modelo.
  property var files: []

  // Wallpaper actualmente activo según hyprpaper.
  property string current: ""

  // ---- Escaneo de archivos ----

  Process {
    id: scanProc
    command: [
      "bash", "-c",
      `find "${root.wallpaperDir}" -type f \\( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \\) 2>/dev/null | sort`
    ]
    stdout: StdioCollector {
      onStreamFinished: {
        root.files = this.text
          .split("\n")
          .map(s => s.trim())
          .filter(s => s.length > 0)
      }
    }
  }

  function scan() {
    scanProc.running = true
  }

  // ---- Estado actual desde hyprpaper ----

  Process {
    id: listActiveProc
    command: ["hyprctl", "hyprpaper", "listactive"]
    stdout: StdioCollector {
      onStreamFinished: {
        // Formato de salida: "MONITOR = /ruta/al/wallpaper.png"
        const lines = this.text.split("\n").filter(l => l.includes(" = "))
        if (lines.length > 0) {
          const parts = lines[0].split(" = ")
          if (parts.length >= 2)
            root.current = parts.slice(1).join(" = ").trim()
        }
      }
    }
  }

  // ---- Aplicar wallpaper ----

  function apply(path) {
    if (!path) return
    const oldPath = root.current
    root.current = path

    // Precargar y activar vía IPC de hyprpaper.
    // La coma vacía antes del path aplica el wallpaper a todos los monitores.
    Quickshell.execDetached([
      "bash", "-c",
      `hyprctl hyprpaper preload '${path}' && hyprctl hyprpaper wallpaper ',${path}'`
    ])

    // Persistir en hyprpaper.conf para que sobreviva reinicios.
    Qt.callLater(() => {
      Quickshell.execDetached([
        "bash", "-c",
        `printf 'preload = %s\\nwallpaper = ,%s\\nipc = on\\n' '${path}' '${path}' > "${root.hyprpaperConf}"`
      ])
    })

    // Descargar el wallpaper anterior de la VRAM de hyprpaper.
    if (oldPath && oldPath !== path) {
      Qt.callLater(() => {
        Quickshell.execDetached(["hyprctl", "hyprpaper", "unload", oldPath])
      })
    }
  }

  Component.onCompleted: {
    scan()
    listActiveProc.running = true
  }
}

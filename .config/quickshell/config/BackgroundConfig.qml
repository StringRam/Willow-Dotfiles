pragma Singleton
import QtQuick

QtObject {
  id: root

  // Directorio donde viven los wallpapers.
  // $HOME se expande por bash al pasarlo en comandos de shell.
  readonly property string wallpaperDir: "$HOME/.config/hypr/Images"

  // Ruta del archivo de configuración de hyprpaper.
  readonly property string hyprpaperConf: "$HOME/.config/hypr/hyprpaper.conf"
}

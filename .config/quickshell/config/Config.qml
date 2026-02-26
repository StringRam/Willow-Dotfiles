pragma Singleton
import QtQuick

QtObject {
  id: root

  // Solo lo que necesitamos para el dashboard (por ahora)
  readonly property QtObject dashboard: QtObject {
    property bool enabled: true

    readonly property QtObject sizes: QtObject {
      // Podés retocar después
      readonly property int tabIndicatorSpacing: 6
      readonly property int weatherWidth: 240
      readonly property int infoWidth: 220
      readonly property int dateTimeWidth: 180
      readonly property int mediaWidth: 220
      readonly property int resourceSize: 140
    }
  }
}
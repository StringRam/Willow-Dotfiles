pragma Singleton
import QtQuick

QtObject {
  id: root

  // ---- spacing/padding/rounding ----
  readonly property QtObject spacing: QtObject {
    readonly property int small: 6
    readonly property int normal: 10
    readonly property int large: 16
  }

  readonly property QtObject padding: QtObject {
    readonly property int small: 6
    readonly property int normal: 10
    readonly property int large: 16
  }

  readonly property QtObject rounding: QtObject {
    readonly property int small: 8
    readonly property int normal: 12
    readonly property int large: 18
    readonly property int full: 999
  }

  // ---- fonts ----
  readonly property QtObject font: QtObject {
    readonly property QtObject size: QtObject {
      readonly property int smaller: 10
      readonly property int normal: 11
      readonly property int larger: 12
    }
    readonly property QtObject family: QtObject {
      readonly property string material: "Material Symbols Rounded"
      readonly property string ui: "Nunito Sans"
      readonly property string mono: "Source Code Pro"
    }
  }

  // ---- anim ----
  readonly property QtObject anim: QtObject {
    readonly property QtObject durations: QtObject {
      readonly property int normal: 140
      readonly property int large: 220
      readonly property int extraLarge: 320
      readonly property int expressiveDefaultSpatial: 220
    }

    readonly property QtObject curves: QtObject {
      readonly property var standard: [0.2, 0.0, 0.0, 1.0]
      readonly property var standardAccel: [0.3, 0.0, 1.0, 1.0]
      readonly property var standardDecel: [0.0, 0.0, 0.0, 1.0]
      readonly property var emphasized: [0.2, 0.0, 0.0, 1.0]
      readonly property var expressiveDefaultSpatial: [0.2, 0.0, 0.0, 1.0]
    }
  }
}
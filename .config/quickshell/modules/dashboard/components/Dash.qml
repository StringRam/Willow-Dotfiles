import qs.components
import qs.config
import qs.services
import QtQuick
import QtQuick.Layouts

GridLayout {
  id: root

  // Layout similar a Caelestia (cards)
  rowSpacing: Appearance.spacing.normal
  columnSpacing: Appearance.spacing.normal

  implicitWidth: 520
  implicitHeight: 320

  // Weather card (izq arriba)
  StyledRect {
    Layout.row: 0
    Layout.columnSpan: 2
    Layout.preferredWidth: Config.dashboard.sizes.weatherWidth
    Layout.fillHeight: true

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Weather card"
    }
  }

  // User card (arriba centro/derecha)
  StyledRect {
    Layout.column: 2
    Layout.columnSpan: 3
    Layout.preferredWidth: 260
    Layout.preferredHeight: 140

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainerHigh

    StyledText {
      anchors.centerIn: parent
      text: "User card"
    }
  }

  // DateTime (abajo izq)
  StyledRect {
    Layout.row: 1
    Layout.preferredWidth: Config.dashboard.sizes.dateTimeWidth
    Layout.fillHeight: true

    radius: Appearance.rounding.normal
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Date/Time"
    }
  }

  // Calendar (abajo centro)
  StyledRect {
    Layout.row: 1
    Layout.column: 1
    Layout.columnSpan: 3
    Layout.fillWidth: true
    Layout.preferredHeight: 140

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Calendar"
    }
  }

  // Resources (abajo derecha)
  StyledRect {
    Layout.row: 1
    Layout.column: 4
    Layout.preferredWidth: 140
    Layout.fillHeight: true

    radius: Appearance.rounding.normal
    color: Colours.palette.m3surfaceContainer

    StyledText {
      anchors.centerIn: parent
      text: "Resources"
    }
  }

  // Media (derecha full height)
  StyledRect {
    Layout.row: 0
    Layout.column: 5
    Layout.rowSpan: 2
    Layout.preferredWidth: 180
    Layout.fillHeight: true

    radius: Appearance.rounding.large
    color: Colours.palette.m3surfaceContainerHigh

    StyledText {
      anchors.centerIn: parent
      text: "Media"
    }
  }
}
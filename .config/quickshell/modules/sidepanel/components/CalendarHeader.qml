pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import qs.components
import qs.config
import qs.services

RowLayout {
  id: root

  required property date monthDate
  signal prev()
  signal next()

  spacing: Appearance.spacing.small

  function monthName(m) {
    const names = [
      "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio",
      "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
    ];
    return names[m] ?? "";
  }

  StyledText {
    text: monthName(root.monthDate.getMonth()) + " " + root.monthDate.getFullYear()
    font.bold: true
    font.pixelSize: 14
  }

  Item { Layout.fillWidth: true }

  Button {
    text: "‹"
    onClicked: root.prev()
  }

  Button {
    text: "›"
    onClicked: root.next()
  }
}

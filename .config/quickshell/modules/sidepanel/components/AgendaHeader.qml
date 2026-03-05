pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.components

RowLayout {
  id: root
  required property date date

  function fmt(d) {
    const dd = String(d.getDate()).padStart(2, '0');
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const yy = d.getFullYear();
    return dd + "/" + mm + "/" + yy;
  }

  StyledText {
    text: "Agenda — " + fmt(root.date)
    font.bold: true
    font.pixelSize: 14
  }

  Item { Layout.fillWidth: true }
}

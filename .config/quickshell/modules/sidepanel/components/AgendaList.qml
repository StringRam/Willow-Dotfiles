pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services

Item {
  id: root
  required property date date

  // máximo de elementos visibles antes de scrollear
  property int maxVisible: 4

  // mock local (fase 1)
  property var mockItems: [
    { title: "Revisar agenda", done: false },
    { title: "Estudiar 25 min", done: true },
    { title: "Commit del sidepanel", done: false },
    { title: "Limpiar backlog", done: false },
    { title: "Leer docs", done: false }
  ]

  // Ajuste simple: altura estimada por item (se mantiene estable)
  readonly property int _rowH: 44
  readonly property int _gap: Appearance.spacing.small
  readonly property int _maxH: (root.maxVisible * _rowH) + ((root.maxVisible - 1) * _gap)

  implicitHeight: Math.min(list.contentHeight, _maxH)

  ListView {
    id: list
    anchors.left: parent.left
    anchors.right: parent.right
    height: root.implicitHeight

    clip: true
    spacing: root._gap
    model: root.mockItems

    delegate: StyledRect {
      width: ListView.view.width
      radius: Appearance.rounding.normal
      color: Qt.rgba(1, 1, 1, 0.03)

      implicitHeight: root._rowH

      RowLayout {
        anchors.fill: parent
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.spacing.small

        CheckBox {
          checked: modelData.done
          onToggled: modelData.done = checked
        }

        StyledText {
          Layout.fillWidth: true
          text: modelData.title
          color: modelData.done
            ? Qt.rgba(Colours.palette.m3onSurface.r, Colours.palette.m3onSurface.g, Colours.palette.m3onSurface.b, 0.55)
            : Colours.palette.m3onSurface
          elide: Text.ElideRight
        }
      }
    }
  }

  // placeholder cuando no haya nada real
  StyledText {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: list.bottom
    anchors.topMargin: Appearance.spacing.small

    visible: root.mockItems.length === 0
    text: "(sin tareas para este día)"
    color: Qt.rgba(Colours.palette.m3onSurface.r, Colours.palette.m3onSurface.g, Colours.palette.m3onSurface.b, 0.65)
  }
}
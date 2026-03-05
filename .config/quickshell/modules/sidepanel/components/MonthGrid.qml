pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts

import qs.components
import qs.config
import qs.services

Item {
  id: root

  required property date monthDate
  required property date selectedDate
  signal selectDate(date d)

  readonly property var weekdays: ["L", "M", "X", "J", "V", "S", "D"]

  function daysInMonth(year, monthIndex) {
    return new Date(year, monthIndex + 1, 0).getDate();
  }

  function mondayIndex(jsDay) {
    return (jsDay + 6) % 7;
  }

  function sameDay(a, b) {
    return a.getFullYear() === b.getFullYear()
      && a.getMonth() === b.getMonth()
      && a.getDate() === b.getDate();
  }

  implicitHeight: col.implicitHeight

  ColumnLayout {
    id: col
    anchors.left: parent.left
    anchors.right: parent.right
    spacing: Appearance.spacing.tiny

    RowLayout {
      Layout.fillWidth: true
      spacing: 0

      Repeater {
        model: root.weekdays
        delegate: Item {
          Layout.fillWidth: true
          implicitHeight: 18
          Text {
            anchors.centerIn: parent
            text: modelData
            color: Qt.rgba(Colours.palette.m3onSurface.r, Colours.palette.m3onSurface.g, Colours.palette.m3onSurface.b, 0.75)
            font.family: Appearance.font.family.ui
            font.pixelSize: 10
          }
        }
      }
    }

    GridLayout {
      columns: 7
      rowSpacing: Appearance.spacing.tiny
      columnSpacing: Appearance.spacing.tiny
      Layout.fillWidth: true

      Repeater {
        model: 42

        delegate: DayCell {
          required property int index

          readonly property int _year: root.monthDate.getFullYear()
          readonly property int _month: root.monthDate.getMonth()
          readonly property int _dim: root.daysInMonth(_year, _month)

          readonly property int _firstJsDay: new Date(_year, _month, 1).getDay()
          readonly property int _firstCol: root.mondayIndex(_firstJsDay)

          readonly property int _dayNumber: index - _firstCol + 1
          readonly property bool _inMonth: _dayNumber >= 1 && _dayNumber <= _dim
          readonly property date _cellDate: new Date(_year, _month, Math.max(1, _dayNumber))

          readonly property bool _isToday: _inMonth && root.sameDay(_cellDate, new Date())
          readonly property bool _isSelected: _inMonth && root.sameDay(_cellDate, root.selectedDate)

          Layout.fillWidth: true

          dayNumber: _inMonth ? _dayNumber : 0
          inMonth: _inMonth
          isToday: _isToday
          isSelected: _isSelected

          onClicked: {
            if (!_inMonth) return;
            root.selectDate(new Date(_year, _month, _dayNumber));
          }
        }
      }
    }
  }
}
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.UPower

ColumnLayout {
    id: root
    spacing: 4

    property var batt: UPower.displayDevice
    property real pct: (batt && batt.ready) ? (batt.percentage * 100) : 0

    visible: batt && batt.ready && batt.isLaptopBattery

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: {
            if (!batt || !batt.ready) return ""
            var arrow = batt.state == 1 ? "⚡" : (batt.state == 2 ? "↓" : "•")
            return arrow + " " + Math.round(pct) + "%"
        }
    }
}
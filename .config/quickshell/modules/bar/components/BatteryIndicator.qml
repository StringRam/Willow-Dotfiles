import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.UPower

RowLayout {
    id: root
    spacing: 8
    implicitHeight: 18

    property var batt: UPower.displayDevice

    // en Quickshell: percentage = 0..1
    property real pct: (batt && batt.ready) ? (batt.percentage * 100) : 0

    visible: batt && batt.ready && batt.isLaptopBattery

    ProgressBar {
        Layout.preferredWidth: 80
        Layout.preferredHeight: 10
        Layout.alignment: Qt.AlignVCenter
        from: 0
        to: 100
        value: pct
    }

    Text {
        Layout.alignment: Qt.AlignVCenter
        text: {
            if (!batt || !batt.ready) return ""
            var arrow = batt.changeRate > 0 ? "⚡" : (batt.changeRate < 0 ? "↓" : "•")
            return arrow + " " + Math.round(pct) + "%"
        }
    }
}
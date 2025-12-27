// ClockWidget.qml
import QtQuick

Row {
  
    Text {
    // we no longer need time as an input property since we can
    // directly access the time property from the Time singleton
    text: Time.time
  }
}

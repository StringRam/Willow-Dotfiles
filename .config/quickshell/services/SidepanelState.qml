pragma Singleton
import QtQuick

QtObject {
  // 0 = Calendar, 1 = Schedule
  property int tabIndex: 0

  // +1 cuando vamos "a la derecha", -1 al revés
  property int slideDir: +1

  function toggle() {
    slideDir = (tabIndex === 0) ? +1 : -1
    tabIndex = (tabIndex === 0) ? 1 : 0
  }

  function tabLabel() {
    return tabIndex === 0 ? "Calendar" : "Schedule"
  }
}
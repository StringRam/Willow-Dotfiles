pragma Singleton
import QtQuick

QtObject {
  property int tabIndex: 0
  property int slideDir: +1

  function toggle() {
    slideDir = (tabIndex === 0) ? +1 : -1
    tabIndex = (tabIndex === 0) ? 1 : 0
  }

  function tabLabel() {
    return tabIndex === 0 ? "Calendar" : "Schedule"
  }
}
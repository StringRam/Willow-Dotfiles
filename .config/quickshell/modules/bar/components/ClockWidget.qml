import QtQuick
import qs.services

Column {
  spacing: 0

  Text {
    text: Time.hour
    verticalAlignment: Text.AlignHCenter
  }

  Text {
    text: Time.minute
    verticalAlignment: Text.AlignHCenter
  }
}
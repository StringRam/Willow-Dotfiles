import QtQuick
import qs.services

Column {
  spacing: 0

  Text {
    text: Time.hour
    color: Colours.palette.m3onSurface
    verticalAlignment: Text.AlignHCenter
  }

  Text {
    text: Time.minute
    color: Colours.palette.m3onSurface
    verticalAlignment: Text.AlignHCenter
  }
}
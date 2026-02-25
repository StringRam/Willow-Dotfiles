import QtQuick

SequentialAnimation {
  id: anim

  // El item que animás
  required property Item target

  // Config
  property real fromY: -22
  property real toY: 0
  property int duration: 180

  // Sugerencia: setear estado inicial antes de correr
  // target.y = fromY; target.opacity = 0;

  ParallelAnimation {
    NumberAnimation {
      target: anim.target
      property: "y"
      from: anim.fromY
      to: anim.toY
      duration: anim.duration
      easing.type: Easing.OutCubic
    }
    NumberAnimation {
      target: anim.target
      property: "opacity"
      from: 0
      to: 1
      duration: anim.duration
      easing.type: Easing.OutCubic
    }
  }
}
import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: window

    width: 640
    height: 480
    visible: true
    title: "Wataboard"
    font.family: biolinum.name

    FontLoader {
        id: biolinum
        source: "qrc:/assets/LinBiolinum_R.ttf"
    }

    WataBoard {
        anchors.fill: parent
        soundData: loadedSounds
    }
}

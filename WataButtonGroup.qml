import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Flow {
    id: flow
    property var buttonSoundData
    spacing: 16
    padding: 16
    Repeater {
        id: innerRepeater
        model: flow.buttonSoundData.length
        WataButton {
            soundData: flow.buttonSoundData[index]
            language: wataboard.language
        }
    }
}

import QtQuick
import QtMultimedia

Rectangle {
    id: button

    property var soundData
    property string language: "en"
    property int activePlayerCount: 0

    width: buttonText.width + 16
    height: buttonText.height + 16

    border.width: 2
    border.color: "white"
    gradient: Gradient {
        GradientStop { id: grad1; position: 0.0; color: "#fff29d" }
        GradientStop { id: grad2; position: 1.0; color: "#ffdb9d" }
    }

    radius: 4

    Text {
        id: buttonText
        text: soundData[button.language] || soundData["en"]
        anchors.centerIn: button
        font.pointSize: 14
        color: "#3b489b"
    }

    states: [
        State {
            name: "mouse-over";
            when: mouseArea.containsMouse || button.activePlayerCount > 0
            PropertyChanges {
                target: grad1
                color: "#ecf29e"
            }
            PropertyChanges {
                target: grad2
                color: "#fbfdbe"
            }
            PropertyChanges {
                target: button
                border.color: "#fb9cd5"
            }
            PropertyChanges {
                target: buttonText
                color: "#4b78c5"
            }
        }
    ]

    transitions: [
            Transition {
                to: "*"
                ColorAnimation { target: button; duration: 100 }
                ColorAnimation { target: buttonText; duration: 100 }
                ColorAnimation { target: grad1; duration: 100 }
                ColorAnimation { target: grad2; duration: 100 }
            }
    ]

    Component {
        id: mediaPlayerComponent
        MediaPlayer {
            id: player
            source: "qrc:/data/generated/"+soundData["file"]
            audioOutput: AudioOutput {}
            onPlaybackStateChanged: {
                if(player.playbackState === MediaPlayer.StoppedState) {
                    button.activePlayerCount--
                    player.destroy()
                }
            }
            Component.onCompleted: {
                button.activePlayerCount++
                player.play()
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if(useCppPlayer) {
                let player = cppPlayer.createInstance()
                button.activePlayerCount++
                player.finished.connect(function() {
                    button.activePlayerCount--
                })
                player.playThenDestroySelf(":/data/generated/"+soundData["file"])
            } else {
                mediaPlayerComponent.createObject(button)
            }
        }
    }
}

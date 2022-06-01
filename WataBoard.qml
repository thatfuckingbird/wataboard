import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material

Rectangle {
    Material.foreground: "#934c4c"

    id: wataboard
    width: parent.width

    property string language: langSwitch.checked ? "jp" : "en"
    required property var soundData

    FontLoader {
        id: biolinumBold
        source: "qrc:/assets/LinBiolinum_RB.ttf"
    }

    Rectangle {
        anchors.centerIn: parent
        width: 2 * Math.max(wataboard.width, wataboard.height)
        height: 2 * Math.max(wataboard.width, wataboard.height)
        rotation: 45
        gradient: Gradient {
            GradientStop { position: 0.7; color: "#fcd3a3" }
            GradientStop { position: 0.3; color: "#fcf5ad" }
        }
    }

    Image {
        source: "qrc:/assets/logo.png"
        anchors.centerIn: flickable
        height: Math.min(flickable.height * 0.6, sourceSize.height)
        width: Math.min(flickable.height * 0.6, sourceSize.height) * sourceSize.width / sourceSize.height
        mipmap: true
    }

    Image {
        id: watameImg
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: Math.min(sourceSize.height, 2 * parent.height / 3)
        width: Math.min(sourceSize.height, 2 * parent.height / 3) * sourceSize.width / sourceSize.height
        mipmap: true

        function randomizeWatame() {
            let images = ["qrc:/assets/watame1.png", "qrc:/assets/watame2.png", "qrc:/assets/watame3.png"]
            watameImg.source = images[Math.floor(Math.random() * 3)]
        }

        Component.onCompleted: randomizeWatame()
        visible: wataboard.width > wataboard.height
    }

    Row {
        id: titleRow
        anchors.horizontalCenter: wataboard.horizontalCenter
        anchors.top: wataboard.top
        Image {
            source: "qrc:/assets/watamate1.png"
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Text {
            padding: 0
            font.pointSize: 26
            font.family: biolinumBold.name
            font.bold: true
            text: "Wa"
            color: "#a58672"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Text {
            padding: 0
            font.pointSize: 26
            font.family: biolinumBold.name
            font.bold: true
            text: "ta"
            color: "#f09495"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Text {
            padding: 0
            font.pointSize: 26
            font.family: biolinumBold.name
            font.bold: true
            text: "bo"
            color: "#f8c979"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Text {
            padding: 0
            font.pointSize: 26
            font.family: biolinumBold.name
            font.bold: true
            text: "ar"
            color: "#a58672"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Text {
            padding: 0
            font.pointSize: 26
            font.family: biolinumBold.name
            font.bold: true
            text: "d"
            color: "#db4c48"
            verticalAlignment: Text.AlignVCenter
            anchors.verticalCenter: titleRow.verticalCenter
        }
        Image {
            source: "qrc:/assets/watamate2.png"
            anchors.verticalCenter: titleRow.verticalCenter
        }
    }

    Flickable {
        clip: true
        boundsMovement: Flickable.StopAtBounds
        id: flickable
        anchors.top: titleRow.bottom //wataboard.top
        anchors.bottom: langSwitch.height > bottomText.height ? langSwitch.top : bottomText.top
        width: parent.width

        contentHeight: mainArea.height
        contentWidth: mainArea.width

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOn
        }

        Column {
            id: mainArea
            width: wataboard.width < wataboard.height ? wataboard.width :  2 * wataboard.width / 3
            Repeater {
                model: wataboard.soundData.length
                Column {
                    width: mainArea.width
                    Row {
                        leftPadding: 16
                        Image {
                            source: "qrc:/assets/watabee.png"
                            height: sectionTitle.height
                            width: sourceSize.width * sectionTitle.height / sourceSize.height
                            anchors.verticalCenter: sectionTitle.verticalCenter
                        }
                        Text {
                            id: sectionTitle
                            text: wataboard.soundData[index]["title"][language] || wataboard.soundData[index]["title"]["en"]
                            font.pointSize: 24
                            font.family: biolinumBold.name
                            font.bold: true
                            padding: 4
                            antialiasing: true
                            color: "#886e5e"//"#251212"
                        }
                    }
                    Flow {
                        id: flow
                        width: mainArea.width
                        spacing: 16
                        padding: 16
                        property int outerIndex: index
                        Repeater {
                            model: wataboard.soundData[index]["sounds"].length
                            WataButton {
                                soundData: wataboard.soundData[flow.outerIndex]["sounds"][index]
                                language: wataboard.language
                            }
                        }
                    }
                }
            }
        }
    }

    Text {
        id: bottomText
        text: "❤️ Dedicated to <a href=\"https://www.youtube.com/channel/UCqm3BQLlJfvkTsX_hvm0UmA\">Tsunomaki Watame</a>. Source code <a href=\"#\">here</a>."
        onLinkActivated: Qt.openUrlExternally(link)
        anchors.left: wataboard.left
        anchors.bottom: wataboard.bottom
        padding: 4
        color: "#934c4c"
        linkColor: "#934c4c"

        MouseArea {
            anchors.fill: parent
            cursorShape: bottomText.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            acceptedButtons: Qt.NoButton
        }
        visible: wataboard.width > wataboard.height
    }

    Switch {
        id: langSwitch
        text: checked ? "English" : "日本語"
        anchors.bottom: wataboard.bottom
        anchors.right: wataboard.right
        padding: 4
    }

    Image {
        id: wataSmall
        source: smallMouseArea.containsMouse || smallMouseArea.containsPress ? "qrc:/assets/watasmall2.png" : "qrc:/assets/watasmall.png"
        height: Math.min(langSwitch.height, sourceSize.height)
        width: sourceSize.width * Math.min(langSwitch.height, sourceSize.height) / sourceSize.height
        anchors.bottom: wataboard.bottom
        anchors.right: langSwitch.left
        MouseArea {
            id: smallMouseArea
            hoverEnabled: true
            anchors.fill: parent
            onClicked: watameImg.randomizeWatame()
        }
    }

    Component.onCompleted: {
        if(Qt.locale().name.startsWith("jp")) {
            langSwitch.toggle()
        }
    }
}

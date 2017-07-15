import QtQuick 2.1
import Sailfish.Silica 1.0

Page {

    id: newgamePage

    property var transparency
    property int paddinglarge12:Theme.paddingLarge*1.2

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }

    Rectangle {

        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
        opacity:settings.setting("transparency");
        radius: 3
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: root.width
        contentHeight: screen.height * 2

        Image {
            id: logo
            source: "harbour-scocadigo.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -screen.height / 2
        }

        Label {
            id: pfeil
            anchors.horizontalCenter: logo.horizontalCenter
            anchors.verticalCenter: logo.verticalCenter
            anchors.verticalCenterOffset: Screen.width / 2
            font.pixelSize: 130
            opacity: 0.8
            text: "\uf078" //don't translate
        }

        Label {
            id: about_text
            font.family: bebasNeue.name
            anchors.horizontalCenter: logo.horizontalCenter
            anchors.verticalCenter: logo.verticalCenter
            anchors.verticalCenterOffset: screen.height / 1.4
            text: "°scocadigo° ver. 0.2 "//don't translate
            font.pixelSize: Theme.fontSizeLarge + 10
        }


        Label {
            id: by
            font.family: bebasNeue.name
            anchors.horizontalCenter: logo.horizontalCenter
            anchors.verticalCenter: logo.verticalCenter
            anchors.verticalCenterOffset: screen.height
            text: qsTr("by")+" Michael Johannes Muik"
            font.pixelSize: Theme.fontSizeMedium

            Text {
                anchors.top: by.bottom
                anchors.horizontalCenter: by.horizontalCenter
                anchors.topMargin: 15
                id: mailto
                font.pixelSize: Theme.fontSizeExtraSmall
                font.family: bebasNeue.name

                text:  "info@scocadigo.com"
                color: Theme.highlightColor

                MouseArea {
                    id: buttonMouseArea
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally(
                                   "mailto:info@scocadigo.com?subject=SCOCADIGO SAILFISHOS")
                }
            }
        }
        Label {
            id: infotext
            font.family: bebasNeue.name

            text: qsTr("SCOCADIGO is a scorecard app for Disc Golf. It is possible to add new players, courses and keep track of your Disc Golf rounds. Watch individual statistics and compare your scores with other players. Improve your game. Just play! Please be aware! you using an alpha version of scocadigo. There might be bugs! please report when you find one!")
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignJustify


            anchors {
                left: parent.left
                right: parent.right
                top: by.bottom
                margins: Theme.paddingLarge + 30
            }
            font.pixelSize: Theme.fontSizeExtraSmall
        }

        Image {
            id: flattr
            anchors.top: infotext.bottom
            anchors.topMargin: Theme.paddingLarge
            source: "flattr.png"
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                id: flattrbutton
                anchors.fill: flattr
                onClicked: Qt.openUrlExternally(
                               "https://flattr.com/profile/m_j_m")
            }
        }

        Text {
            id:license
            anchors.horizontalCenter: logo.horizontalCenter
            anchors.top:flattr.bottom
            font.family: bebasNeue.name
            anchors.topMargin: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("LICENSE: MIT ")
            color: Theme.highlightColor
            MouseArea {
                id : buttonMouseArea2
                anchors.fill : parent
                onClicked: Qt.openUrlExternally("https://github.com/mMjMm/harbour-scocadigo/blob/master/LICENSE")
            }
        }
    }
    Column {
        id: column
        width: root.width
        spacing: 3

        Item{
            id: topAbout
            width: root.width
            height: pageheader.height


            Rectangle {
                anchors.fill: parent
                opacity: settings.setting("transparency");

                color: "#50597b"
            }
            Image {
                id:newgameicon
                x: Theme.paddingLarge*2
                anchors.verticalCenter: topAbout.verticalCenter
                width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
                fillMode: Image.PreserveAspectFit
                source: "about.png"
            }
            Label {
                id: pageheader
                font.family: bebasNeue.name
                anchors{top:topAbout.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                text: qsTr("about")
                font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                color: "white"
                font.bold: true
                opacity: 1
            }
        }

        Item {
            id: scocadigo
            width: label.width+ Theme.paddingLarge*2
            height: label.height


            Rectangle {
                anchors.fill: parent
                opacity: settings.setting("transparency");
                color: "#50597b"
            }
            Label {
                id: label
                x: Theme.paddingLarge
                font.family: bebasNeue.name
                anchors{top:scocadigo.top;topMargin: Theme.paddingSmall}
                color: "white"
                opacity:1
                font.pixelSize: Theme.fontSizeExtraLarge
                text: "scocadigo"
            }
        }
    }
}

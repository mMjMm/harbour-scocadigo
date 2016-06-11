import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: newgamePage
    property int paddinglarge12:Theme.paddingLarge*1.2

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }

    RemorsePopup {
        id: remorse
    }
    function reset() {
        remorse.execute("DELETE EVERYTHING", function () {
            DB.dropAll()
            pageStack.replace(Qt.resolvedUrl("FirstPage.qml"))
        })
    }

    SilicaFlickable {

        anchors.fill: parent
        VerticalScrollDecorator {
        }
        PullDownMenu {

            MenuItem {
                text: qsTr("about")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }

            MenuItem {
                text: qsTr("delete all")
                onClicked: {
                  reset();
                }
            }
        }

        Rectangle {

            id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
            width: parent.width
            height: parent.height
            color: "#394264"
            opacity: 1
            radius: 3
        }

        Column {
            id: column
            width: root.width
            spacing: 3

            Rectangle {
                id: topAbout
                width: root.width
                height: pageheader.height
                color: "#50597b"
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
                    text: qsTr("settings")
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    color: "white"
                    font.bold: true
                }
  }
                Rectangle {
                    id: scocadigo
                    width: label.width+ Theme.paddingLarge*2
                    height: label.height
                    color: "#50597b"
                    Label {
                        id: label
                        x: Theme.paddingLarge
                        font.family: bebasNeue.name
                        anchors{top:scocadigo.top;topMargin: Theme.paddingSmall}
                        color: "white"
                        font.pixelSize: Theme.fontSizeExtraLarge
                        text: qsTr("ver.0.1 apha")
                    }
            }
        }
    }

    //displayed when no players in database
    Label {
        id: nogames
        font.family: bebasNeue.name
        text: "No settings to set"
        color: "white"
        x: Theme.paddingLarge
        anchors.horizontalCenter: newgamePage.horizontalCenter
        anchors.verticalCenter: newgamePage.verticalCenter
        font.pixelSize: Theme.fontSizeLarge + 35

        Label {
            font.family: bebasNeue.name
            text: "because this is an alpha version of scocadigo!"
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeSmall
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
        }
    }


}

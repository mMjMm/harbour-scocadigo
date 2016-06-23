import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: newgamePage
    property var transparency
    property bool tabsound

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
    Component.onCompleted: {


        if(settings.setting("tabsound")==="1")
        {
            soundswitch.checked=true
        }

        if(settings.setting("tabsound")==="0")
        {
            soundswitch.checked=false
        }

    }
        SilicaFlickable {

        anchors.fill: parent
        VerticalScrollDecorator {
        }
        PullDownMenu {


            MenuItem {
                text: qsTr("DELETE EVERYTHING")
                onClicked: {
                    reset();
                }
            }
            MenuItem {
                text: qsTr("ABOUT")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("About.qml"))
                }
            }

        }

        Rectangle {

            id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
            width: parent.width
            height: parent.height
            color: "#394264"
            opacity: settings.setting("transparency");
            radius: 3
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
                    id:topAboutrect
                    anchors.fill: parent
                    color: "#50597b"
                    opacity:settings.setting("transparency");
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
                    text: qsTr("settings")
                    opacity: 1
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    color: "white"
                    font.bold: true
                }
            }
        }

        Label {
            id: label
            x: Theme.paddingLarge
            font.family: bebasNeue.name
            anchors.top: column.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.right:root.right
            anchors.rightMargin: Theme.paddingLarge
            opacity:1
            color: "white"
            font.pixelSize: Theme.fontSizeExtraLarge
            text: qsTr("look & feel")
        }

        Slider {
            id:transparencyslider
            anchors.top: label.bottom
            anchors.topMargin: Theme.paddingLarge
            width: parent.width
            minimumValue: 0.1
            maximumValue: 1
            label:qsTr("TRANSPARENCY")
            value:settings.setting("transparency")
            valueText: value.toFixed(1)
            onValueChanged:{
                settings.setSetting("transparency", (transparencyslider.value).toFixed(1));
                root.opacity=transparencyslider.value
                topAboutrect.opacity=transparencyslider.value
            }
        }
        TextSwitch {
            id:soundswitch
            anchors.top:transparencyslider.bottom
            anchors.topMargin: Theme.paddingLarge
            automaticCheck:true
            checked:tabsound
            text: qsTr("SOUND FEEDBACK")
            description: qsTr("ENABLE/DISABLE ACOUSTIC FEEDBACK WHEN PRESSING [-][+] BUTTONS")
            onCheckedChanged: {
                (checked ? settings.setSetting("tabsound", 1) : settings.setSetting("tabsound", 0))

            }
        }
    }
}

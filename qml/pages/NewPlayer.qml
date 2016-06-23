import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Dialog {

    id: dialogplayer
    property var transparency

    //acceptDestination:mainPage
    acceptDestination: Qt.resolvedUrl("FirstPage.qml")
    acceptDestinationAction: PageStackAction.Replace
    visible: false

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        VerticalScrollDecorator {
        }

        Item{
            id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
            width: parent.width
            height: parent.height * 2

            Rectangle {
                anchors.fill: parent
                opacity: settings.setting("transparency");
                color: "#394264"
            }

            Column {
                id: column
                width: root.width
                DialogHeader {
                    acceptText: qsTr("SAVE")
                }
                Column {
                    id: colummm
                    spacing: 15
                    width: parent.width

                    TextField {
                        id: nickName
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhNoPredictiveText
                        color: "white"
                        placeholderText: qsTr("Nick")
                        opacity: 1
                        label: qsTr("Nick")
                        focus: true
                        maximumLength: 8
                        EnterKey.enabled: text.length > 0
                        EnterKey.onClicked: {
                            firstName.focus = true
                        }

                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true
                            }
                        }
                    }

                    TextField {
                        id: firstName
                        color: "white"
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText: qsTr("First name")
                        label:qsTr( "First name")
                        opacity: 1
                        maximumLength: 23
                        EnterKey.onClicked: {
                            lastName.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true
                            }
                        }
                    }
                    TextField {
                        id: lastName
                        color: "white"
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText: qsTr("Last name")
                        label: qsTr("Last name")
                        opacity: 1
                        maximumLength: 23
                        EnterKey.onClicked: {
                            email.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true
                            }
                        }
                    }
                    TextField {
                        id: email
                        color: "white"
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
                        placeholderText: qsTr("Email")
                        label: qsTr("Email")
                        opacity: 1
                        EnterKey.onClicked: {
                            pdga.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true
                            }
                        }
                    }

                    TextField {
                        id: pdga
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                        opacity: 1
                        placeholderText: qsTr("PDGA Nr")
                        label:qsTr( "PDGA Nr")
                        EnterKey.onClicked: {
                            notes.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true

                            }
                        }
                    }
                    TextArea {
                        id: notes
                        font.family: bebasNeue.name
                        width: parent.width
                        placeholderText: qsTr("Notes")
                        label: qsTr("Notes")

                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: settings.setting("transparency");
                                color: "#3c7ea7"
                                smooth: true

                            }
                        }
                    }
                }
            }
        }
    }

    onAccepted: {
        //   DB.insertNAME(nickName.text, 1 , firstName.text, lastName.text, email.text, notes.text, Math.floor((Math.random() * 100) + 1) ,Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1), Math.floor((Math.random() * 100) + 1));
        DB.insertNAME(nickName.text, 1, firstName.text, lastName.text,
                      email.text, notes.text, pdga.text, 0, 0, 0)
    }
}

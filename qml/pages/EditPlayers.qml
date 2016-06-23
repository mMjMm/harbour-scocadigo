import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Dialog {


    //things which to edit
    property string nickNameEdit
    property string firstNameEdit
    property string lastNameEdit
    property string pdgaEdit
    property string emailEdit
    property string notesEdit
    property var transparency

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    acceptDestination: Qt.resolvedUrl("FirstPage.qml")

    acceptDestinationAction: PageStackAction.Replace
    visible: false

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
            //edit PLAYER INPUT
        }
            Column {
                id: column
                width: root.width
                DialogHeader {
                    acceptText: qsTr("SAVE CHANGES")
                }
                Column {
                    id: colummm
                    spacing: 15
                    width: parent.width

                    TextField {
                        id: nickName
                        color: "white"
                        font.family: bebasNeue.name
                        width: parent.width
                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText: qsTr("Nick")
                        text: nickNameEdit
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
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true
                            }
                        }
                    }


                    TextField {
                        id: firstName
                        color: "white"
                        width: parent.width
                        font.family: bebasNeue.name
                        inputMethodHints: Qt.ImhNoPredictiveText
                        placeholderText:qsTr( "First name")
                        label: qsTr("First name")
                        opacity: 1
                        text: firstNameEdit
                        EnterKey.onClicked: {
                            lastName.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true
                            }
                        }
                    }

                    TextField {
                        id: lastName
                        color: "white"
                        width: parent.width
                        inputMethodHints: Qt.ImhNoPredictiveText
                        maximumLength: 23
                        font.family: bebasNeue.name
                        label: qsTr("Last name")
                        placeholderText: qsTr("Last name")
                        text: lastNameEdit
                        opacity: 1
                        EnterKey.onClicked: {
                            email.focus = true
                        }

                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true
                            }
                        }
                    }

                    TextField {
                        id: email
                        color: "white"
                        width: parent.width
                        inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
                        placeholderText: qsTr("Email")
                        font.family: bebasNeue.name
                        text: emailEdit
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
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true
                            }
                        }
                    }

                    TextField {
                        id: pdga
                        width: parent.width
                        inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhNoPredictiveText
                        placeholderText: "PDGA Nr"
                        font.family: bebasNeue.name
                        label: qsTr("PDGA Nr")
                        opacity: 1
                        EnterKey.onClicked: {
                            notes.focus = true
                        }

                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true
                            }
                        }
                    }

                    TextArea {
                        id: notes
                        width: parent.width
                        font.family: bebasNeue.name
                        color: "white"
                        placeholderText:qsTr( "Notes")
                        label: qsTr("Notes")
                        text: notesEdit

                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: "#3c7ea7"
                                opacity: settings.setting("transparency");
                                smooth: true

                            }
                        }
                    }
                }
            }
        }
    }

    onAccepted: {

        DB.editPlayer(nickNameEdit, nickName.text, firstName.text,
                      lastName.text, pdga.text, email.text, notes.text)
        //  DB.editPlayer(nickNameEdit, nickName.text ,firstNameEdit,firstName.text, lastNameEdit, lastName.text, emailEdit, email.text, notesEdit, notes.text);
    }
}

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

        Rectangle {
            id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
            width: parent.width
            height: parent.height * 2
            color: "#394264"
            //edit PLAYER INPUT
            Column {
                id: column
                width: root.width
                DialogHeader {
                    acceptText: "SAVE CHANGES"
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
                        placeholderText: "Nick"
                        text: nickNameEdit
                        label: "Nick"
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
                        placeholderText: "First name"
                        label: "First name"
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
                        label: "Last name"
                        placeholderText: "Last name"
                        text: lastNameEdit
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
                                smooth: true
                            }
                        }
                    }


                    TextField {
                        id: email
                        color: "white"
                        width: parent.width
                        inputMethodHints: Qt.ImhEmailCharactersOnly | Qt.ImhNoPredictiveText
                        placeholderText: "Email"
                        font.family: bebasNeue.name
                        text: emailEdit
                        label: "Email"

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
                        label: "PDGA Nr"
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
                                smooth: true
                            }
                        }
                    }

                    TextArea {
                        id: notes
                        width: parent.width
                        font.family: bebasNeue.name
                        color: "white"
                        placeholderText: "Notes"
                        label: "Notes"
                        text: notesEdit
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
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

        DB.editPlayer(nickNameEdit, nickName.text, firstName.text,
                      lastName.text, pdga.text, email.text, notes.text)
        //  DB.editPlayer(nickNameEdit, nickName.text ,firstNameEdit,firstName.text, lastNameEdit, lastName.text, emailEdit, email.text, notesEdit, notes.text);
    }
}

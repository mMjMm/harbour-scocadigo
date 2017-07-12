import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Dialog {
    id: newCoursePage
    visible: false
    property string coursename
    property int baskets

    property var transparency: 0.2;

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }

    Component.onCompleted: {
        DB.initialize();
        howmandybaskets.text = 1
        canAccept = false
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        VerticalScrollDecorator {
        }

        Item{
            id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
            width: parent.width
            height: newCoursePage.height

        Rectangle {
            anchors.fill: parent
            opacity: transparency
            color: "#394264"
    }
            Column {
                id: column
                width: root.width
                DialogHeader {
                    id: dialogHeader
                    acceptText: qsTr("SAVE")
                }

                Column {
                    id: colummm
                    spacing: 15
                    width: parent.width

                    Label {
                        id: coursenamelabel
                        color: "white"
                        x: Theme.paddingLarge
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeMedium
                        width: colummm.width
                        opacity: 1
                        text: qsTr("Course name:")
                    }

                    TextField {
                        id: courseName
                        font.family: bebasNeue.name
                        width: parent.width
                        color: "white"
                        maximumLength: 20// 12
                        placeholderText: qsTr("Course name")
                        inputMethodHints: Qt.ImhNoPredictiveText

                        onTextChanged: {
                            var tester = DB.checkCourseName(courseName.text)

                            if (howmandybaskets.text >= 1 & tester === 1) {
                                courseName.color = "white"
                                courseName.font.bold = false
                                canAccept = true
                            }
                            else {
                                banner.notify(qsTr("The course name already exists"));
                                canAccept = false;
                                courseName.font.bold = true;
                                courseName.color = Theme.highlightBackgroundColor;
                            }
                        }
                        focus: true
                        EnterKey.enabled: text.length > 0
                        EnterKey.onClicked: {
                            howmandybaskets.focus = true
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: transparency
                                color: "#d15a67"
                                smooth: true
                            }
                        }
                    }
                    Label {
                        color: "white"
                        font.family: bebasNeue.name
                        x: Theme.paddingLarge
                        text: qsTr("Number of baskets:")
                        opacity:1
                        font.pixelSize: Theme.fontSizeMedium
                        width: colummm.width
                    }

                    TextField {
                        id: howmandybaskets
                        inputMethodHints: Qt.ImhFormattedNumbersOnly
                        validator: IntValidator {
                            bottom: 1
                            top: 99
                        }
                        font.family: bebasNeue.name
                        color: "white"
                        width: parent.width
                        placeholderText: qsTr("Baskets")

                        onTextChanged: {

                            var tester = DB.checkCourseName(courseName.text)
                            if (howmandybaskets.text >= 1 & tester === 1) {
                                canAccept = true
                            }
                            else {
                                canAccept = false
                            }
                        }
                        background: Component {
                            Rectangle {
                                id: customBackground
                                width: parent.width-(Theme.paddingLarge*1.5)
                                height: parent.height
                                anchors.horizontalCenter: parent.horizontalCenter
                                opacity: transparency
                                color: "#d15a67"
                                smooth: true
                            }
                        }
                    }
                }
            }
        }
    }


    Banner {
        id: banner
    }
    acceptDestination: Qt.resolvedUrl("DefinePar.qml");
    acceptDestinationProperties: {"newCoursespage": newCoursePage}

    onAcceptPendingChanged: {
        if (acceptPending === true) {
//          Tell the destination page what the selected category is
            coursename = courseName.text
            baskets = parseInt(howmandybaskets.text)
        }
    }

    onRejected: {
        DB.deleteCourse(coursename)
    }
}

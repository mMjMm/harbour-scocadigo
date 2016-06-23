import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: coursesPage
    property int paddinglarge12:Theme.paddingLarge*1.2
    property var transparency

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }
    function reset() {
        remorse.execute("DELETE ALL COURSES", function () {
            DB.dropCourses()
            pageStack.replace(Qt.resolvedUrl("Courses.qml"))
        })
    }
    //reset counter animation?
    RemorsePopup {
        id: remorse
    }
    //Emitted after component "startup" has completed. This can be used to execute script code at startup, once the full QML environment has been established.
    Component.onCompleted: {

        DB.initialize()
        DB.getCourses()
    }
    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        opacity: settings.setting("transparency");
        color: "#394264"
    }

    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "Delete all courses"
                onClicked: {
                    reset()
                    DB.initialize()
                }
            }
            MenuItem {
                text: "add courses"
                onClicked: {
                    pageStack.replace(Qt.resolvedUrl("NewCourses.qml"))
                    //pageStack.replaceAbove(null, "NewCourses.qml")
                }
            }
        }
        Column {
            id: column
            width: root.width
            spacing: 3

            Item {
                id: topcourses
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
                    anchors.verticalCenter: topcourses.verticalCenter
                    width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
                    fillMode: Image.PreserveAspectFit
                    source: "courseicon.png"
                }
                Label {
                    id: pageheader
                    font.family: bebasNeue.name
                    anchors{top:topcourses.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                    text: qsTr("courses")
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    color: "white"
                    opacity: 1
                    font.bold: true
                }
            }
        }
        ListModel {
            id: courses
        }
        SilicaListView {

            id: listView
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem

            VerticalScrollDecorator {
                flickable: listView
            }
            HorizontalScrollDecorator {
                flickable: listView
            }
            anchors{fill: parent;topMargin: column.height +Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            spacing: Theme.paddingSmall

            model: courses

            delegate: ListItem {
                id: delegate
                contentHeight: nameLabel.height + basketslabel.height +info.height +Theme.paddingLarge
                width: namescourses.width
                visible: true
                menu: contextMenuComponent
                //DELETE FUNKTION (löscht gewählten namen aus der datenbank)
                function remove() {
                    delegate.remorseAction("Deleting", function () {
                        DB.deleteCourse(coursename)
                        courses.remove(index)
                    })
                }
                onClicked: {
                    // console.log("clicked")
                }

                Rectangle {
                    id: namescourses
                    width: screen.width - 50
                    height: parent.height
                    opacity: settings.setting("transparency");
                    color: "#d15a67"
                }

                ListView.onRemove: animateRemoval(delegate)
                Label {
                    id: nameLabel
                    anchors.top: namescourses.top
                    anchors.topMargin: Theme.paddingMedium
                    anchors.left: namescourses.left
                    anchors.leftMargin: Theme.paddingMedium
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeMedium
                    opacity: 1
                    font.bold: true
                    text: coursename
                }
                Label {
                    id: basketslabel
                    anchors.left: namescourses.left
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.top: nameLabel.bottom
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
                    text: "Baskets:" + baskets
                }
                Label {
                    id: info
                    anchors.left: namescourses.left
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.top: basketslabel.bottom
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
                    text: "Par: " + totalpar
                }

                Label {
                    id: infoLabe
                    anchors.horizontalCenter: namescourses.horizontalCenter
                    anchors.top: nameLabel.bottom
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
                    text: "Course Record: " + DB.getBestScoreCourse(coursename)+ "\nAverage-score: "+ DB.getAverageCourse(coursename)
                }

                Label {
                    id: infoLabel2
                    anchors.horizontalCenter: namescourses.horizontalCenter
                    anchors.horizontalCenterOffset: namescourses.width/3
                    anchors.top: nameLabel.bottom
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
                    text:"Played: " + played
                }




                function editcourse() {
                    pageStack.replace(Qt.resolvedUrl("EditCourses.qml"), {
                                          nickNameEdit: nickname,
                                          firstNameEdit: firstname,
                                          lastNameEdit: lastname,
                                          emailEdit: email,
                                          notesEdit: notes
                                      })
                }

                //CONTEXT MENÜ
                Component {
                    id: contextMenuComponent
                    ContextMenu {
                        id: contextMenu
                        width: delegate.width+Theme.paddingMedium
                        MenuItem {
                            text: "Delete"
                            onClicked: remove()
                        }
                    }
                }
            }
        }
    }

    //displayed when no courses in database
    Label {
        id: nocourses
        visible: listView.count == 0
        font.family: bebasNeue.name
        text: "No courses"
        color: "white"
        x: Theme.paddingLarge
        anchors.horizontalCenter: coursesPage.horizontalCenter
        anchors.verticalCenter: coursesPage.verticalCenter
        font.pixelSize: Theme.fontSizeLarge + 35

        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: "pull down to add a new course"
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
        }
    }
}

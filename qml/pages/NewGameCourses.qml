import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB
Page {
    id: coursesPage
    property int padding_12:Theme.paddingLarge*1.2
    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }
    Component.onCompleted: {
        DB.getCourses()
    }
    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "add courses"
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewCourses.qml"))
                }
            }
        }
        Column {
            id: column
            width: root.width
            spacing: 3
            Rectangle {
                id: topnewgame
                width: root.width
                height: pageheader.height
                color: "#50597b"
                Image {
                    id:newgameicon
                    x: Theme.paddingLarge*2
                    anchors.verticalCenter:topnewgame.verticalCenter
                    width:pageheader.height-padding_12; height:pageheader.height-padding_12
                    fillMode: Image.PreserveAspectFit
                    source: "newgameIcon.png"
                }
                Label {
                    id: pageheader
                    anchors{top:topnewgame.top;topMargin: Theme.paddingMedium;left: newgameicon.right;leftMargin: Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    font.bold: true

                    text: qsTr("new game")
                }
            }
            Rectangle {
                id: selectplayers
                width: label.width+ Theme.paddingLarge*2
                height: label.height
                color: "#50597b"
                Label {
                    id: label
                    x: Theme.paddingLarge
                    font.family: bebasNeue.name
                    anchors{top:selectplayers.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    text: qsTr("select course")
                }
            }
        }
        ListModel {
            id: courses
        }
        SilicaListView {
            id: listView
            VerticalScrollDecorator {
                flickable: listView
            }
            HorizontalScrollDecorator {
                flickable: listView
            }
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            anchors{fill: parent; topMargin: column.height +Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            spacing: Theme.paddingSmall
            model: courses
            delegate: ListItem {
                id: delegate
                contentHeight: nameLabel.height + nameLabel.height + basketslabel.height
                width: namescourses.width
                visible: true
                onClicked: {
                    pageStack.replace(Qt.resolvedUrl("Round.qml"), {
                                          coursename: coursename,
                                          totalpar: totalpar,
                                          baskets: baskets
                                      })
                }
                Rectangle {
                    id: namescourses
                    width: screen.width - 50
                    height: parent.height
                    color: "#50597b"
                }

                ListView.onRemove: animateRemoval(delegate)
                Label {
                    id: nameLabel
                    anchors{top: namescourses.top;topMargin: Theme.paddingMedium;left: namescourses.left;leftMargin: Theme.paddingMedium}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraLarge
                    text: coursename
                }
                Label {
                    id: basketslabel
                    anchors{left: namescourses.left;leftMargin: Theme.paddingMedium;top: nameLabel.bottom}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "Baskets:" + baskets
                }
                Label {
                    id: info
                    anchors{left: namescourses.left;leftMargin: Theme.paddingMedium;top: basketslabel.bottom;}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "PAR: " + totalpar
                }
                Label {
                    id: infoLabel
                    anchors{right: namescourses.right;rightMargin: Theme.paddingLarge;top: namescourses.top;topMargin: Theme.paddingMedium;}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "Top-score: " + DB.getBestScoreCourse(coursename)+ "\nAverage-score: "+ DB.getAverageCourse(coursename) + "\nPlayed: " + played
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
        anchors{horizontalCenter: coursesPage.horizontalCenter;verticalCenter: coursesPage.verticalCenter}
        font.pixelSize: Theme.fontSizeLarge + 35
        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: "pull down to add a new course"
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors{horizontalCenter: parent.horizontalCenter;top: parent.bottom}
        }
    }
}

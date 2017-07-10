import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB
Page {
    id: coursesPage
    property int padding_12:Theme.paddingLarge*1.2
    property var transparency

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
        opacity: settings.setting("transparency");
    }
    SilicaFlickable {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: qsTr("ADD COURSES")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewCourses.qml"))
                }
            }
        }
        Column {
            id: column
            width: root.width
            spacing: 3
            Item {
                id: topnewgame
                width: root.width
                height: pageheader.height

                Rectangle {
                    anchors.fill:parent
                    opacity: settings.setting("transparency");
                    color: "#50597b"
                }
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
                    opacity: 1
                    text: qsTr("new game")
                }
            }
            Item{
                id: selectplayers
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
                    anchors{top:selectplayers.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    opacity: 1
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
                Item{
                    id: namescourses
                    width: screen.width - 50
                    height: parent.height

                    Rectangle {
                        anchors.fill: parent
                        opacity: settings.setting("transparency");
                        color: "#50597b"
                    }

                    ListView.onRemove: animateRemoval(delegate)
                    Label {
                        id: nameLabel
                        anchors{top: namescourses.top;topMargin: Theme.paddingMedium;left: namescourses.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraLarge
                        font.bold: true
                        opacity: 1
                        text: coursename
                    }
                    Label {
                        id: basketslabel
                        anchors{left: namescourses.left;leftMargin: Theme.paddingMedium;top: nameLabel.bottom}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: 1
                        text: qsTr("Baskets: %1").arg(baskets)
                    }
                    Label {
                        id: info
                        anchors{left: namescourses.left;leftMargin: Theme.paddingMedium;top: basketslabel.bottom;}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: 1
                        text: qsTr("Par: %1").arg(totalpar)
                    }
                    Label {
                        id: infoLabel
                        anchors.horizontalCenter: namescourses.horizontalCenter
                        anchors.top: nameLabel.bottom
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: 1
                        text: qsTr("Top score: %1").arg(DB.getBestScoreCourse(coursename))+ "\n" + qsTr("Average score: %L1").arg(DB.getAverageCourse(coursename))
                    }

                    Label {
                        id: infoLabel2
                        anchors.horizontalCenter: namescourses.horizontalCenter
                        anchors.horizontalCenterOffset: namescourses.width/3
                        anchors.top: nameLabel.bottom
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraSmall
                        opacity: 1
                        text: qsTr("Played: %1").arg(played)
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
        text: qsTr("No courses")
        color: "white"
        x: Theme.paddingLarge
        anchors{horizontalCenter: coursesPage.horizontalCenter;verticalCenter: coursesPage.verticalCenter}
        font.pixelSize: Theme.fontSizeLarge + 35
        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: qsTr("pull down to add a new course")
            color: "white"
            opacity: 1
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors{horizontalCenter: parent.horizontalCenter;top: parent.bottom}
        }
    }
}

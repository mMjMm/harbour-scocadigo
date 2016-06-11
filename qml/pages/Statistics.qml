import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: statisticsPage
    property int paddinglarge12:Theme.paddingLarge*1.2

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }


    //Emitted after component "startup" has completed. This can be used to execute script code at startup, once the full QML environment has been established.
    Component.onCompleted: {
        DB.initialize()
        DB.getGamesbyDate()
    }


    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
    }


    SilicaFlickable {
        anchors.fill: parent
        /*  PullDownMenu {
            MenuItem {
                text: qsTr("sortBy")
                onClicked: {
                             }
            }
        }   */

    //model: score
    ListModel {
        id: score

    }
    // To enable PullDownMenu, place our content in a SilicaFlickable
    Column {
        id: column
        width: root.width
        spacing: 3

        Rectangle {
            id: topPlayers
            width: root.width
            height: pageheader.height
            color: "#50597b"
            Image {
                id:newgameicon
                x: Theme.paddingLarge*2
                anchors.verticalCenter: topPlayers.verticalCenter
                width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
                fillMode: Image.PreserveAspectFit
                source: "statisticsicon.png"
            }
            Label {
                id: pageheader
                font.family: bebasNeue.name
                anchors{top:topPlayers.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                text: qsTr("scorecards")
                font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                color: "white"
                font.bold: true
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
                text: qsTr("sorted by date")
            }
        }
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
        model: score
        delegate: ListItem {
            id: delegate
            contentHeight: courseNameAndPar.height+time_played.height+playerlabel.height+Theme.paddingLarge+Theme.paddingMedium
            width: names.width
            visible: true
            //menu: contextMenuComponent
            //DELETE FUNKTION (löscht gewählten namen aus der datenbank)
            function remove() {
                delegate.remorseAction("Deleting", function () {
                    DB.deletePlayer(nickname)
                    player.remove(index)
                })
            }

            onClicked: {

                //animate Opacity when button is pressed
                // animateOpacity.start()
                //debugging
                //console.log("debug nickname:" + nickname)
            }

            //Background rectangele for players info
            Rectangle {
                id: names
                width: screen.width - 50
                height: parent.height
                color: "#007b97"
               // opacity: index % 2 == 0 ? 0.7 : 1

            }

            ListView.onRemove: animateRemoval(delegate)

            Label {
                id: courseNameAndPar
                anchors.top: names.top
                anchors.topMargin: Theme.paddingMedium
                anchors.left: names.left
                anchors.leftMargin: Theme.paddingMedium
                font.family: bebasNeue.name
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                text: coursename + " " +  "("+ coursepar+")"
            }

            Label {
                id: date
                anchors.top: names.top
                anchors.right: names.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.topMargin: Theme.paddingMedium
                font.family: bebasNeue.name
                font.pixelSize: Theme.fontSizeMedium
                font.bold: true
                text: datum
            }

            Label {
                id: time_played
                anchors.right: names.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.top: date.bottom
                font.family: bebasNeue.name
                font.pixelSize: Theme.fontSizeExtraSmall
                text:timeplayed
            }

            Label {
                id: best_score
                anchors.left: names.left
                anchors.leftMargin: Theme.paddingMedium
                font.family: bebasNeue.name
                anchors.top: courseNameAndPar.bottom
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "course record " + bestscore
            }

            Label {
                id: playerlabel
                anchors.top: best_score.bottom
                anchors.topMargin: Theme.paddingMedium
                anchors.left:names.left
                anchors.leftMargin: Theme.paddingMedium
                font.family: bebasNeue.name
                font.pixelSize: Theme.fontSizeSmall
                width:names.width/1.2
                wrapMode: Text.WordWrap
                text: players
            }

            //CONTEXT MENÜ
           /* Component {
                id: contextMenuComponent
                ContextMenu {
                    id: contextMenu
                    width: delegate.width+Theme.paddingMedium

                    MenuItem {
                        text: "Delete"
                    }
                    MenuItem {
                        text: "Edit"
                    }
                }
            }*/
        }
    }
    }





    //displayed when no players in database
    Label {
        id: nogames
        visible: listView.count == 0
        font.family: bebasNeue.name
        text: "No games played"
        color: "white"
        x: Theme.paddingLarge
        anchors.horizontalCenter: statisticsPage.horizontalCenter
        anchors.verticalCenter: statisticsPage.verticalCenter
        font.pixelSize: Theme.fontSizeLarge + 35

        Label {
            visible: listView.count == 0
            font.family: bebasNeue.name
            text: "play a round of disc golf! And come back!"
            color: "white"
            x: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeMedium
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
        }
    }


}
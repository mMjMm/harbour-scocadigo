import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: statisticsPage
    property int paddinglarge12:Theme.paddingLarge*1.2
    property var transparency

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
        opacity: settings.setting("transparency");
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

        ListModel {
            id: playerstotalpar
        }

        ListModel {
            id: players

        }

        ListModel {
            id: result
        }

        Column {
            id: column
            width: root.width
            spacing: 3

            Item{
                id: topPlayers
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
                    opacity: 1
                    font.bold: true
                }

            }

            Item{
                id: selectplayers
                width: label.width+ Theme.paddingLarge*2
                height: label.height
                Rectangle {
                    anchors.fill:parent
                    color: "#50597b"
                    opacity: settings.setting("transparency");
                }
                Label {
                    id: label
                    x: Theme.paddingLarge
                    font.family: bebasNeue.name
                    anchors{top:selectplayers.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    opacity: 1
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
                menu:ContextMenu {
                    id: contextMenu
                    width: delegate.width+Theme.paddingMedium

                    MenuItem {
                        text: "Delete"
                        onClicked: remove()
                    }

                }

                function remove() {
                    delegate.remorseAction("Deleting", function () {
                        DB.deleteGame(res_id)
                        score.remove(index)
                    })
                }

                onClicked: {
                    pageStack.push(Qt.resolvedUrl("CreatedScorecard.qml"), {
                                       coursename: coursename,
                                       coursepar: coursepar,
                                       datum: datum,
                                       uhrzeit:uhrzeit,
                                       timeplayed:timeplayed,
                                       res_id:res_id,
                                   })

                    //                    console.log("debug getSpielerIdbyRESID: " + DB.getSpielerIDbyResId(res_id))

                }

                //Background rectangele for players info
                Rectangle {
                    id: names
                    width: screen.width - 50
                    height: parent.height
                    color: "#007b97"
                    opacity: settings.setting("transparency");
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
                    opacity: 1
                    text: coursename + " " + "("+ coursepar+")"
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
                    opacity: 1
                    text: datum
                }





                Label {
                    id: time_played
                    anchors.right: names.right
                    anchors.rightMargin: Theme.paddingMedium
                    anchors.top: date.bottom
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
                    text:uhrzeit+" "+timeplayed
                }

                Label {
                    id: best_score
                    anchors.left: names.left
                    anchors.leftMargin: Theme.paddingMedium
                    font.family: bebasNeue.name
                    anchors.top: courseNameAndPar.bottom
                    font.pixelSize: Theme.fontSizeExtraSmall
                    opacity: 1
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
                    opacity: 1
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

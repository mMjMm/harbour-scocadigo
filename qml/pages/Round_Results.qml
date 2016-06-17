import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    id: round
    property string coursename
    property string elapsedTime
    property var elapsed2
    property int totalparr
    property ListModel player
    property int courseid
    property var nickname
    property var baskets
    property var totalpar

    property var howmanyplayers
    property var n
    property var q
    property var basketParArray: []
    property var playersTotalPar: []
    property var playersTotalParHelp: []
    property var totalparplayer: []
    property var totalparplayerend: []

    property int coverspacing:-20;
    property int coverfontsize: Theme.fontSizeLarge

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }

    Component.onCompleted: {
        nickname = DB.getNickNameAddedSelected()
        // append player model (nickname and playerstotalpar)
        for (q = 0; q < howmanyplayers; q++) {
            player.append({
                              nickname: nickname[q],
                              playerstotalpar: mainPage.totalplayerpar[q]
                          })
        }
        //calculate elapsed time and convert to sce,min
        var elapsed = new Date().getTime() - mainPage.start
        var minutes = parseInt((elapsed / (1000 * 60)) % 60)
        var hours = parseInt((elapsed / (1000 * 60 * 60)) % 24)
        hours = (hours < 10) ? "0" + hours : hours
        minutes = (minutes < 10) ? "0" + minutes : minutes
        elapsed2 = elapsed
        elapsedTime = hours.toString() + "h " + minutes.toString() + "min "
        //init values for totalparplayer array and totalparplayerend array
        for (q = 0; q < howmanyplayers; q++) {
            totalparplayer[q] = 0
            totalparplayerend[q] = 0
        }

        for (n = 0; n < baskets; n++) {
            basketParArray[n] = DB.getPar((n + 1), courseid)
            for (q = 0; q < howmanyplayers; q++)
            {
                playersTotalPar[q] = (mainPage.playersbasketpar[n][q] - basketParArray[n])
                totalparplayer[q] = mainPage.playersbasketpar[n][q] + totalparplayer[q]
            }
        }
    }

    onStatusChanged: {


        if(howmanyplayers>4)
        {
            coverspacing=-40;
            coverfontsize= Theme.fontSizeMedium
         if(howmanyplayers>6)
            {
                coverspacing=-55;
                coverfontsize= Theme.fontSizeExtraSmall
            }
        }
        mainWindow.cover = roundCover



        if (status === PageStatus.Activating) {
            for (var q = 0; q < howmanyplayers; q++) {
                totalparplayerend[q] = totalparplayer[q] - totalparr
                player.setProperty(q, "playerstotalpar",
                                   mainPage.totalplayerpar[q])
            }
        }





        if (status === PageStatus.Active) {
            pageStack.pushAttached(Qt.resolvedUrl("Round_Scorecard.qml"), {
                                       coursename: coursename,
                                       totalpar: totalpar,
                                       courseid:courseid,
                                       baskets: baskets,
                                       howmanyplayers: howmanyplayers,
                                       nickname: nickname,
                                       elapsedTime: elapsedTime,
                                       elapsed2: elapsed2
                                   })
        }
    }
    Component {
        id: roundCover
        CoverBackground {
            Rectangle {
                id: rootcover
                width: parent.width
                height: parent.height
                color: "#394264"
            }

            Image {
                source: "../cover/background_cover.png"
                anchors.bottom: rootcover.bottom;
                anchors.right: rootcover.right;
                anchors.rightMargin:  Theme.paddingMedium;
            }

            Rectangle {
                id: scocadigorect
                width: rootcover.width
                height: pageheader.height+Theme.paddingMedium
                color:"#11a8ab"

                Text {
                    id: pageheader
                    anchors { left: scocadigorect.left; leftMargin: Theme.paddingMedium; top:scocadigorect.top;topMargin:Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.bold: true
                    text: "Endresult:"
                }
            }


            Rectangle {
                id: parrect
                width: par.width+Theme.paddingLarge+Theme.paddingLarge
                anchors.top:scocadigorect.bottom
                height: par.height+Theme.paddingSmall
                color:"#11a8ab"

                Text {
                    id: par
                    anchors { left: parrect.left;leftMargin: Theme.paddingMedium; top:parrect.top;topMargin: Theme.paddingSmall;}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    text: "Time " + elapsedTime
                }
            }

            ListView{
                id:coverlist
                model: player
                anchors.top: parrect.bottom;
                anchors.topMargin: Theme.paddingLarge;
                anchors.left: scocadigorect.left;
                anchors.leftMargin: Theme.paddingMedium;

                height:rootcover.height-scocadigorect.height;
                spacing:coverspacing;
                delegate: ListItem {

                    Text {
                        id: players
                        font.family: bebasNeue.name
                        color: "white"
                        font.pixelSize: coverfontsize
                        font.bold: true
                        text:  nickname + " "+  player.get(index).playerstotalpar
                    }
                }
            }
        }
    }



/////////////////////////////





    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
    }

    SilicaFlickable {
        anchors.fill: round

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
                    id: newgameicon
                    x: Theme.paddingLarge*2
                    anchors.verticalCenter:topnewgame.verticalCenter
                    width: pageheader.height-Theme.paddingLarge*1.2; height: pageheader.height-Theme.paddingLarge*1.2
                    fillMode: Image.PreserveAspectFit
                    source: "newgameIcon.png"
                }

                Label {
                    id: pageheader
                    anchors{top:topnewgame.top;topMargin: Theme.paddingMedium;left: newgameicon.right;leftMargin: Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeSmall
                    text: coursename
                    font.bold: true

                }
                Label {
                    font.family: bebasNeue.name
                    anchors{baseline: pageheader.baseline;left: pageheader.right;leftMargin:Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeSmall
                    text: " (" + totalpar + ")"
                }
            }
            Rectangle {
                id: infolabelpars
                width: label.width+ timelabel.width+Theme.paddingLarge*2
                height: label.height
                color: "#50597b"

                Label {
                    id: label
                    x: Theme.paddingLarge
                    font.family: bebasNeue.name
                    anchors{top: infolabelpars.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    text: qsTr("ENDRESULTS:")

                }

                Label {
                    id: timelabel
                    font.family: bebasNeue.name
                    anchors{left: label.right;leftMargin: Theme.paddingSmall;bottom:label.bottom;bottomMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeLarge
                    text: elapsedTime
                }
            }
        }

        ListModel {
            id: player
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
            anchors{fill: parent;topMargin: column.height+ Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            spacing: Theme.paddingSmall
            model: player
            delegate: ListItem {
                id: delegate
                contentHeight: nameLabel.height+ personalBest.height+ personalAverage.height+ personalNumberPlayed.height + Theme.paddingLarge
                width: names.width
                height: names.height

                Rectangle {
                    id: names
                    width: screen.width - 50
                    height: parent.height
                    color: "#50597b"
                }

                Label {
                    id: nameLabel
                    anchors{top: names.top;topMargin: Theme.paddingMedium;left: names.left;leftMargin: Theme.paddingMedium}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.bold: false
                    text: nickname
                }
                Label {
                    id: personalBest
                    anchors{top: nameLabel.bottom;left: names.left;leftMargin: Theme.paddingMedium}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "Top- score: " + DB.getBestplayerCourse(coursename,nickname)
                }

                Label {
                    id: personalAverage
                    anchors{left: names.left;leftMargin: Theme.paddingMedium;top: personalBest.bottom}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "Average-score: " + DB.getAveragePlayerCourse(nickname,coursename)
                }
                Label {
                    id: personalNumberPlayed
                    anchors{left: names.left;leftMargin: Theme.paddingMedium;top: personalAverage.bottom}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeSmall
                    text: "Number-played: " + DB.getAmountPlayedPlayer(coursename, nickname)
                }
                Label {
                    id: endresult
                    anchors{right: names.right;rightMargin: Theme.paddingLarge;verticalCenter: names.verticalCenter;verticalCenterOffset: Theme.paddingLarge}
                    font.family: bebasNeue.name
                    font.pixelSize: Theme.fontSizeExtraLarge + 80
                    font.bold: true
                    text: player.get(index).playerstotalpar
                }
            }
        }
    }
}

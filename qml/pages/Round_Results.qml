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

        //change font size of cover depending on how many players
        if(howmanyplayers>4)
        {
            coverspacing=-40;
            coverfontsize= Theme.fontSizeMedium

            if(howmanyplayers>6)
            {
                coverspacing=-45;
                coverfontsize= Theme.fontSizeSmall
            }

            if(howmanyplayers>7)
            {
                coverspacing=-50;
                coverfontsize= Theme.fontSizeExtraSmall
            }

            if(howmanyplayers>8)
            {
                coverspacing=-55;
                coverfontsize= Theme.fontSizeExtraSmall
            }
        }
        //ROUNDCOVER
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
                opacity: settings.setting("transparency");
            }

            Image {
                source: "../cover/background_coverround.png"
                anchors.bottom: rootcover.bottom;
                anchors.right: rootcover.right;
                anchors.rightMargin:  Theme.paddingMedium;
            }
            Item{
                id: scocadigorect
                width: rootcover.width
                height: pageheader.height+Theme.paddingMedium
                Rectangle {

                    anchors.fill: parent
                    opacity: settings.setting("transparency");
                    color:"#11a8ab"
                }

                Text {
                    id: pageheader
                    anchors { left: scocadigorect.left; leftMargin: Theme.paddingMedium; top:scocadigorect.top;topMargin:Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    font.bold: true
                    opacity: 1
                    text: qsTr("Endresult:")
                }
            }

            Item{
                id: parrect
                width: par.width+Theme.paddingLarge+Theme.paddingLarge
                anchors.top:scocadigorect.bottom
                height: par.height+Theme.paddingSmall

                Rectangle {
                    anchors.fill: parent
                    color:"#11a8ab"
                    opacity: settings.setting("transparency");
                }
                Text {
                    id: par
                    anchors { left: parrect.left;leftMargin: Theme.paddingMedium; top:parrect.top;topMargin: Theme.paddingSmall;}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    opacity: 1
                    text: qsTr("Time: ") + elapsedTime
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
                width: roundCover.width/2.5
                spacing:coverspacing;

                delegate: ListItem {

                    Text {
                        id: players
                        font.family: bebasNeue.name
                        color: "white"
                        font.pixelSize: coverfontsize
                        font.bold: true
                        text:  nickname
                        opacity: 1
                    }
                }
            }

            ListView{
                id:coverlists
                model: player
                anchors.top: parrect.bottom;
                anchors.topMargin: Theme.paddingLarge;
                anchors.right: scocadigorect.right;
                anchors.rightMargin: Theme.paddingLarge;
                width: roundCover.width/3.2
                height:rootcover.height-scocadigorect.height;
                spacing:coverspacing;

                delegate: ListItem {

                    Text {
                        id: playerpar
                        font.family: bebasNeue.name
                        color: "white"
                        font.pixelSize: coverfontsize
                        font.bold: true
                        width:parent.width
                        horizontalAlignment:Text.AlignRight
                        text: player.get(index).playerstotalpar
                        opacity: 1
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
        opacity: settings.setting("transparency");
    }

    SilicaFlickable {
        anchors.fill: round

        Column {
            id: column
            width: root.width
            spacing: 3

            Item{
                id: topnewgame
                width: root.width
                height: pageheader.height

                Rectangle {
                    anchors.fill: parent
                    color: "#50597b"
                    opacity: settings.setting("transparency");
                }
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
                    width: screen.width-(newgameicon.width*3.2)
                    font.family: bebasNeue.name
                    anchors{top:topnewgame.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeSmall
                    color: "white"
                    opacity: 1
                    font.bold: true
                    truncationMode: TruncationMode.Fade
                    text: coursename
                }
                Label {
                    font.family: bebasNeue.name
                    anchors{baseline: pageheader.baseline;right: topnewgame.right;rightMargin: Theme.paddingLarge+Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeSmall
                    opacity: 1
                    text: " (" + totalpar + ")"
                }
            }

            Item{

                id: infolabelpars
                width: label.width+ timelabel.width+Theme.paddingLarge*2
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
                    anchors{top: infolabelpars.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeExtraLarge
                    opacity: 1
                    text: qsTr("ENDRESULTS:")
                }

                Label {
                    id: timelabel
                    font.family: bebasNeue.name
                    anchors{left: label.right;leftMargin: Theme.paddingSmall;bottom:label.bottom;bottomMargin: Theme.paddingSmall}
                    color: "white"
                    font.pixelSize: Theme.fontSizeLarge
                    opacity: 1
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

                Item{
                    id: names
                    width: screen.width - 50
                    height: parent.height

                    Rectangle {
                        anchors.fill: parent
                        color: "#50597b"
                        opacity: settings.setting("transparency");
                    }

                    Label {
                        id: nameLabel
                        anchors{top: names.top;topMargin: Theme.paddingMedium;left: names.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraLarge
                        font.bold: false
                        opacity: 1
                        text: nickname
                    }
                    Label {
                        id: personalBest
                        anchors{top: nameLabel.bottom;left: names.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Top- score: ") + DB.getBestplayerCourse(coursename,nickname)
                    }

                    Label {
                        id: personalAverage
                        anchors{left: names.left;leftMargin: Theme.paddingMedium;top: personalBest.bottom}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Average-score: ")+ DB.getAveragePlayerCourse(nickname,coursename)
                    }
                    Label {
                        id: personalNumberPlayed
                        anchors{left: names.left;leftMargin: Theme.paddingMedium;top: personalAverage.bottom}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Number-played: ") + DB.getAmountPlayedPlayer(coursename, nickname)
                    }
                    Label {
                        id: endresult
                        anchors{right: names.right;rightMargin: Theme.paddingLarge;verticalCenter: names.verticalCenter;verticalCenterOffset: Theme.paddingLarge}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraLarge + 80
                        font.bold: true
                        opacity: 1
                        text: player.get(index).playerstotalpar
                    }
                }
            }
        }
    }
}

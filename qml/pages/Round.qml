import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB
import QtMultimedia 5.0

Page {
    id: round

    property string coursename
    property int basketnummer: 1
    //property ListModel players
    property ListModel statistic
    property int courseid
    property var nickname
    property var playersbasketpar: []
    //get from NewGameCourses.qml
    property int totalpar
    property int baskets
    property var basketpar
    property int howmanyplayers
    property var basketnummerarray

    property int padding1_2:Theme.paddingLarge*1.2;
    property int paddinglarge12:Theme.paddingLarge*1.2

    property int coverspacing:-20;
    property int coverfontsize: Theme.fontSizeLarge

    property var transparency
    property var tabsound

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }
    function reset() {
        remorse.execute(qsTr("CANCEL ROUND"), function () {
            pageStack.clear()
            pageStack.replace(Qt.resolvedUrl("FirstPage.qml"))
        })
    }

    RemorsePopup {
        id: remorse
    }

    backNavigation: true



    Component.onCompleted: {

        tabsound= settings.setting("tabsound")
       // console.log("tabsound: " +tabsound )

        if (mainPage.globalindex < 1) {
            howmanyplayers = DB.getcountSelectet()
            courseid= DB.getCourseID(coursename)
            nickname = DB.getNickNameAddedSelected()
        }

        basketpar = DB.getPar((basketnummer), courseid)

        if (mainPage.globalindex < depth) {
            //console.log("Seite "+ basketnummer+ " ROUND ONE first ENTER");
            if (basketnummer === 1) {
                mainPage.start = new Date().getTime()
            }
            basketnummerarray = basketnummer - 1
            //console.log("howmanyplayers: "+ howmanyplayers + " basketnummerarray: " + basketnummerarray+ " basketpar:  " + basketpar);
            for (var q = 0; q < howmanyplayers; q++) {
                mainPage.playersbasketpar[basketnummerarray][q] = basketpar
                // //console.log(mainPage.playersbasketpar[basketnummerarray][q] )
            }
        }
        for (q = 0; q < howmanyplayers; q++) {
            playersbasketpar[q] = basketpar
            if (basketnummer === 1) {
                //console.log("basket one!!!)")
                mainPage.totalplayerpar[q] = 0
            }
            player.append({
                              nickname: nickname[q],
                              playersbasketpar: playersbasketpar[q],
                              playerstotalpar: mainPage.totalplayerpar[q]
                          })
        }

    }

    onStatusChanged: {



        if (status === PageStatus.Active) {
            if (mainPage.globalindex < pageStack.depth) {
                //FIRST_OPEN
                //console.log("Seite "+ basketnummer+ " ROUND ONE first ENTER");
                pageStack.pushAttached(Qt.resolvedUrl("Round.qml"), {
                                           coursename: coursename,
                                           courseid:courseid,
                                           totalpar: totalpar,
                                           basketnummer: basketnummer + 1,
                                           baskets: baskets,
                                           howmanyplayers: howmanyplayers,
                                           nickname: nickname
                                       })
                mainPage.globalindex = mainPage.globalindex + 1




            } else {
                //console.log("Seite "+ basketnummer+ " ROUND ONE second ENTER");
            }

            if (basketnummer === baskets) {
                //check if last basketsite reached
                pageStack.pushAttached(Qt.resolvedUrl("Round_Results.qml"), {
                                           coursename: coursename,
                                           courseid:courseid,
                                           totalpar: totalpar,
                                           basketnummer: basketnummer + 1,
                                           baskets: baskets,
                                           howmanyplayers: howmanyplayers,
                                           nickname: nickname
                                       })
            }
        }
        if (status === PageStatus.Activating) {
            for (var q = 0; q < howmanyplayers; q++) {
                player.setProperty(q, "playerstotalpar",
                                   mainPage.totalplayerpar[q])
            }
        }
        if (status === PageStatus.Deactivating) {
            for (q = 0; q < howmanyplayers; q++) {
                //console.log("page Activating "+ mainPage.totalplayerpar[q] )
                player.setProperty(q, "playerstotalpar",
                                   mainPage.totalplayerpar[q])
            }
        }

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
        //activate roundCover

        mainWindow.cover = roundCover
    }

    SoundEffect {
           id: soundUp
           source: "/usr/share/sounds/jolla-ambient/stereo/keyboard_letter.wav"
           muted: false

       }

    SoundEffect {
          id: soundDown
          source: "/usr/share/sounds/jolla-ambient/stereo/keyboard_option.wav"
          muted: false;
  }

    Component {
        id: roundCover
        CoverBackground {
            Rectangle {
                id: rootcover
                width: parent.width
                height: parent.height
                opacity: settings.setting("transparency");
                color: "#394264"
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
                    text: qsTr("Basket %1 / %2").arg(basketnummer).arg(baskets)
                }
            }
            Item {
                id: parrect
                width: par.width+Theme.paddingLarge+Theme.paddingLarge
                anchors.top:scocadigorect.bottom
                height: par.height+Theme.paddingSmall

            Rectangle {
                anchors.fill: parent
                opacity: settings.setting("transparency");
                color:"#11a8ab"
     }
                Text {
                    id: par
                    anchors { left: parrect.left;leftMargin: Theme.paddingMedium; top:parrect.top;topMargin: Theme.paddingSmall;}
                    font.family: bebasNeue.name
                    color: "white"
                    font.pixelSize: Theme.fontSizeMedium
                    font.bold: true
                    opacity: 1
                    text: qsTr("Par: %1").arg(basketpar)
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
                    }
                }
            }
        }
    }

    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
        opacity: settings.setting("transparency");
    }
    SilicaFlickable {
        anchors.fill: round
        PullDownMenu {
            MenuItem {
                text: qsTr("CANCEL ROUND")
                onClicked: {
                    mainPage.globalindex = 0
                    reset();
                }
            }
        }

        //INFO (coursename HOLE NR par and whole average SCORE of hole)
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
                    opacity: settings.setting("transparency");
                    color: "#50597b"
                }
                Image {
                    id:newgameicon
                    x: Theme.paddingLarge*2
                    anchors.verticalCenter: topnewgame.verticalCenter
                    width: pageheader.height-paddinglarge12; height:pageheader.height-paddinglarge12
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
                    id: pageheaderpar
                    color: "white"
                    font.pixelSize: Theme.fontSizeSmall
                    opacity: 1
                    text: " (" + totalpar + ")"
                }
            }
            Item
            {
                id: infolabelpars
                width: label.width+ Theme.paddingLarge*2
                height: label.height

                Rectangle {
                    anchors.fill: parent
                    color: "#50597b"
                    opacity: settings.setting("transparency");
                }
                Label {
                    id: label
                    x: Theme.paddingLarge
                    font.family: bebasNeue.name
                    anchors{top: infolabelpars.top;topMargin: Theme.paddingSmall}
                    color: "white"
                    opacity: 1

                    font.pixelSize: Theme.fontSizeLarge
                    text: "|" + qsTr("Basket <b>%1</b> / %2").arg(basketnummer).arg(baskets)
                          + "|" + qsTr("Par: %1").arg(basketpar) + "|" + qsTr("Av.: %1").arg(DB.getAverageBasket(coursename,basketnummer))+"|"
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
            anchors.fill: parent
            anchors{topMargin: column.height+ Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            spacing: 2
            model: player
            delegate: ListItem {
                id: delegate
                contentHeight: nameLabel.height +worstLabel.height+avgLabel.height+bestLabel.height+Theme.paddingLarge
                width: names.width
                height: names.height

                Item{
                    id: names
                    width: screen.width - 50
                    height: parent.height


                    Rectangle {
                        anchors.fill: parent
                        opacity: settings.setting("transparency");
                        color: "#50597b"
                    }
                    Text {
                        id: up
                        font.family: fontawesome.name
                        color: "white"
                        anchors{right: names.right;verticalCenter: names.verticalCenter}
                        font.pixelSize: Theme.fontSizeExtraLarge + 30
                        opacity: 1
                        text: "\uf0fe "
                        MouseArea {
                            anchors.fill: up
                            onClicked: {
                                  if(tabsound==="1")
                                  {
                                soundUp.play()
                                  }
                                holepar.text = holepar.text - (-1)
                                mainPage.totalplayerpar[index] = mainPage.totalplayerpar[index] + 1
                                player.setProperty(index, "playerstotalpar",
                                                   mainPage.totalplayerpar[index])
                                mainPage.playersbasketpar[basketnummerarray][index]
                                        = (mainPage.playersbasketpar[basketnummerarray][index]) + 1
                                animateTextup.start();

                            }
                        }
                        NumberAnimation {
                            id: animateTextup
                            target: holepar
                            properties: " font.pixelSize"
                            from: Theme.fontSizeLarge+Theme.fontSizeMedium+ 40
                            to: Theme.fontSizeExtraLarge + 40
                            duration: 50
                        }


                    }

                    Text {
                        id: down
                        font.family: fontawesome.name
                        color: "white"
                        anchors{right: up.left;verticalCenter: names.verticalCenter}
                        font.pixelSize: Theme.fontSizeExtraLarge + 30
                        opacity: 1
                        text: "\uf146 "
                        MouseArea {
                            anchors.fill: down
                            onClicked: {
                                if(tabsound==="1")
                                {

                              soundDown.play()
                                }
                                holepar.text = holepar.text - 1
                                mainPage.totalplayerpar[index] = mainPage.totalplayerpar[index] - 1
                                player.setProperty(index, "playerstotalpar",
                                                   mainPage.totalplayerpar[index])
                                mainPage.playersbasketpar[basketnummerarray][index]
                                        = mainPage.playersbasketpar[basketnummerarray][index] - 1
                                animateTextdown.start();

                            }
                        }

                        NumberAnimation {
                            id: animateTextdown
                            target: holepar
                            properties: " font.pixelSize"
                            from: Theme.fontSizeMedium
                            to: Theme.fontSizeExtraLarge + 40
                            duration: 50
                        }
                    }
                    Text {
                        id: holepar
                        font.family: bebasNeue.name
                        opacity: 1
                        color: "white"
                        anchors{horizontalCenter:names.horizontalCenter;verticalCenter:names.verticalCenter;verticalCenterOffset: Theme.paddingSmall}
                        font.pixelSize: Theme.fontSizeExtraLarge + 40
                        font.bold: true
                        text: player.get(index).playersbasketpar
                    }
                    //NICKNAME
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
                        id: currentplayerspar
                        anchors{top: names.top;topMargin: Theme.paddingMedium;left: nameLabel.right;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeExtraLarge
                        font.bold: true
                        opacity: 1
                        text: player.get(index).playerstotalpar
                    }
                    //Players best on hole
                    Label {
                        id: bestLabel
                        anchors{top: nameLabel.bottom;left: names.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Best: %1").arg(DB.getBestScoreBasket(index,coursename, basketnummer))
                    }
                    //Avaerage of whole of player
                    Label {
                        id: avgLabel
                        anchors{top: bestLabel.bottom;left: names.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Average: %1").arg(DB.getAverageBasketPlayer(nickname,coursename, basketnummer))
                    }
                    //Players worst on hole
                    Label {
                        id: worstLabel
                        anchors{top: avgLabel.bottom;left: names.left;leftMargin: Theme.paddingMedium}
                        font.family: bebasNeue.name
                        font.pixelSize: Theme.fontSizeSmall
                        opacity: 1
                        text: qsTr("Worst: %1").arg(DB.getWorstScoreBasket(index,coursename, basketnummer))
                    }
                }
            }
        }
    }
}

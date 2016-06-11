import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    allowedOrientations:Orientation.LandscapeMask

    id: round

    property string coursename
    property int totalpar
    property int sizeoffont: 19
    property int sizeofrect: 14
    property string elapsedTime
    property var elapsed2
    property var resID
    property ListModel players
    property ListModel result
    property ListModel playerstotalpar
    property ListModel totalparresult
    property var baskets
    property int courseid
    property var howmanyplayers
    property int n
    property int q
    property var npar:1
    property var nickNAME: []
    property var spielerID:[]
    property var basketParArray: []
    property var playersTotalPar: []
    property var totalparplayer: []
    property var totalparplayerend: []
    property var contetnwidht

    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }
    FontLoader {
        id: fontawesome
        source: "fontawesome-webfont.ttf"
    }


    function date()
    {

        //GET DATE to be saved in the database
        var today = new Date()
        var dd = today.getDate()
        var mm = today.getMonth() + 1 //January is 0!
        var yyyy = today.getFullYear()
        if (dd < 10) {
            dd = '0' + dd
        }
        if (mm < 10) {
            mm = '0' + mm
        }

        var hours = today.getHours();
        var minutes = today.getMinutes();
        var ampm = hours >= 12 ? 'pm' : 'am';
        hours = hours % 12;
        hours = hours ? hours : 12; // the hour '0' should be '12'
        minutes = minutes < 10 ? '0'+minutes : minutes;
        var strTime = hours + ':' + minutes + ' ' + ampm;
        today = yyyy + '-' + mm + '-' + dd +'  ' +strTime;

        return today;
    }
    function reset() {
        pageStack.clear()
        pageStack.replace(Qt.resolvedUrl("FirstPage.qml"))
    }
    //insert base result in Round_Results.qml
    //rethink update plyed and time played
    function save() {
        pageStack.clear()
        pageStack.replace(Qt.resolvedUrl("FirstPage.qml"))

        //GET DATE to be saved in the database
        var today = new Date()
        var dd = today.getDate()
        var mm = today.getMonth() + 1 //January is 0!
        var yyyy = today.getFullYear()
        if (dd < 10) {
            dd = '0' + dd
        }
        if (mm < 10) {
            mm = '0' + mm
        }

        today = yyyy + '-' + mm + '-' + dd;

        //insertBaseResult
        DB.insertBaseResult(today, courseid, elapsed2)
        var resultid=DB.getRES_ID();
        for (n = 0; n < baskets; n++) {

            basketParArray[n] = DB.getPar((n+1), courseid)
            for (q = 0; q < howmanyplayers; q++) {
                //instertDetailResult
                DB.insertDetailResult(resultid,spielerID[q],courseid,n+1,mainPage.playersbasketpar[n][q])
            }
        }
        for (q = 0; q < howmanyplayers; q++) {
            DB.endResult(resultid,spielerID[q], courseid,(mainPage.totalplayerpar[q]))
        }
        DB.updatePLAYED(coursename)           //plus one played
        DB.updatePLAYEDROUNDSplayer(elapsed2) //save time played

    }

    Component.onCompleted: {
        nickNAME = DB.getNickNameAddedSelected()
        for (q = 0; q < howmanyplayers; q++) {
            totalparplayer[q] = 0
            totalparplayerend[q] = 0
            spielerID[q]=DB.getspielerIDfromName(nickNAME[q]);
        }

        if(baskets>27)
        {
            contetnwidht=screen.heigth*2
        }
        else contetnwidht=screen.heigth*1.5
        // console.log("today + courseID + played time ")
        //write basic results into table resutlBasic (RES_ID; DATE; TIME_PLAYED)
        for (n = 0; n < baskets; n++) {
            basketParArray[n] = DB.getPar((npar), courseid)
            for (q = 0; q < howmanyplayers; q++)
            {
                playersTotalPar[q] = (mainPage.playersbasketpar[n][q] - basketParArray[n])
                totalparplayer[q] = mainPage.playersbasketpar[n][q] + totalparplayer[q]
                result.append({
                                  result: mainPage.playersbasketpar[n][q] - basketParArray[n]
                              })
            }
            npar=npar+1;
        }

        for (var q = 0; q < howmanyplayers; q++) {
            totalparplayerend[q] = totalparplayer[q] - totalpar
            playerstotalpar.append({
                                       playerstotalpar: totalparplayerend[q]
                                   })
            players.append({
                               players: nickNAME[q]
                           })
        }


    }

    ListModel {
        id: result
    }

    ListModel {
        id: players
    }

    ListModel {
        id: playerstotalpar
    }

    Rectangle {
        id: root //it's a good idea to name it always root so I'm able to remember it everytime ;)
        width: parent.width
        height: parent.height
        color: "#394264"
    }


    SilicaFlickable {
        id: pullflick
        anchors.fill: root


        PullDownMenu {
            MenuItem {
                text: qsTr("CANCEL Round")
                onClicked: {
                    reset()
                }
            }
            MenuItem {
                text: qsTr("SAVE Round")
                onClicked: {
                    save();
                }
            }
        }



        Rectangle {
            id: topnewgame
            width: root.width
            height: newgameicon.height+1.5*Theme.paddingLarge
            color: "#50597b"

            Image {
                id: newgameicon
                x: Theme.paddingLarge*2
                anchors.verticalCenter:topnewgame.verticalCenter
                width: pageheader.height-Theme.paddingSmall; height:pageheader.height-Theme.paddingSmall
                fillMode: Image.PreserveAspectFit
                source: "newgameIcon.png"
            }
            Label {
                id: pageheader
                anchors{top:topnewgame.top;topMargin: Theme.paddingLarge;bottomMargin:Theme.paddingLarge;left:newgameicon.right;leftMargin: Theme.paddingMedium}
                font.family: bebasNeue.name
                color: "white"
                font.bold: true
                font.pixelSize:screen.width/8
                text: "scorecard " + coursename

            }
            Label {
                id: pageheaderpar
                font.family: bebasNeue.name
                anchors{baseline: pageheader.baseline;left: pageheader.right;leftMargin:Theme.paddingSmall}
                color: "white"
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                text: " (" + totalpar + ")"

            }

            Label {
                id: timelabel
                font.family: bebasNeue.name
                anchors{baseline: pageheader.baseline;right: topnewgame.right; rightMargin: Theme.paddingLarge; }
                color: "white"
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                text:date() + " "

            }
        }


        Rectangle{
            id:resultbackground

            width:playerrectback.width+totalrectback.width+flickable.width+Theme.paddingLarge
            height:playerrectback.height+playercolumn.height+Theme.paddingLarge+Theme.paddingLarge
            anchors{ top:topnewgame.bottom; topMargin: Theme.paddingSmall; leftMargin:Theme.paddingLarge}
            color:"#50597b"
        }


        Rectangle{
            id:playerrectback
            anchors{ top:topnewgame.bottom; topMargin: Theme.paddingLarge; leftMargin:Theme.paddingLarge}
            width: playerlabel.width+Theme.paddingLarge
            height: playerlabel.height+Theme.paddingLarge
            color: "#3a8499"

        }
        Label {
            id: playerlabel
            font.family: bebasNeue.name
            anchors{horizontalCenter: playerrectback.horizontalCenter; verticalCenterOffset:4;verticalCenter: playerrectback.verticalCenter}
            color: "white"
            font.pixelSize: Theme.fontSizeExtraSmall
            font.bold: true
            text:"player "

        }

        Rectangle{
            id:totalrectback
            anchors{ left:playerrectback.right; baseline:playerrectback.baseline;leftMargin:Theme.paddingSmall}
            width: playerlabel.width+Theme.paddingLarge
            height: totallabel.height+Theme.paddingLarge
            color: "#3a8499"

        }
        Label {
            id: totallabel
            font.family: bebasNeue.name
            anchors{horizontalCenter: totalrectback.horizontalCenter; verticalCenterOffset:4;verticalCenter: totalrectback.verticalCenter}
            color: "white"
            font.pixelSize: Theme.fontSizeExtraSmall
            font.bold: true
            text:"total "

        }
        Column{
            id:playercolumn
            anchors{ top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playersrepeater
                model: players
                Rectangle {
                    id: playernamerect
                    width: playerlabel.width+Theme.paddingLarge
                    height: playerlabel.height+Theme.paddingLarge
                    color: "#3a8499"
                    Label {
                        id: pars
                        anchors{centerIn: parent; verticalCenterOffset:4}
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: modelData
                    }
                }
            }
        }

        Column{
            id:playertotalparcolumn
            anchors{ left:playercolumn.right; leftMargin: Theme.paddingSmall; top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playertotalparrepeater
                model: playerstotalpar
                Rectangle {
                    id: playertotalparrect
                    width: ((playerlabel.width+Theme.paddingLarge)/2)-1.5
                    height: playerlabel.height+Theme.paddingLarge
                    color: "#394264"
                    Label {
                        id: totalpars
                        anchors{centerIn: parent; verticalCenterOffset:4}
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: totalpar+modelData
                    }
                }
            }
        }

        Column{
            id:playertotalparcolumn2
            anchors{ left:playertotalparcolumn.right; leftMargin: 3; top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playertotalparrepeater2
                model: playerstotalpar
                Rectangle {
                    id: playertotalparrect2
                    width: ((playerlabel.width+Theme.paddingLarge)/2)-1.5
                    height: playerlabel.height+Theme.paddingLarge
                    color: "#394264"
                    Label {
                        id: totalpars2
                        anchors{centerIn: parent; verticalCenterOffset:4}
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        text: modelData
                    }
                }
            }
        }

      //SilicaFlickable {
          Flickable  {
            id: flickable
            anchors{left:totalrectback.right; baseline:totalrectback.baseline;leftMargin:Theme.paddingMedium}
            height: root.height
            width: basketrow.width


            contentWidth: contetnwidht
            contentHeight:   basketrow.height
            flickableDirection: Flickable.HorizontalFlick

            HorizontalScrollDecorator {
                flickable: flickable
            }
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds


            Row{
                id:basketrow
                //anchors{left:totalrectback.right; baseline:totalrectback.baseline;leftMargin:Theme.paddingSmall}
                spacing:4
                Repeater {
                    id: basketsrepeater
                    model: baskets
                    Rectangle {
                        id: basketsrect
                        width: blindlabel.height+Theme.paddingLarge
                        height: blindlabel.height+Theme.paddingLarge
                        color: "#3a8499"
                        Label {
                            id: basketslabel
                            anchors{centerIn: parent; verticalCenterOffset:4}
                            font.family: bebasNeue.name
                            font.bold: true
                            color: "white"
                            font.pixelSize: Theme.fontSizeExtraSmall
                            text: index + 1
                        }
                        Label {
                            id: blindlabel
                            anchors{centerIn: parent; verticalCenterOffset:4}
                            font.family: bebasNeue.name
                            font.bold: true
                            color: "#3a8499"
                            font.pixelSize: Theme.fontSizeExtraSmall
                            text: "    "
                        }
                    }
                }
            }

            Grid{
                id:endresult
                anchors{top:basketrow.bottom;topMargin:Theme.paddingMedium}
                columns: baskets
                spacing:4
                flow :Grid.TopToBottom
                Repeater {
                    model:result
                    Rectangle{
                        width: blindlabel2.height+Theme.paddingLarge
                        height: blindlabel2.height+Theme.paddingLarge
                        color:"#394264"


                        Rectangle {
                            id: resultrect
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: blindlabel2.height+Theme.paddingMedium
                            height: blindlabel2.height+Theme.paddingMedium
                            radius:{
                                if (modelData <= -1) {
                                    resultrect.radius = 100

                                }
                                else
                                    resultrect.radius = 0
                            }

                            color: {
                                if (modelData <= -1) {
                                    resultrect.color = "#517b50"
                                } else if (modelData === 1) {
                                    resultrect.color = "#7b5052"
                                } else if (modelData === 2) {
                                    resultrect.color = "#993f49"
                                } else if (modelData >= 3) {
                                    resultrect.color = "#981826"
                                }
                                else {
                                    resultrect.color = "#394264"
                                }
                            }

                            Label {
                                id: resultlabel
                                anchors{centerIn: parent; verticalCenterOffset:4}
                                font.family: bebasNeue.name
                                font.bold: true
                                color: "white"
                                font.pixelSize: Theme.fontSizeExtraSmall
                                text: modelData
                            }
                            Label {
                                id: blindlabel2
                                anchors{centerIn: parent; verticalCenterOffset:4}
                                font.family: bebasNeue.name
                                font.bold: true
                                color: "#394264"
                                font.pixelSize: Theme.fontSizeExtraSmall
                                text: "    "
                            }
                        }
                    }
                }
            }
       }
    }
}

import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {

    allowedOrientations:Orientation.LandscapeMask

    id: round

    property string coursename
    property int courseid
    property int coursepar
    property string datum
    property string timeplayed
    property var baskets
    property int res_id

    property ListModel players
    property ListModel result
    property ListModel playerstotalpar


    property int fontsize: Theme.fontSizeExtraSmall;
    property int marginrect:Theme.paddingMedium;
    property int margincircle:Theme.paddingSmall;

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
        baskets= DB.getamountBaskets(coursename)
        DB.getPlayersbyRESID(res_id)
        //filll resMODEL
        DB.getSpielerIDbyResId(res_id,coursename)
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
        opacity: settings.setting("transparency");
        color: "#394264"
    }
    SilicaFlickable {
        id: pullflick
        anchors.fill: root

        Item{
            id: topnewgame
            width: root.width
            height: newgameicon.height+1.5*Theme.paddingLarge

            Rectangle {
                anchors.fill: parent
                opacity: settings.setting("transparency");
                color: "#50597b"
            }
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
                width: root.width-(root.width/2.5)

                anchors{top:topnewgame.top;topMargin: Theme.paddingLarge;bottomMargin:Theme.paddingLarge;left:newgameicon.right;leftMargin: Theme.paddingMedium}
                font.family: bebasNeue.name
                color: "white"
                font.bold: true
                font.pixelSize:screen.width/9
                opacity: 1
                truncationMode: TruncationMode.Fade

                text: qsTr("scorecard ") + coursename

            }
            Label {
                id: pageheaderpar
                font.family: bebasNeue.name
                anchors{baseline: pageheader.baseline;left: pageheader.right;leftMargin:Theme.paddingSmall}
                color: "white"
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                opacity: 1
                text: " (" + coursepar + ")"
            }

            Label {
                id: timelabel
                font.family: bebasNeue.name
                anchors{baseline: pageheader.baseline;right: topnewgame.right; rightMargin: Theme.paddingLarge; }
                color: "white"
                font.pixelSize: Theme.fontSizeSmall
                opacity: 1
                font.bold: true
                text:datum + " " + timeplayed
            }
        }

        Rectangle{
            id:resultbackground
            width:playerrectback.width+totalrectback.width+flickable.width+Theme.paddingLarge
            height:playerrectback.height+playercolumn.height+Theme.paddingLarge+Theme.paddingLarge
            anchors{ top:topnewgame.bottom; topMargin: Theme.paddingSmall; leftMargin:Theme.paddingLarge}
            color:"#50597b"
            opacity: settings.setting("transparency");
        }

        Rectangle{
            id:playerrectback
            anchors{ top:topnewgame.bottom; topMargin: Theme.paddingLarge; leftMargin:Theme.paddingLarge}
            width: playerlabel.width+marginrect+Theme.paddingMedium
            height: playerlabel.height+marginrect
            color: "#3a8499"
            opacity: settings.setting("transparency");

        }

        Label {
            id: playerlabel
            font.family: bebasNeue.name
            anchors{horizontalCenter: playerrectback.horizontalCenter; verticalCenterOffset:4;verticalCenter: playerrectback.verticalCenter}
            color: "white"
            font.pixelSize: fontsize
            font.bold: true
            opacity: 1
            text:qsTr("player ")
        }

        Rectangle{
            id:totalrectback
            anchors{ left:playerrectback.right; baseline:playerrectback.baseline;leftMargin:Theme.paddingSmall}
            width: playerlabel.width+marginrect
            height: totallabel.height+marginrect
            opacity: settings.setting("transparency");
            color: "#3a8499"

        }
        Label {
            id: totallabel
            font.family: bebasNeue.name
            anchors{horizontalCenter: totalrectback.horizontalCenter; verticalCenterOffset:4;verticalCenter: totalrectback.verticalCenter}
            color: "white"
            font.pixelSize: fontsize
            font.bold: true
            opacity: 1
            text:qsTr("total ")
        }



        /*players MODEL: players.append({
                                        players:nickNAme[q]
                                      })

        */
        Column{
            id:playercolumn
            anchors{ top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playersrepeater
                model: players

                Item{
                    id: playernamerect
                    width: playerlabel.width+marginrect+Theme.paddingMedium
                    height: playerlabel.height+marginrect


                    Rectangle {
                        id:playersnamerectangle
                        anchors.fill: parent
                        opacity: settings.setting("transparency");
                        color: "#3a8499"
                    }
                    Label {
                        id: pars

                        anchors.centerIn:parent
                        anchors.verticalCenterOffset: 4
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        opacity: 1
                        font.pixelSize: fontsize
                        truncationMode: TruncationMode.Fade
                        text: modelData//.substring(0, 6)
                    }
                }
            }
        }
        /*playerstotalpar.append({
                                   playerstotalpar: totalparplayerend[q]
                               })
        */
        Column{
            id:playertotalparcolumn
            anchors{ left:playercolumn.right; leftMargin: Theme.paddingSmall; top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playertotalparrepeater
                model: playerstotalpar

                Item{

                    id: playertotalparrect
                    width: ((playerlabel.width+marginrect)/2)-1.5
                    height: playerlabel.height+marginrect

                    Rectangle {
                        anchors.fill: parent
                        opacity: settings.setting("transparency");
                        color: "#394264"
                    }
                    Label {
                        id: totalpars
                        anchors{centerIn: parent; verticalCenterOffset:4}
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        opacity: 1
                        font.pixelSize: fontsize
                        text: coursepar+modelData
                    }
                }
            }
        }

        //same as above but only modelData (playerspar)
        Column{
            id:playertotalparcolumn2
            anchors{ left:playertotalparcolumn.right; leftMargin: 3; top: totalrectback.bottom;topMargin:Theme.paddingMedium}
            spacing:4
            Repeater {
                id: playertotalparrepeater2
                model: playerstotalpar
                Item{
                    id: playertotalparrect2
                    width: ((playerlabel.width+marginrect)/2)-1.5
                    height: playerlabel.height+marginrect


                    Rectangle {
                        anchors.fill: parent
                        opacity: settings.setting("transparency");
                        color: "#394264"
                    }
                    Label {
                        id: totalpars2
                        anchors{centerIn: parent; verticalCenterOffset:4}
                        font.family: bebasNeue.name
                        font.bold: true
                        color: "white"
                        opacity: 1
                        font.pixelSize: fontsize
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
            width: root.width
            //contentWidth: contetnwidht
            contentWidth: basketrow.width*1.2;
            contentHeight:resultbackground.height
            flickableDirection: Flickable.HorizontalFlick

            HorizontalScrollDecorator {
                flickable: flickable
            }
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds

            //ROW MODEL IS BASKETS (how many baskets!!!

            Row{
                id:basketrow
                //anchors{left:totalrectback.right; baseline:totalrectback.baseline;leftMargin:Theme.paddingSmall}
                spacing:4
                Repeater {
                    id: basketsrepeater
                    model: baskets

                    Item{
                        id: basketsrect
                        width: blindlabel.height+marginrect
                        height: blindlabel.height+marginrect


                        Rectangle {
                            anchors.fill: parent
                            opacity: settings.setting("transparency");
                            color: "#3a8499"

                        }
                        Label {
                            id: basketslabel
                            anchors{centerIn: parent; verticalCenterOffset:4}
                            font.family: bebasNeue.name
                            font.bold: true
                            color: "white"
                            opacity: 1
                            font.pixelSize: fontsize
                            text: index + 1
                        }
                        Label {
                            id: blindlabel
                            anchors{centerIn: parent; verticalCenterOffset:4}
                            font.family: bebasNeue.name
                            font.bold: true
                            color: "#3a8499"
                            opacity: 1
                            font.pixelSize: fontsize
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

                //model: (basket1 player1) playedpar (basket2 player2) playedpar ....
                flow :Grid.LeftToRight

                Repeater {
                    model:result

                    Item{
                        width: blindlabel2.height+marginrect
                        height: blindlabel2.height+marginrect
                        Rectangle{
                            anchors.fill: parent
                            color:"#394264"
                            opacity: settings.setting("transparency");
                        }

                        Item{
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.verticalCenter: parent.verticalCenter
                            width: blindlabel2.height+margincircle
                            height: blindlabel2.height+margincircle



                            Rectangle {
                                id: resultrect
                                anchors.fill: parent
                                opacity: (settings.setting("transparency"));
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
                            }
                            Label {
                                id: resultlabel
                                anchors{centerIn: parent; verticalCenterOffset:4}
                                font.family: bebasNeue.name
                                font.bold: true
                                color: "white"
                                opacity:1
                                font.pixelSize: fontsize
                                text: modelData
                            }
                            Label {
                                id: blindlabel2
                                anchors{centerIn: parent; verticalCenterOffset:4}
                                font.family: bebasNeue.name
                                font.bold: true
                                color: "#394264"
                                font.pixelSize: fontsize
                                opacity: 1
                                text: "    "
                            }
                        }
                    }
                }
            }
        }
    }
}



import QtQuick 2.0
import Sailfish.Silica 1.0
import "Database.js" as DB

Dialog {

    id: defineParoverall
    property bool backStepping: true
    property Item newCoursespage
    property int basketnrr:1
    property var baskets
    property var coursename
    property int totalpar
    property var howmanypar:[]; //my array with undefined lenght...
    property int paddinglarge12:Theme.paddingLarge*1.2

    property var transparency

    acceptDestination: Qt.resolvedUrl("FirstPage.qml")
    acceptDestinationAction:PageStackAction.Replace

    visible: false

    FontLoader { id: bebasNeue; source: "bebasNeue Regular.otf" }
    FontLoader { id: fontawesome; source: "fontawesome-webfont.ttf" }

    //set all par to 3 function
    function setparonbegin(setpar){
        var i,x, n = newCoursespage.baskets

        for (i = 0; i < n; i++) {
            howmanypar[i] = 3;
            x=i+1;
            totalpar=newCoursespage.baskets*3;
        }
        n=setpar;
        return setpar;
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

        Column {
            id:header_column
            width: root.width
            spacing: 3
            Item{
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
                    width: screen.width-(newgameicon.width*2.5)
                    anchors{top:topcourses.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                    font.family: bebasNeue.name
                    color: "white"
                    opacity: 1
                    font.pixelSize: Theme.fontSizeExtraLarge+Theme.fontSizeMedium
                    truncationMode: TruncationMode.Fade
                    text: newCoursespage.coursename
                }
            }

            Item{
                width: screen.width-100
                height: label.height+Theme.paddingSmall
                Rectangle {
                    anchors.fill: parent
                    opacity: settings.setting("transparency");
                    color:"#50597b"
                }
                Label {
                    id:label
                    x: Theme.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: Theme.paddingSmall
                    font.family: bebasNeue.name
                    font.bold:true
                    opacity: 1
                    text: qsTr("Total Par: " + totalpar )
                    color: "white"
                    font.pixelSize: Theme.fontSizeLarge
                }
            }
        }

        ListModel {
            id: definepar

        }
        SilicaListView {
            id:listView
            anchors{fill: parent; topMargin: header_column.height +Theme.paddingLarge;leftMargin: Theme.paddingMedium}
            clip: true
            VerticalScrollDecorator { flickable: listView }
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem
            model:setparonbegin(newCoursespage.baskets)
            spacing: Theme.paddingSmall

            delegate: ListView {
                spacing: Theme.paddingSmall
                height:definebaskettextrect.height
                visible: true

                Item{
                    id:definebaskettextrect
                    width:screen.width-30//baskettext.width+40
                    height: baskettext.height+Theme.paddingLarge+Theme.paddingLarge
                    Rectangle{
                        anchors.fill: parent
                        color: "#d15a67"
                        opacity: settings.setting("transparency");
                        //opacity: index % 2 == 0 ? 0.8 : 1
                    }
                    Label{
                        id:baskettext
                        anchors.verticalCenter: definebaskettextrect.verticalCenter
                        font.family: bebasNeue.name
                        anchors.left:definebaskettextrect.left
                        anchors.leftMargin:Theme.paddingLarge
                        font.pixelSize: Theme.fontSizeExtraLarge
                        anchors.verticalCenterOffset: Theme.paddingSmall
                        font.bold: true
                        opacity: 1
                        text:qsTr("Hole: ") + (index +1) //+"/"+newCoursespage.baskets
                    }

                    Text {
                        id:down
                        font.family: fontawesome.name
                        color:"white"
                        anchors.right: up.left
                        anchors.rightMargin: Theme.paddingSmall
                        anchors.verticalCenter: definebaskettextrect.verticalCenter
                        font.pixelSize: Theme.fontSizeLarge+35
                        opacity:1
                        text: "\uf146 "
                        MouseArea {
                            anchors.fill: down
                            onClicked:

                            {
                                animateOpacitydown.start();
                                animateTextdown.start();
                                howmanypar[index]=  howmanypar[index]-1;
                                if(howmanypar[index]<=1)
                                {
                                    howmanypar[index]=2;
                                    textpar.text=howmanypar[index]
                                    totalpar=totalpar
                                }
                                else{ textpar.text=howmanypar[index]
                                    totalpar=totalpar-1
                                }
                            }
                        }

                        NumberAnimation {
                            id: animateOpacitydown
                            target: down
                            properties: "opacity"
                            from: 0.1
                            to: 1
                            duration: 40
                        }

                        NumberAnimation {
                            id: animateTextdown
                            target: textpar
                            properties: " font.pixelSize"
                            from: Theme.fontSizeMedium
                            to:  Theme.fontSizeLarge+50
                            duration: 80
                        }
                    }

                    Text {
                        id:up
                        font.family: fontawesome.name
                        color:"white"
                        opacity: 1
                        anchors.right:definebaskettextrect.right
                        anchors.verticalCenter: definebaskettextrect.verticalCenter
                        anchors.rightMargin: Theme.paddingLarge
                        font.pixelSize: Theme.fontSizeLarge+35
                        text: "\uf0fe "
                        MouseArea {
                            anchors.fill: up
                            onClicked:

                            {
                                animateOpacityup.start();
                                animateTextup.start();
                                howmanypar[index]=howmanypar[index]+1;
                                if(howmanypar[index]>=10)
                                {
                                    howmanypar[index]=9;
                                    textpar.text=  howmanypar[index]
                                    totalpar=totalpar;
                                }
                                else {
                                    textpar.text=howmanypar[index]
                                    totalpar=totalpar+1;
                                }
                            }
                        }

                        NumberAnimation {
                            id: animateOpacityup
                            target: up
                            properties:"opacity"
                            from: 0.1
                            to: 1
                            duration: 40
                        }

                        NumberAnimation {
                            id: animateTextup
                            target: textpar
                            properties: " font.pixelSize"
                            from: Theme.fontSizeLarge+100
                            to:  Theme.fontSizeLarge+50
                            duration: 80
                        }
                    }

                    Label{
                        id:textpar
                        font.family: bebasNeue.name
                        anchors.verticalCenter: definebaskettextrect.verticalCenter
                        anchors.horizontalCenter:definebaskettextrect.horizontalCenter
                        anchors.verticalCenterOffset: Theme.paddingSmall
                        font.bold:true
                        opacity: 1
                        text:howmanypar[index]
                        font.pixelSize:  Theme.fontSizeLarge+50
                    }
                }
            }
        }
    }



    onRejected: {
        //delet all from table courses where name =  newCoursespage.coursename
        DB.deleteCourse(newCoursespage.coursename)
    }
    onDone: {
        DB.insertCOURSE(newCoursespage.coursename,newCoursespage.baskets,totalpar, "noNote",0,0,0);

        var i,x, n = newCoursespage.baskets
        for (i = 0; i < n; i++) {
            x=i+1;
            DB.insertBASKETS(x,howmanypar[x-1],DB.getCourseID(newCoursespage.coursename))
        }
    }

}

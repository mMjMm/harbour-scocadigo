/****************************************************************************************
**
** Copyright (C) 2013 Jolla Ltd.
** Contact: Matt Vogt <matt.vogt@jollamobile.com>
** All rights reserved.
**
** This file is part of Sailfish Silica UI component package
**
** You may use this file under the terms of BSD license as follows:
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are met:
**     * Redistributions of source code must retain the above copyright
**       notice, this list of conditions and the following disclaimer.
**     * Redistributions in binary form must reproduce the above copyright
**       notice, this list of conditions and the following disclaimer in the
**       documentation and/or other materials provided with the distribution.
**     * Neither the name of the Jolla Ltd nor the
**       names of its contributors may be used to endorse or promote products
**       derived from this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
** ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
** WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
** DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
** ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
** (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
** ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
****************************************************************************************/

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
        color: "#394264"
    }

    SilicaFlickable {

        anchors.fill: parent
        contentHeight: columndefinepars.height+tester.height*6
        boundsBehavior: Flickable.DragAndOvershootBounds

        ListModel {
            id:listmodel
        }

        SilicaListView {

            id:listView
            VerticalScrollDecorator { flickable: listView }
            // HorizontalScrollDecorator { flickable: listView }
            anchors.fill: parent
            anchors.topMargin: header_column.height+Theme.paddingMedium
            //spacing:15
            clip: true
            boundsBehavior: Flickable.DragAndOvershootBounds
            snapMode: ListView.SnapToItem

            Label{
                id:tester
                visible: false
                font.family: bebasNeue.name
                font.pixelSize: Theme.fontSizeLarge
                text:"Hole: "
            }
            Column{
                id:columndefinepars
                spacing:Theme.paddingSmall
                Repeater{
                    id:repeater
                    model:  setparonbegin(newCoursespage.baskets)
                    Component{
                        id:mycomponent
                        Rectangle{
                            id:definebaskettextrect
                            width:screen.width-30//baskettext.width+40
                            height: baskettext.height
                            color: "#d15a67"
                            //opacity: index % 2 == 0 ? 0.8 : 1

                            Label{
                                id:baskettext
                                anchors.verticalCenter: definebaskettextrect.verticalCenter
                                font.family: bebasNeue.name
                                anchors.left:definebaskettextrect.left
                                anchors.leftMargin:Theme.paddingLarge
                                font.pixelSize: Theme.fontSizeExtraLarge
                                anchors.verticalCenterOffset: Theme.paddingSmall
                                font.bold: true
                                text:"Hole: " + (index +1) //+"/"+newCoursespage.baskets
                            }

                            Text {
                                id:down
                                font.family: fontawesome.name
                                color:"white"
                                anchors.right: up.left
                                anchors.rightMargin: Theme.paddingSmall
                                anchors.verticalCenter: definebaskettextrect.verticalCenter
                                font.pixelSize: Theme.fontSizeLarge+35

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
                                    properties: "opacity"
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
                                text:howmanypar[index]
                                font.pixelSize:  Theme.fontSizeLarge+50
                            }
                        }
                    }
                }
            }
        }
    }

    Column {

        id:header_column
        width: root.width
        spacing: 3


        Rectangle {
            id: topcourses
            width: root.width
            height: pageheader.height
            color: "#50597b"



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
                font.family: bebasNeue.name
                anchors{top:topcourses.top;topMargin:Theme.paddingMedium;left:newgameicon.right;leftMargin:Theme.paddingMedium}
                text: newCoursespage.coursename
                color: "white"
                font.pixelSize:screen.width/5
            }
        }

        Rectangle {
            width: screen.width-100
            height: label.height+Theme.paddingSmall
            color:"#50597b"

            Label {

                id:label
                x: Theme.paddingMedium
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: Theme.paddingSmall
                font.family: bebasNeue.name
                font.bold:true
                text: qsTr("Total Par: " + totalpar )
                color: "white"
                font.pixelSize: Theme.fontSizeLarge
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

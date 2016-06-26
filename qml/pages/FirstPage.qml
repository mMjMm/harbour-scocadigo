/*
MIT License

Copyright (c) [2015] [Michael Johannes Muik]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

*/
import QtQuick 2.1
import Sailfish.Silica 1.0
import "Database.js" as DB

Page {


    id: mainPage

    property int fontsizeHeader:screen.width/5
    property var transparency
    property var tabsound
    property var scorecardname


    backNavigation: false
    FontLoader {
        id: bebasNeue
        source: "bebasNeue Regular.otf"
    }

    Component.onCompleted: {

        transparency=settings.setting("transparency");

        if(typeof transparency=="undefined")
        {
            console.log("WELCOME TO °SCOCADIGO°")
            settings.setSetting("transparency",1)
            transparency=settings.setting("transparency");

        }

        tabsound=settings.setting("tabsound");

        if(typeof tabsound=="undefined")
        {
            settings.setSetting("tabsound", 1)
            tabsound=settings.setting("tabsound");

        }


        scorecardname=settings.setting("scorecardname");

        if(typeof scorecardname=="undefined")
        {
            settings.setSetting("scorecardname", 0)
            scorecardname=settings.setting("scorecardname");

        }


        transparency=settings.setting("transparency");
        root.opacity=transparency
        scocadigorectangle.opacity=transparency
        toplabelrec.opacity=transparency
      DB.initialize();

        /*DB.getBaseResult();
        DB.getDetailResult();
        console.log("spieler:");
        DB.showSpieler();
        console.log("COURSES:");
        DB.showCourses();
        console.log("BASKETS:");
        DB.showBaskets();
        console.log("RESULTBASICS");
        DB.showResultBasic();
        console.log("resultDetail:");
        DB.showResultDetail();
        console.log("ENDRESULT:");
        DB.showEndResult();
*/
    }

    onStatusChanged: {

        //activate cover for start a new game!
        mainWindow.cover =Qt.resolvedUrl("../cover/CoverPage.qml")
        transparency=settings.setting("transparency");
        root.opacity=transparency
        scocadigorectangle.opacity=transparency
        toplabelrec.opacity=transparency
    }
    Rectangle {
        id: root
        width: parent.width
        height: parent.height
        color: "#394264"
        opacity:settings.setting("transparency")
    }

    Column {
        id: column
        width: root.width
        spacing: 3
        Item{
            id: scocadigorect
            width: root.width
            height: pageheader.height
            Rectangle {
                id:scocadigorectangle
                anchors.fill: parent
                color: "#50597b"
                opacity: settings.setting("transparency")
            }
            Text {
                id: pageheader
                anchors { horizontalCenter: scocadigorect.horizontalCenter; top:scocadigorect.top;topMargin:Theme.paddingMedium}
                font.family: bebasNeue.name
                color: "white"
                font.pixelSize:fontsizeHeader
                font.bold: true
                opacity: 1
                text: "°scocadigo°"
            }
        }
        Item{
            id:toplabel
            width: label.width+ Theme.paddingLarge*2
            height: label.height
            anchors.topMargin: Theme.paddingSmall

            Rectangle {
                id:toplabelrec
                anchors.fill: parent
                color: "#50597b"
                opacity:settings.setting("transparency")
            }
            Label {
                id: label
                x: Theme.paddingLarge
                font.family: bebasNeue.name
                anchors {top:toplabel.top;topMargin:Theme.paddingSmall}
                color: "white"
                opacity:1
                font.pixelSize: Theme.fontSizeExtraLarge
                text: qsTr("score card disc golf")
            }
        }

    }

    Buttons {
        id: buttons
    }
}


/*
* Copyright 2014 Michael Johannes Muik
* This program is free software: you can redistribute it and/or modify it under
* the terms of the GNU General Public License version 3 as published by the
* Free Software Foundation. See http://www.gnu.org/copyleft/gpl.html the full
* text of the license.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
import QtQuick 2.1
import Sailfish.Silica 1.0
import "pages"

//import "Database.js" as DB

ApplicationWindow
{
    id: mainWindow
    initialPage: mainPage
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    property var transparency
    property var tabsound
    property var scorecardname


    Component.onCompleted: {

        //  DB.initialize();

        transparency=settings.setting("transparency");

        if(typeof transparency=="undefined")
        {
            console.log("WELCOME TO °SCOCADIGO°")
            settings.setSetting("transparency",1)
        }

        tabsound=settings.setting("tabsound");

        if(typeof tabsound=="undefined")
        {
            settings.setSetting("tabsound", 1)
        }

        scorecardname=settings.setting("scorecardname");

        if(typeof scorecardname=="undefined")
        {
            settings.setSetting("scorecardname", 0)
        }
    }
    FirstPage {
        id: mainPage

        property Item newCoursespage
        property int globalindex: 1
        property var playersbasketpar: [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
        property var totalplayerpar: []
        property int i: 0
        property var start

        property int minimum: -3
        property int maximum: 6




    }
}

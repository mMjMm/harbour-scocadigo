import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    FontLoader {
        id: bebasNeue
        source: "../pages/bebasNeue Regular.otf"
    }
    Rectangle {
        id: root
        width: parent.width
        height: parent.height
        color: "#394264"
    }
    Image {
        source: "background_cover.png"
        anchors.bottom: root.bottom;
        anchors.bottomMargin: -(Theme.paddingLarge+Theme.paddingMedium);
        anchors.right:  root.right;
        anchors.rightMargin:Theme.paddingMedium;
    }
    Rectangle {
        id: scocadigorect
        width: root.width
        height: pageheader.height+Theme.paddingMedium
        color:"#11a8ab"
 Text {
            id: pageheader
            anchors { horizontalCenter: scocadigorect.horizontalCenter; top:scocadigorect.top;topMargin:Theme.paddingMedium}
            font.family: bebasNeue.name
            color: "white"
            font.pixelSize: Theme.fontSizeExtraLarge+5
            font.bold: true
            text: "°scocadigo°"
        }
    }
    Label {
        id: label3
        x: Theme.paddingLarge
        font.family: bebasNeue.name
        anchors.horizontalCenter: root.horizontalCenter;
        anchors.top:scocadigorect.bottom;
        anchors.topMargin: Theme.paddingLarge+Theme.paddingSmall;
        color: "white"
        font.pixelSize: Theme.fontSizeMedium
        font.bold: true
        text: "start a new game"
    }
    CoverActionList {
        id: coverAction
        CoverAction {
            iconSource: "new_game_cover.png"
            onTriggered: {

                pageStack.push(Qt.resolvedUrl("../pages/NewGame.qml"), {
                               },PageStackAction.Immediate)
                pageStack.pushAttached(("../pages/NewGameCourses.qml"))
                mainWindow.activate()

            }
        }
    }
}



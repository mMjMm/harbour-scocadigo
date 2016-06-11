import QtQuick 2.1
import Sailfish.Silica 1.0

Item {
    id: control
    property var themePadding1_5:Theme.paddingLarge*1.5
    property var screenwidth2_8:screen.width/2.8
    property var screenwidth7:screen.width/7
    property var screenwidth10:screen.width/10
    width:screen.width
    height:screen.height
    Grid{
        columns: 2
        spacing: themePadding1_5
        anchors{horizontalCenter:parent.horizontalCenter;bottom:parent.bottom;bottomMargin: themePadding1_5}
        horizontalItemAlignment : Grid.AlignRight
        Image {
            width:screenwidth2_8
            height:screenwidth2_8
            fillMode: Image.PreserveAspectFit
            source: "newgamebutton.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(("NewGame.qml"), {
                                       dataContainer: root
                                   })
                    pageStack.pushAttached(("NewGameCourses.qml"))
                }
            }
        }
        Image {
            width: screenwidth2_8; height: screenwidth2_8
            fillMode: Image.PreserveAspectFit
            source: "newplayerbutton.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(("Players.qml"), {
                                   })
                }
            }
        }
        Image {
            width: screenwidth2_8; height: screenwidth2_8
            fillMode: Image.PreserveAspectFit
            source: "newcoursebutton.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(("Courses.qml"), {
                                       dataContainer: root
                                   })
                }
            }
        }
        Image {
            width: screenwidth2_8; height:screenwidth2_8
            fillMode: Image.PreserveAspectFit
            source: "statisticsbutton.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Statistics.qml"), {
                                       dataContainer: root
                                   })
                }
            }
        }
        Rectangle{
            visible:true
            width: screenwidth10
            height: screenwidth10
            opacity:0
        }
        Rectangle{
            visible:true
            width: screenwidth10
            height: screenwidth10
            opacity:0
        }
        Rectangle{
            visible:true
            width: screenwidth10
            height: screenwidth10
            opacity:0
        }
        Image {
            width:screenwidth7; height:screenwidth7
            fillMode: Image.PreserveAspectFit
            source: "settingsbutton.png"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Settings.qml"), {
                                       dataContainer: root
                                   })
                }
            }
        }
    }
}

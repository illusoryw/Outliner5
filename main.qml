import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    Textediter{
        id: editer
        anchors.fill:parent
        anchors.leftMargin: parent.width*(0.3)
    }
    MouseArea{
        anchors.fill:parent
        anchors.rightMargin: editer.width
        onClicked: {
            editer.focus=false
            parent.focus=true
            console.log("focus changed")
        }
    }
}

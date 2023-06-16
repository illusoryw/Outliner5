import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {    //单击左半空白部分上半部与下半部实现焦点切换
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
        anchors.bottomMargin: editer.height*0.5
        onClicked: {
            editer.focus=false
            parent.focus=true
            console.log("focus changed leave Textediter")
        }
    }
    MouseArea{
        anchors.fill:parent
        anchors.rightMargin: editer.width
        anchors.topMargin: editer.height*0.5
        onClicked: {
            editer.focus=true
            parent.focus=false
            console.log("focus changed to Textediter")
        }
    }
}

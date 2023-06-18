import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

FocusScope{
    id: editer
    focus: true
Rectangle{
        id: textshow
        anchors.fill:parent
        color:"linen"
        visible: true
        //focus:true
        property string markdown_sourse: ""
        property bool stmt: false
        TextEdit {
            id: srctext
            anchors.fill:parent
            text: parent.markdown_sourse
            font.pixelSize: 20
            focus: editer.focus
            visible: focus
            selectByMouse: true

            onTextChanged: {
                multitext.text=text
                parent.markdown_sourse=text
                //console.log("start comp")
            }
        }
        Text {
            id: multitext
            anchors.fill:parent
            text: "please input"
            font.pixelSize: 20
            textFormat: Text.MarkdownText
            visible: !editer.focus
        }
        MouseArea{
            anchors.fill:parent
            propagateComposedEvents:true
            onClicked: {
                //editer.forceActiveFocus();
                srctext.forceActiveFocus();
                mouse.accepted=false;
                //srctext.focus=true;
            }
//            onPressed: mouse.accepted = false;
//            onReleased: mouse.accepted = false;
//            onDoubleClicked: mouse.accepted = false;
//            onPositionChanged: mouse.accepted = false;
//            onPressAndHold: mouse.accepted = false;
        }

}
}

import QtQuick 2.12
import QtQuick.Window 2.12

FocusScope{
    id: editer
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
            visible: editer.focus
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
            onClicked: {
                //editer.forceActiveFocus();
                editer.forceActiveFocus();
                //srctext.focus=true;
            }
        }

}
}

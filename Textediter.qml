import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

FocusScope {
    id: editer
    property string markdown_sourse: srctext.text
    property alias defaultSource: srctext.text
    property bool atEnd: srctext.cursorPosition === srctext.text.length
    property bool atBegin: srctext.cursorPosition === 0
    property var nextItem: this
    implicitWidth: focus ? srctext.width : multitext.width
    implicitHeight: focus ? srctext.height : multitext.height
    Component.onCompleted: {
        srctext.text = markdown_sourse
        //        console.error('editor', height, implicitHeight, width, implicitWidth)
    }
    onFocusChanged: {
        console.error(this, 'focus changed to', focus)
    }

    TextEdit {
        id: srctext
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 20
        focus: editer.focus
        visible: focus
        selectByMouse: true
        onCursorPositionChanged: {
            if (cursorPosition == text.length)
                console.error('cursor at end', cursorPosition, text.length)
        }
        Keys.priority: Keys.BeforeItem
        Keys.onPressed: {
            if (event.key === Qt.Key_Tab) {
                event.accepted = true
            }
        }
    }
    Text {
        id: multitext
        anchors.left: parent.left
        anchors.right: parent.right
        text: markdown_sourse
        font.pixelSize: 20
        textFormat: Text.MarkdownText
        visible: !editer.focus
    }
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onClicked: {
            //editer.forceActiveFocus();
            srctext.forceActiveFocus()
            mouse.accepted = true
            //srctext.focus=true;
        }
        onPressed: {
            srctext.forceActiveFocus()
            mouse.accepted = false
        }
    }
}

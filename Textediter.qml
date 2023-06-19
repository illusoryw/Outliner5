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
    property int index
    implicitWidth: focus ? srctext.width : multitext.width
    implicitHeight: focus ? srctext.height : multitext.height
    onFocusChanged: {
        //        console.error(this, 'focus changed to', focus)
        if (focus)
            listview.currentIndex = index
        else
            saveToModel()
    }
    //    onIndexChanged:    console.error(this, 'index changed to', index)
    function moveCursor(pos) {
        srctext.cursorPosition = pos
    }

    TextEdit {
        id: srctext
        anchors.left: parent.left
        anchors.right: parent.right
        font.pixelSize: 20
        focus: editer.focus
        visible: focus
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        selectByMouse: true
        onCursorPositionChanged: {
            console.error('cursor pos changed', cursorPosition)
            if (cursorPosition == text.length)
                console.error('cursor at end', cursorPosition, text.length)
            else if (cursorPosition <= 1)
                console.error('cursor at ', cursorPosition)
        }
        Keys.priority: Keys.BeforeItem
        Keys.onBacktabPressed: {
            event.accepted = true
            console.error('key backtab,index=', index, level)
            if (level <= 0)
                return
            for (var i = index, end = docmodel.getChildEnd(
                     index); i <= end; i++) {
                let cur = docmodel.get(i).cur
                cur.level--
                docmodel.get(i).cur = cur
            }
        }
        Keys.onTabPressed: {
            event.accepted = true
            let prevlevel = (docmodel.get(index - 1) || docmodel.get(
                                 index)).cur.level
            console.error('key tab,index=', index, prevlevel, level)
            if (level - prevlevel <= 0) {
                for (var i = index, end = docmodel.getChildEnd(
                         index); i <= end; i++) {
                    let cur = docmodel.get(i).cur
                    cur.level++
                    docmodel.get(i).cur = cur
                }
            }
        }

        Keys.onPressed: {
            console.error('key', event.key, Qt.Key_Backspace, 'modifier',
                          event.modifiers, Qt.ShiftModifier)
            if (event.key === Qt.Key_Return
                    && event.modifiers === Qt.ControlModifier) {
                event.accepted = true
                let next = (docmodel.get(index + 1) || docmodel.get(
                                index)).cur.level
                docmodel.insert(index + 1, {
                                    "cur": {
                                        "level": next <= level ? level : level + 1,
                                        "raw": ''
                                    },
                                    "bulletFocus_": false
                                })
                listview.currentIndex++
                console.error('add node')
            } else if (event.key === Qt.Key_Backspace && atBegin) {
                event.accepted = true
                saveToModel()
                if (index <= 0)
                    return
                let previdx = index - 1
                let prev = docmodel.get(previdx).cur
                let next = (docmodel.get(index + 1) || docmodel.get(index)).cur
                console.error('back and begin', index, prev.level, level)
                if (prev.level <= level && next.level <= level) {
                    let prevlen = prev.raw.length
                    prev.raw += srctext.text
                    console.error(JSON.stringify(prev))
                    docmodel.get(previdx).cur = prev
                    listview.itemAtIndex(previdx).moveCursor(prevlen)
                    docmodel.remove(index)
                    listview.currentIndex--
                }
            } else if ((event.key === Qt.Key_Down && atEnd
                        || event.key === Qt.Key_Up && atBegin)
                       && Qt.ShiftModifier === event.modifiers) {
                event.accepted = true
                listview.startBulletEditing()
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
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
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
    function saveToModel() {
        docmodel.get(index).cur.raw = srctext.text
    }
}

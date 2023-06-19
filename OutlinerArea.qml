import QtQuick 2.13

Item {
    id: root;
    ListModel {
        id: docmodel
        function getChildEnd(idx) {
            let childEnd = idx, level = get(idx).cur.level
            do {
                childEnd++
            } while (get(childEnd) && get(childEnd).cur.level > level)
            return --childEnd
        }
    }
    Component.onCompleted: {
        clear();
    }

    ListView {
        anchors.fill: parent
        id: listview
        model: docmodel
        property bool bulletEditing: false
        property int selectionBegin: count
        property int selectionEnd: -1
        function startBulletEditing() {
            bulletEditing = true
            selectCurrent()
        }
        function exitBulletEditing() {
            for (var i = selectionBegin; i <= selectionEnd; i++)
                docmodel.get(i).bulletFocus_ = false
            console.error('exit bullet editing', selectionBegin, selectionEnd)
            selectionEnd = -1
            selectionBegin = count
            bulletEditing = false
            currentItem.forceFocus()
        }
        onCurrentIndexChanged: console.error('cur idx changed', currentIndex)
        function selectCurrent(forward) {
            let childEnd = docmodel.getChildEnd(
                    currentIndex), level = currentItem.cur.level
            console.error('select current=', currentIndex, childEnd,
                          'level', level)
            for (var i = currentIndex; i <= childEnd; i++)
                docmodel.get(i).bulletFocus_ = true
            if (forward) {
                currentIndex = childEnd
            }
            selectionBegin = Math.min(selectionBegin, currentIndex)
            selectionEnd = Math.max(selectionEnd, childEnd)
        }
        delegate: Bullet {
            required property var cur
            required property bool bulletFocus_
            required property int index
            required property int displayCollapsed
            raw: cur.raw
            level: cur.level
            collapsed: cur.collapsed || false
            indexInList: index
            bulletFocus: bulletFocus_
            visible: displayCollapsed === 0
            height: visible ? implicitHeight : 0
        }
        Component.onCompleted: {
            console.info(this, parent, width, height)
        }
        Keys.priority: Keys.BeforeItem
        Keys.onPressed: {
            console.error('key', event.key, Qt.Key_Delete, 'modifier',
                          event.modifiers, Qt.ShiftModifier)
            if (!bulletEditing)
                return
            if (event.key === Qt.Key_Down) {
                console.error('down select')
                incrementCurrentIndex()
                selectCurrent(true)
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                console.error('up select')
                decrementCurrentIndex()
                selectCurrent(false)
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                event.accepted = true
                exitBulletEditing()
            } else if (event.key === Qt.Key_Backspace) {
                console.error('delete selection')
                docmodel.remove(selectionBegin,
                                selectionEnd - selectionBegin + 1)
                exitBulletEditing()
            }
        }
    }

    function undo() {

    }

    function copy() {

    }

    function cut() {

    }

    function paste() {

    }

    function clear() {
        console.log("clear");
        docmodel.clear();
        docmodel.append({
                            "cur": {
                                "raw": "",
                                "level": 0
                            },
                            "bulletFocus_": false,
                            "displayCollapsed": 0
                        });
    }

    signal textChanged();

    function getText() {

    }

    function setText(value) {
        const lines = value.replace("\r\n", "\n").split("\n");
        if (lines.length === 0) {
            console.log("set 1");
            clear();
        } else {
            console.log("set 2");
            let previousLevel = -1;
            for (let line of lines) {
                const regex = /(\t*)([-+]) (.*)/;
                const result = regex.exec(line);

                let level, collapsed, content;
                if (!result) {
                    level = 0;
                    collapsed = false;
                    content = line;
                } else {
                    level = Math.min(previousLevel + 1, result[1].length);
                    collapsed = result[2] === "+";
                    content = result[3];
                    previousLevel = result[1].length;
                }

                docmodel.append({
                                    "cur": {
                                        "raw": content,
                                        "level": level
                                    },
                                    "bulletFocus_": false,
                                    "displayCollapsed": collapsed ? 1 : 0
                                });
            }
        }
    }
}

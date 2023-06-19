import QtQuick 2.13

Item {
    id: root
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
        clear()
    }

    ListView {
        anchors.fill: parent
        id: listview
        model: docmodel
        property bool bulletEditing: false
        property int selectionBegin: count
        property int selectionEnd: -1
        property int displayLevelBase: 0
        property int displayBegin: 0
        property int displayEnd: count
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
            level: cur.level - listview.displayLevelBase
            collapsed: cur.collapsed || false
            indexInList: index
            bulletFocus: bulletFocus_
            visible: displayCollapsed === 0 && index >= listview.displayBegin
                     && index < listview.displayEnd
            height: visible ? implicitHeight : 0
            onTextChanged: {
                root.textChanged()
            }
        }
        Component.onCompleted: {
            console.info(this, parent, width, height)
        }
        Keys.priority: Keys.BeforeItem
        Keys.onPressed: {
            console.error('key', event.key, Qt.Key_Delete, 'modifier',
                          event.modifiers, Qt.ShiftModifier)
            if (event.key === Qt.Key_Backspace
                    && event.modifiers === Qt.AltModifier) {
                displayBegin = 0
                displayEnd = count
                displayLevelBase = 0
            }

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

    function clear() {
        docmodel.clear()
        docmodel.append({
                            "cur": {
                                "raw": "",
                                "level": 0,
                                "collapsed": false
                            },
                            "bulletFocus_": false,
                            "displayCollapsed": 0
                        })
    }

    signal textChanged

    function getText() {
        const result = []
        for (var i = 0; i < docmodel.count; ++i) {
            const element = docmodel.get(i)
            const lines = element.cur.raw.replace("\r\n", "\n").split("\n");
            for (let idx = 0; idx < lines.length; ++idx) {
                const line = lines[idx];
                for (var j = 0; j < element.cur.level; ++j) {
                    result.push("\t")
                }
                console.log(idx);
                if (idx === 0) {
                    if (element.cur.collapsed) {
                        result.push("+ ")
                    } else {
                        result.push("- ")
                    }
                }
                result.push(line);
                result.push("\n");
            }
        }
        return result.join("")
    }

    function setText(value) {
        const lines = value.replace("\r\n", "\n").split("\n")
        console.log('lines', lines)

        if (lines.length === 0) {
            clear()
        } else {
            docmodel.clear()
            let level = 0, collapsed = false, content = ''
            const addNewBlock = () => {
                if (content && content.replace('\n', '').length) {
                    console.log(content, level, collapsed)
                    docmodel.append({
                                        "cur": {
                                            "raw": content,
                                            "level": level,
                                            "collapsed": collapsed
                                        },
                                        "bulletFocus_": false,
                                        "displayCollapsed": 0
                                    })
                }
            }

            for (let idx in lines) {
                const line = lines[idx] + '\n'
                console.log('line', line)

                const regex = /(\t*)([-+]) (.*)/
                const result = regex.exec(line)

                if (!result) {
                    const regex1 = /(\t*)(.*)/
                    let result1 = regex1.exec(line)
                    if (result1 && result1[1].length === level
                            && result1[2].length) {
                        console.log('same level')
                        content += result1[2]
                    } else {
                        console.log('new block')
                        addNewBlock()
                        level = 0
                        collapsed = false
                        content = line
                    }
                } else {
                    console.log('new block')
                    addNewBlock()
                    level = result[1].length
                    collapsed = result[2] === "+"
                    content = result[3]
                }
            }
            addNewBlock()
        }
    }
}

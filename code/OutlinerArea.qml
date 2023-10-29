import QtQuick 2.13

/**************************************************
  大纲编辑控件：为一系列 Bullet 的组合，用于展示一篇完整
  的 Markdown 文档。
**************************************************/

Item {
    id: root
    ListModel {
        // 定义数据模型，用于表示 Markdown 文档内容到每一个 Bullet 当中
        id: docmodel
        // 获取节点 idx 的子结点的最后一个结点的编号
        function getChildEnd(idx) {
            let childEnd = idx, level = get(idx).cur.level
            do {
                childEnd++
            } while (get(childEnd) && get(childEnd).cur.level > level)
            return --childEnd
        }
    }
    Component.onCompleted: {
        // 初始化后为空编辑器
        clear()
    }

    ListView {
        anchors.fill: parent
        id: listview
        model: docmodel  // 使用 docmodel，用于表示里面的数据
        property bool bulletEditing: false
        property int selectionBegin: count
        property int selectionEnd: -1
        // 以下三个属性用于聚焦
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
                    currentIndex), level = currentItem.level
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
            // docmodel 中的每一个元素对应一个 Bullet
            raw: cur.raw
            level: cur.level - listview.displayLevelBase
            collapsed: cur.collapsed || false
            indexInList: index
            bulletFocus: bulletFocus_
            visible: displayCollapsed === 0 && index >= listview.displayBegin
                     && index < listview.displayEnd  // 是否在聚焦范围内，同时是非折叠节点
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
            if (event.key === Qt.Key_R
                    && event.modifiers === Qt.ControlModifier) {
                // Ctrl+R 重置聚焦
                displayBegin = 0
                displayEnd = count
                displayLevelBase = 0
            }

            if (!bulletEditing)
                return
            if (event.key === Qt.Key_Down) {
                // 下方向键
                console.error('down select')
                incrementCurrentIndex()
                selectCurrent(true)
                event.accepted = true
            } else if (event.key === Qt.Key_Up) {
                // 上方向键
                console.error('up select')
                decrementCurrentIndex()
                selectCurrent(false)
                event.accepted = true
            } else if (event.key === Qt.Key_Escape) {
                // Esc 退出编辑
                event.accepted = true
                exitBulletEditing()
            } else if (event.key === Qt.Key_Backspace) {
                // 删除键
                console.error('delete selection')
                docmodel.remove(selectionBegin,
                                selectionEnd - selectionBegin + 1)
                exitBulletEditing()
            }
        }
    }

    function clear() {
        // 清空编辑区域同时插入一个空的子弹节点
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

    // 用于将 docmodel 中的内容转换成可以保存的 Markdown 文本
    function getText() {
        const result = []
        for (var i = 0; i < docmodel.count; ++i) {
            const element = docmodel.get(i)
            const lines = element.cur.raw.replace("\r\n", "\n").split("\n")
            for (var idx = 0; idx < lines.length; ++idx) {
                const line = lines[idx]
                for (var j = 0; j < element.cur.level; ++j) {
                    result.push("\t")
                }
                console.log(idx)
                if (idx === 0) {
                    if (element.cur.collapsed) {
                        result.push("+ ")
                    } else {
                        result.push("- ")
                    }
                }
                result.push(line)
                result.push("\n")
            }
        }
        return result.join("")
    }

    // 用于将 Markdown 文本转换为编辑器中的节点，使得用户可以进行编辑
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
                    console.log(JSON.stringify(content), level, collapsed)
                    docmodel.append({
                                        "cur": {
                                            "raw": content.substring(
                                                       0, content.length - 1),
                                            "level": level,
                                            "collapsed": collapsed
                                        },
                                        "bulletFocus_": false,
                                        "displayCollapsed": 0
                                    })
                }
            }

            for (let idx in lines) {
                const line = lines[idx]
                console.log('line', line)

                // 匹配一：节点的第一行
                const regex = /(\t*)([-+]) (.*)/
                const result = regex.exec(line)

                if (!result) {
                    // 匹配二：节点的后续行
                    const regex1 = /(\t*)(.*)/
                    let result1 = regex1.exec(line)
                    console.log(JSON.stringify(result1))
                    if (result1[1].length === level) {
                        console.log('same level')
                        if (result1[2].length) {
                            content += result1[2] + '\n'
                        } else {
                            content += "\n"
                        }
                    } else {
                        console.log('new block')
                        addNewBlock()
                        level = result1[1].length
                        collapsed = false
                        content = result1[2] + '\n'
                    }
                } else {
                    console.log('new block')
                    addNewBlock()
                    level = result[1].length
                    collapsed = result[2] === "+"
                    content = result[3] + '\n'
                }
            }
            addNewBlock()

            if (docmodel.count === 0) {
                // 如果文档是空，插入一个子弹节点
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
        }
    }
}

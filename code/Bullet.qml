import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

/**************************************************
  子弹控件：用于展示单行 Markdown 内容，并提供折叠、聚焦
  操作的实现。
**************************************************/

FocusScope {
    id: bullet
    width: listview.width
    implicitHeight: nodes.height  // 绑定子弹高度到编辑器高度
    property string raw: ''
    property bool collapsed: false
    property var nextItem: this
    property alias atEnd: editer.atEnd
    property alias atBegin: editer.atBegin
    property int level: 0
    property int indexInList
    property bool bulletFocus

    // 移动光标
    function moveCursor(pos) {
        console.error('blt.moveCursor')
        editer.moveCursor(pos)
    }

    // 强制设置焦点
    function forceFocus() {
        editer.focus = true
    }

    onRawChanged: {
        editer.defaultSource = raw
    }
    onBulletFocusChanged: {
        console.error(this, indexInList, 'bullet focus changed to', bulletFocus)
        background.focus = bulletFocus
    }
    Component.onCompleted: {
        btn.checked = collapsed
        collapsed = Qt.binding(function () {
            return btn.checked
        })
    }
    onCollapsedChanged: {
        let end = docmodel.getChildEnd(indexInList)
        let cur = docmodel.get(indexInList).cur
        docmodel.get(indexInList).cur = cur
        if (collapsed) {
            // 隐藏所有子节点
            for (var i = indexInList + 1; i <= end; i++) {
                docmodel.get(i).displayCollapsed++
                console.error('fold', i, docmodel.get(i).displayCollapsed)
            }
        } else {
            // 显示所有子节点（实际上是把 displayCollapsed 减一，而 displayCollapsed 到 0 才会显示）
            for (var i = indexInList + 1; i <= end; i++) {
                docmodel.get(i).displayCollapsed--
                console.error('unfold', i, docmodel.get(i).displayCollapsed)
            }
        }
        listview.forceLayout()
    }
    Rectangle {
        id: background
        anchors.fill: parent
        visible: focus
        color: Qt.rgba(0, .5, .8, .3)
    }

    signal textChanged

    RowLayout {
        anchors.fill: parent  // 填满父元素
        anchors.leftMargin: level * lineHeight
        spacing: 10  // 编辑器和 dotRect 中间留一些间隔
        Row {
            Item {
                // 用于展示折叠状态的三角形
                width: height * 0.8
                height: lineHeight
                HoverHandler {
                    id: hoverhdlr
                }
                Button {
                    id: btn
                    anchors.fill: parent
                    text: checked ? '▶' : '▼'  // 根据折叠状态选择展示的图标
                    checkable: true
                    checked: initChecked()
                    background: Item {}
                    font.pixelSize: 8
                    anchors.centerIn: parent
                    visible: hoverhdlr.hovered
                }
            }
            Item {
                // 子弹圆点
                width: height * 0.3
                height: lineHeight
                HoverHandler {
                    id: dothoverhdlr
                }
                TapHandler {
                    onTapped: {
                        console.error('enter bullet', this, indexInList)
                        // 点击子弹，进入聚焦
                        listview.displayBegin = indexInList
                        listview.displayEnd = docmodel.getChildEnd(
                                    indexInList) + 1
                        listview.displayLevelBase = level
                        listview.currentIndex = indexInList
                        editer.forceActiveFocus()
                    }
                }

                Rectangle {
                    width: 16
                    height: width
                    radius: width / 2
                    color: Qt.rgba(0, 0, 0, .05)
                    visible: dothoverhdlr.hovered || collapsed
                    anchors.centerIn: parent
                }
                Rectangle {
                    // 用于用户交互反馈
                    width: dothoverhdlr.hovered ? 8 : 6
                    height: width
                    radius: width / 2
                    color: dothoverhdlr.hovered ? "lightslategray" : "lightGray"
                    anchors.centerIn: parent

                    Behavior on width {
                        NumberAnimation {
                            duration: 300
                            easing.type: Easing.OutExpo
                        }
                    }
                }
            }
            Layout.alignment: Qt.AlignTop
        }
        Column {
            Layout.fillWidth: true // 填充剩余的宽度
            id: nodes
            // 子弹右侧是 Markdown 编辑器控件
            Textediter {
                id: editer
                focus: bullet.focus && !bullet.bulletFocus
                anchors.left: parent.left
                anchors.right: parent.right
                index: bullet.indexInList
                onTextChanged: {
                    bullet.textChanged()
                }
            }
        }
    }
}

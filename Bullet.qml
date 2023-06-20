import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

FocusScope {
    id: bullet
    width: listview.width
    implicitHeight: nodes.height // bind bullet height to editor height
    property string raw: ''
    property bool collapsed: false
    property var nextItem: this
    property alias atEnd: editer.atEnd
    property alias atBegin: editer.atBegin
    property int level: 0
    property int indexInList
    property bool bulletFocus
    function moveCursor(pos) {
        console.error('blt.moveCursor')
        editer.moveCursor(pos)
    }
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
            for (var i = indexInList + 1; i <= end; i++) {
                docmodel.get(i).displayCollapsed++
                console.error('fold', i, docmodel.get(i).displayCollapsed)
            }
        } else {
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
        anchors.fill: parent // fill the parent item
        anchors.leftMargin: level * lineHeight
        spacing: 10 // some spacing between dotRect and editor
        Row {
            Item {
                // fold triangle
                width: height * 0.8
                height: lineHeight
                HoverHandler {
                    id: hoverhdlr
                }
                Button {
                    id: btn
                    anchors.fill: parent
                    text: checked ? '▶' : '▼'
                    checkable: true
                    checked: initChecked()
                    background: Item {}
                    font.pixelSize: 8
                    anchors.centerIn: parent
                    visible: hoverhdlr.hovered
                }
            }
            Item {
                // dot rect
                width: height * 0.3
                height: lineHeight
                HoverHandler {
                    id: dothoverhdlr
                }
                TapHandler {
                    onTapped: {
                        console.error('enter bullet', this, indexInList)
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
            Layout.fillWidth: true // fill all available width
            id: nodes
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

import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

FocusScope {
    id: bullet
    width: window.width
    implicitHeight: nodes.height // bind bullet height to editor height
    property string raw: ''
    property bool collapsed: false
    property var nextItem: this
    property alias atEnd: editer.atEnd
    property alias atBegin: editer.atBegin
    property int level: 0
    property int indexInList
    property bool bulletFocus
    //    onLevelChanged: console.error(this, 'level changed to', level)
    function moveCursor(pos) {
        console.error('blt.moveCursor')
        editer.moveCursor(pos)
    }
    function forceFocus() {
        editer.focus = true
    }

    onRawChanged: {
        //        console.error(this, 'raw changed', raw)
        editer.defaultSource = raw
    }
    onBulletFocusChanged: {
        console.error(this, indexInList, 'bullet focus changed to', bulletFocus)
        background.focus = bulletFocus
    }
    Rectangle {
        id: background
        anchors.fill: parent
        visible: focus
        color: Qt.rgba(0, .5, .8, .3)
    }

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
                    anchors.fill: parent
                    text: checked ? '▶' : '▼'
                    checkable: true
                    background: Item {}
                    font.pixelSize: 8
                    anchors.centerIn: parent
                    visible: hoverhdlr.hovered
                    Component.onCompleted: console.error('button', width)
                    onCheckedChanged: {
                        let end = docmodel.getChildEnd(indexInList)
                        let cur = docmodel.get(indexInList).cur
                        cur.collapsed = checked
                        docmodel.get(indexInList).cur = cur
                        if (checked) {
                            for (var i = indexInList + 1; i <= end; i++)
                                docmodel.get(i).displayCollapsed++
                        } else {
                            for (var i = indexInList + 1; i <= end; i++)
                                docmodel.get(i).displayCollapsed--
                        }
                        listview.forceLayout()
                    }
                }
            }
            Item {
                // dot rect
                width: height * 0.3
                height: lineHeight
                HoverHandler {
                    id: dothoverhdlr
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
            }
        }
    }
    Component.onCompleted: {

        //        console.info(this, JSON.stringify(cur), JSON.stringify(childblocks))
    }
}

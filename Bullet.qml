import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

FocusScope {
    id: bullet
    width: window.width
    implicitHeight: nodes.height // bind bullet height to editor height
    property string raw: ''
    //    property var childblocks: []
    //    property var childComp: null
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

        Item {
            width: height
            height: lineHeight
            Rectangle {
                width: 6
                height: width
                radius: width / 2
                color: "lightGray"
                anchors.centerIn: parent
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
            //            Repeater {
            //                model: childblocks
            //                Loader {
            //                    sourceComponent: childComp
            //                    property var _cur: modelData.cur
            //                    property var _childblocks: modelData.childblocks
            //                    property var _childComp: childComp
            //                    Component.onCompleted: {

            //                        //                        console.info(this, JSON.stringify(modelData))
            //                    }
            //                }
            //                Component.onCompleted: {

            //                    //                    console.info(this, JSON.stringify(childblocks))
            //                }
            //            }
        }
    }
    Component.onCompleted: {

        //        console.info(this, JSON.stringify(cur), JSON.stringify(childblocks))
    }
}

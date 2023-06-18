import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Window {
    id: window
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")
    property int lineHeight: 30
    ScrollView {
        id: view
        anchors.fill: parent
        Component.onCompleted: {
            console.info(this, width, height, contentWidth, contentHeight)
        }

        Column {
            width: parent.width
            Repeater {
                id: repeater
                width: parent.width
                model: 1000
                Bullet {
                    cur: {
                        "raw": `level 1 no.${index}`
                    }
                    childblocks: []
                    childComp: Component {
                        Bullet {
                            cur: _cur
                            childblocks: _childblocks
                            childComp: _childComp
                        }
                    }
                    //                    KeyNavigation.down: nextItem //假设nextItem是下一个控件的id
                    Keys.priority: Keys.BeforeItem
                    Keys.onPressed: {
                        console.error('key', event.key)
                        if (event.key == Qt.Key_Down) {
                            //使用moveCursorSelection方法来判断光标是否在最后一行
                            let nextItem = repeater.itemAt(index + 1)
                            nextItem.focus = true
                            //                            nextItem.forceActiveFocus(0)
                            console.error(index, nextItem)
                            event.accepted = true
                        } else if (event.key == Qt.Key_Up) {
                            let nextItem = repeater.itemAt(index - 1)
                            nextItem.focus = true
                            console.error(index, nextItem)
                            event.accepted = true
                        } else if (event.key == Qt.Key_Enter
                                   && (event.modifiers & Qt.ControlModifier)) {
                            console.error('add node')
                        } else if (event.key == Qt.Key_Tab) {
                            console.error('indent')
                        }
                    }
                }
                Component.onCompleted: {
                    console.info(this, parent, width, height)
                }
            }
            Component.onCompleted: {
                console.info(this, width, height)
            }
        }
    }
    function genColor(cur, tot) {
        const ncolors = 10
        const curcolor = cur % ncolors
        const curval = curcolor * (1 / ncolors)
        return Qt.rgba(curval, curval, curval, 1)
    }
}

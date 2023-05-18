import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    width: window.width
    implicitHeight: nodes.height // bind bullet height to editor height
    property var cur: {
        "raw": 'blank'
    }
    property var childblocks: []
    property var childComp: null

    RowLayout {
        anchors.fill: parent // fill the parent item
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
            TextEdit {
                text: cur.raw // some text
                font.pointSize: 14
                wrapMode: TextEdit.Wrap // wrap text if too long
            }
            Repeater {
                model: childblocks
                Loader {
                    sourceComponent: childComp
                    property var _cur: modelData.cur
                    property var _childblocks: modelData.childblocks
                    property var _childComp: childComp
                    Component.onCompleted: {

                        //                        console.info(this, JSON.stringify(modelData))
                    }
                }
                Component.onCompleted: {

                    //                    console.info(this, JSON.stringify(childblocks))
                }
            }
        }
    }
    Component.onCompleted: {

        //        console.info(this, JSON.stringify(cur), JSON.stringify(childblocks))
    }
}

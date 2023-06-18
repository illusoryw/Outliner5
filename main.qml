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
        anchors.fill: parent
        Component.onCompleted: {
            console.info(this, width, height, contentWidth, contentHeight)
        }

        Column {
            width: parent.width
            Repeater {
                width: parent.width
                model: 1000
                Bullet {
                    cur: {
                        "raw": 'root'
                    }
                    childblocks: [
                        /*{
                            "cur": {
                                "raw": 'child1'
                            },
                            "childblocks": []
                        }, {
                            "cur": {
                                "raw": 'child2'
                            },
                            "childblocks": [{
                                    "cur": {
                                        "raw": 'child2.1'
                                    },
                                    "childblocks": []
                                }]
                        }, {
                            "cur": {
                                "raw": 'child3'
                            },
                            "childblocks": []
                        }*/ ]
                    childComp: Component {
                        Bullet {
                            cur: _cur
                            childblocks: _childblocks
                            childComp: _childComp
                        }
                    }
                }

                //                Rectangle {
                //                    height: lineHeight
                //                    width: window.width
                //                    color: genColor(index, parent.model)

                //                    Column {
                //                        Item {
                //                            width: height
                //                            height: lineHeight
                //                            Rectangle {
                //                                width: 6
                //                                height: width
                //                                radius: width / 2
                //                                color: "lightGray"
                //                                anchors.centerIn: parent
                //                            }
                //                        }
                //                    }

                //                    Component.onCompleted: {
                //                        console.info(this, parent, width, height)
                //                    }
                //                }
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
    // Textediter{
    //     id: editer
    //     anchors.fill:parent
    //     anchors.leftMargin: parent.width*(0.3)
    // }
    // MouseArea{
    //     anchors.fill:parent
    //     anchors.rightMargin: editer.width
    //     anchors.bottomMargin: editer.height*0.5
    //     onClicked: {
    //         editer.focus=false
    //         parent.focus=true
    //         console.log("focus changed leave Textediter")
    //     }
    // }
    // MouseArea{
    //     anchors.fill:parent
    //     anchors.rightMargin: editer.width
    //     anchors.topMargin: editer.height*0.5
    //     onClicked: {
    //         editer.focus=true
    //         parent.focus=false
    //         console.log("focus changed to Textediter")
    //     }
    }
}

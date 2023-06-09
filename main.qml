import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.1
ApplicationWindow {
    id: outliner5
    width: 640
    height: 480
    visible: true
    flags: Qt.Window
    title: qsTr("Outliner5")

    /*Button {
        text: "新建"
    }*/
    menuBar: MenuBar {
        /*Menu{
            id: menu
            y: fileButton.height
            title: "文件(File)"
            MenuItem{
                text: "新建(New...)"
            }
            MenuItem{
                text: "打开(Open...)"
            }
            MenuItem{
                text: "最近打开(Open recent)"
            }
            MenuItem{
                text: "保存(Save)"
            }
            MenuItem{
                text: "另存为(Save as)"
            }
            MenuSeparator {
                padding: 0
                topPadding: 12
                bottomPadding: 12
                contentItem: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 1
                    color: "#1E000000"
                }
            }
            MenuItem {
                text: qsTr("退出(Exit)")
            }
        }*/
        Menu {
            title: qsTr("&文件(File)")
            Action { text: qsTr("&新建(New...)") }
            Action { text: qsTr("&打开(Open...)") }
            Action { text: qsTr("&最近打开(Open recent)") }
            Action { text: qsTr("保存(Save)") }
            Action { text: qsTr("另存为(Save as)") }
            MenuSeparator {
                padding: 0
                topPadding: 12
                bottomPadding: 12
                contentItem: Rectangle {
                    implicitWidth: 200
                    implicitHeight: 1
                    color: "#1E000000"
                }
            }
            Action { text: qsTr("&退出(Exit)") }
                }

    }
    //方法二:直接在菜单中显示出五个按钮
    /*ToolBar {
        RowLayout
        {
          ToolButton
          {
              text: "新建(New...)"
          }
          ToolButton
          {
              text: "打开(Open...)"
          }
          ToolButton
          {
              text: "最近打开(Open recent)"
          }
          ToolButton
          {
              text: "保存(Save)"
          }
          ToolButton
          {
              text: "另存为(Save as)"
          }

        }

    }*/
    //文本输入框
    ScrollView {
        id: view
        anchors.fill: parent

        TextArea {
            text: ""
        }
    }




}



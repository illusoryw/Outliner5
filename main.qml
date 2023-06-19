import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import com.mytexteditor.filerwritter 1.0
import Qt.labs.folderlistmodel 2.1

ApplicationWindow {
    //title: qsTr("TextEditor")
    title: (filename == "") ? "outliner5" : filename + " -outliner5"
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
    id: window
    property string filepath: ""
    property string filename: ""

    //最近访问文件
    property string visited1: ""
    property bool clickvisited1: false
    property string visited2: ""
    property bool clickvisited2: false
    property string visited3: ""
    property bool clickvisited3: false
    property string visited4: ""
    property bool clickvisited4: false
    property string visited5: ""
    property bool clickvisited5: false

    // 定义文件夹列表模型
    FolderListModel {
        id: folderModel
        nameFilters: ["*.md"]
        showDirs: true
        folder: folderPath
    }

    // 定义文件夹路径
    property string folderPath: ""

    // 定义文件夹是否打开
    property bool folderOpened: false
    // 定义文件是否打开
    property bool fileOpened: false

    // 定义树形文件列表的宽度
    property int treeViewWidth: 200

    //        // 定义打开文件夹的对话框
    //        FileDialog {
    //            id: folderDialog
    //            title: "Open Folder"
    //            folder: shortcuts.home
    //            selectFolder: true
    //            onAccepted: {
    //                folderPath = folderDialog.fileUrl//改了，本来是folder
    //                folderOpened = true
    //                console.log("%s",folderPath)
    //            }
    //        }
    menuBar: MenuBar {
        Menu {
            title: qsTr("文件(&F)")
            MenuItem {
                text: qsTr("新建")
                shortcut: "Ctrl+N"
                onTriggered: //messageDialog.open();
                             if (fileOpened && textareaid.saved == false) {
                                 //有文件打开但没有保存
                                 messageDialog.open()
                                 //fileDialog.open();
                                 //clearTextArea();
                             } else {
                                 fileDialog.open()
                             } //有文件打开并且保存 和 没有文件打开
            }
            MenuItem {
                text: qsTr("打开")
                shortcut: "Ctrl+O"
                onTriggered: //messageDialogopen.open();
                             if (fileOpened && textareaid.saved == false) {
                                 //文件打开但是没有保存
                                 messageDialogopen.open()
                             } else {
                                 //有文件打开并且保存 和 没有文件打开
                                 openfileDialog.open()
                             }
            }

            MenuItem {
                text: qsTr("保存")
                shortcut: "Ctrl+S"
                onTriggered: if (fileOpened) {
                                 saveFile()
                             }
            }
            MenuItem {
                text: qsTr("另存为")
                //shortcut: "Ctrl+A"
                onTriggered: //if(fileOpened){fileDialog.open();}
                             if (fileOpened && textareaid.saved == false) {
                                 messageDialogsaveanother.open()
                             } //已有文件打开但是没有保存
                             else if (fileOpened && textareaid.saved) {
                                 fileDialogsaveanother.open()
                             }
            }
            Menu {
                title: qsTr("最近打开文件")
                MenuItem {
                    text: qsTr(window.visited1 == "" ? "无" : window.visited1)
                    onTriggered: {
                        clickvisited1 = true
                        if (textareaid.saved == false) {
                            messageDialogopenvisited.open()
                        } else {
                            openVisited()
                        }
                    }
                }
                MenuItem {
                    text: qsTr(window.visited2 == "" ? "无" : window.visited2)
                    onTriggered: {
                        clickvisited2 = true
                        if (textareaid.saved == false) {
                            messageDialogopenvisited.open()
                        } else {
                            openVisited()
                        }
                    }
                }
                MenuItem {
                    text: qsTr(window.visited3 == "" ? "无" : window.visited3)
                    onTriggered: {
                        clickvisited3 = true
                        if (textareaid.saved == false) {
                            messageDialogopenvisited.open()
                        } else {
                            openVisited()
                        }
                    }
                }
                MenuItem {
                    text: qsTr(window.visited4 == "" ? "无" : window.visited4)
                    onTriggered: {
                        clickvisited4 = true
                        if (textareaid.saved == false) {
                            messageDialogopenvisited.open()
                        } else {
                            openVisited()
                        }
                    }
                }
                MenuItem {
                    text: qsTr(window.visited5 == "" ? "无" : window.visited5)
                    onTriggered: {
                        clickvisited5 = true
                        if (textareaid.saved == false) {
                            messageDialogopenvisited.open()
                        } else {
                            openVisited()
                        }
                    }
                }
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("关闭")
                shortcut: "Ctrl+Q"
                onTriggered: //Qt.quit();程序直接结束
                             if (fileOpened && textareaid.saved) {
                                 window.filepath = ""
                                 window.filename = ""
                                 textareaid.saved = false
                                 fileOpened = false
                             } else if (fileOpened) {
                                 messageDialogclose.open()
                             }
            }
        }
        Menu {
            title: qsTr("编辑(&E)")
            MenuItem {
                text: qsTr("撤销")
                shortcut: "Ctrl+Z"
                onTriggered: if (fileOpened) {
                                 textareaid.undo()
                             }
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("复制")
                shortcut: "Ctrl+C"
                onTriggered: if (fileOpened) {
                                 textareaid.copy()
                             }
            }
            MenuItem {
                text: qsTr("剪切")
                onTriggered: if (fileOpened) {
                                 textareaid.cut()
                             }
                shortcut: "Ctrl+X"
            }
            MenuItem {
                text: qsTr("粘贴")
                shortcut: "Ctrl+V"
                onTriggered: if (fileOpened) {
                                 textareaid.paste()
                             }
            }
            MenuItem {
                text: qsTr("删除")
                shortcut: "Del"
                onTriggered: if (fileOpened) {
                                 textareaid.remove(textareaid.selectionStart,
                                                   textareaid.selectionEnd)
                             }
            }

            MenuSeparator {}
            MenuItem {
                text: qsTr("查找")
                shortcut: "Ctrl+F"
                onTriggered: if (fileOpened) {
                                 findtextdlg.visible = true
                             }
            }
            MenuItem {
                text: qsTr("查找下一个")

                // shortcut: "Ctrl+X"
            }
            MenuItem {
                text: qsTr("替换")
                shortcut: "Ctrl+H"
            }
            MenuItem {
                text: qsTr("转到")
                shortcut: "Ctrl+G"
                onTriggered: ;
            }
            MenuSeparator {}
            MenuItem {
                text: qsTr("全选")
                shortcut: "Ctrl+A"
                onTriggered: if (fileOpened) {
                                 textareaid.selectAll()
                             }
            }
            MenuItem {
                text: qsTr("日期/时间")
                onTriggered: if (fileOpened) {
                                 textareaid.insert(
                                             textareaid.cursorPosition,
                                             Qt.formatDateTime(
                                                 new Date(),
                                                 "dddd yyyy-MM-dd MMM hh-mm-ss"))
                             }
                //shortcut: "Ctrl+X"
            }
        }
        Menu {
            title: qsTr("格式(&O)")
            MenuItem {
                id: autoReturnMenuid
                text: qsTr("自动换行")
                shortcut: "Ctrl+Z"
                checkable: true
                onTriggered: if (fileOpened) {
                                 setStatusBarState()
                             }
            }

            MenuItem {
                text: qsTr("字体")
                shortcut: "Ctrl+C"
                onTriggered: if (fileOpened) {
                                 fontDialog.open()
                             }
            }
        }
        Menu {
            title: qsTr("查看(&V)")
            MenuItem {
                id: showStatusBarMenuid
                text: qsTr("状态栏")
                shortcut: "Ctrl+Z"
                checkable: true
                onTriggered: if (fileOpened) {
                                 setStatusBarState()
                             }
            }
        }
        Menu {
            title: qsTr("关于(&V)")
            MenuItem {
                text: qsTr("关于记事本")
                onTriggered: aboutapp()
            }
        }
        //    Menu {
        //                title: "文件夹"
        //                MenuItem {
        //                    text: "打开文件夹"
        //                    onTriggered: folderDialog.open()

        //                }
        //                MenuItem {
        //                    text: "关闭文件夹"
        //                    onTriggered: {
        //                                       folderOpened = false
        //                                       folderPath = ""
        //                                   }
        //                                   enabled: folderOpened
        //                }
        //            }
    }

    //// 定义文件夹树形列表
    //TreeView {
    //    id: folderTreeView
    //    width: 200
    //    height: parent.height
    //    anchors.left: parent.left
    //    anchors.top: parent.top
    //    anchors.bottom: parent.bottom
    //    visible: folderOpened

    //    FolderListModel {
    //        id: treeModel
    //        nameFilters: ["*.md"]
    //        showDirs: true// 显示子目录
    //        folder: folderPath
    //    }

    //    model: treeModel

    ////    // 定义递归函数，用于显示文件夹的树形目录
    ////    function createTree(parentItem, parent) {
    ////        for (var i = 0; i < parent.count; i++) {
    ////            var item = parent.get(i);
    ////            var newItem = Qt.createQmlObject("import QtQuick.Controls 2.0; TreeItem {}", folderTreeView);
    ////            newItem.text = item.fileName;
    ////            newItem.isFolder = item.isDir;
    ////            newItem.filePath = item.filePath;
    ////            newItem.parentItem = parentItem;
    ////            if (item.isDir) {
    ////                newItem.isExpanded = true;
    ////                createTree(newItem, item);
    ////            }
    ////            parentItem.appendRow(newItem);
    ////        }
    ////    }

    ////    Component.onCompleted: {
    ////        // 清空原有的树形目录
    ////        folderTreeView.clear();
    ////        // 创建根节点
    ////        var rootItem = Qt.createQmlObject("import QtQuick.Controls 2.0; TreeItem {}", folderTreeView);
    ////        rootItem.text = folderPath;
    ////        rootItem.isFolder = true;
    ////        rootItem.filePath = folderPath;
    ////        // 递归创建树形目录
    ////        createTree(rootItem, treeModel);
    ////        // 将根节点添加到TreeView中
    ////        folderTreeView.model = rootItem;
    ////    }

    //        onClicked: {
    //            if (model.isFolder) {
    //                model.isExpanded = !model.isExpanded
    //            } else {
    //                openfileDialog.open(model.filePath);
    //            }
    //        }
    //        onDoubleClicked: {
    //            if (!model.isFolder) {
    //                fileEditor.openFile(model.filePath)
    //            }
    //        }

    //}
    // 定义纯文本编辑框
    TextArea {
        id: textareaid
        width: folderOpened ? parent.width - folderTreeView.width : parent.width
        height: parent.height
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        property bool saved: false
        onCursorPositionChanged: setStatusBarState()
        onTextChanged: saved = false
        visible: fileOpened
    }

    statusBar: StatusBar {
        id: statusbarid
        visible: false
        RowLayout {
            //  anchors.fill: parent
            Label {
                text: ""
                id: statuslabel
            }
            Rectangle {
                width: 100
                height: parent.height
                color: "red"
            }
            Label {
                text: "555"
                id: positionlabel
            }
        }
    }

    function changevisited(currentfilename) {
        var index = 0
        if (currentfilename === visited1)
            index = 1
        else if (currentfilename === visited2)
            index = 2
        else if (currentfilename === visited3)
            index = 3
        else if (currentfilename === visited4)
            index = 4
        else if (currentfilename === visited5)
            index = 5

        if (index == 0 || index == 5) {
            window.visited5 = window.visited4
            window.visited4 = window.visited3
            window.visited3 = window.visited2
            window.visited2 = window.visited1
            window.visited1 = currentfilename
        } else if (index == 2) {
            window.visited2 = window.visited1
            window.visited1 = currentfilename
        } else if (index == 3) {
            window.visited3 = window.visited2
            window.visited2 = window.visited1
            window.visited1 = currentfilename
        } else if (index == 4) {
            window.visited4 = window.visited3
            window.visited3 = window.visited2
            window.visited2 = window.visited1
            window.visited1 = currentfilename
        }
    }
    function openVisited() {
        var filename = ""
        if (window.clickvisited1 == true)
            filename = window.visited1
        else if (window.clickvisited2 == true)
            filename = window.visited2
        else if (window.clickvisited3 == true)
            filename = window.visited3
        else if (window.clickvisited4 == true)
            filename = window.visited4
        else if (window.clickvisited5 == true)
            filename = window.visited5
        //var  filename = openfileDialog.fileUrl;
        filerwritterid.m_fileName = filename
        var filedata = filerwritterid.readFile()
        textareaid.text = filedata
        window.filepath = filename
        //var tmp=window.filepath.lastIndexOf('/');
        window.filename = filepath.substr((filepath.lastIndexOf('/') + 1))
        changevisited(filename)
        //window.visited1=filename;
        textareaid.saved = false
        window.clickvisited1 = false
        window.clickvisited2 = false
        window.clickvisited3 = false
        window.clickvisited4 = false
        window.clickvisited5 = false
    }
    function openFile() {
        messageDialogopen.open()
    }

    function aboutapp() {
        aboutappdialog.visible = true
    }

    function setTextColor() {
        textareaid.textColor = colorDialog.color
    }

    function setStatusBarState() {
        positionlabel.text = textareaid.cursorPosition
        if (autoReturnMenuid.checked) {
            statusbarid.visible = false
            showStatusBarMenuid.enabled = false
        } else {
            showStatusBarMenuid.enabled = true
            if (showStatusBarMenuid.checked) {
                statusbarid.visible = true
            } else {
                statusbarid.visible = false
            }
        }
    }

    function setTextFont() {
        textareaid.font = fontDialog.font
    }

    function clearTextArea() {
        textareaid.selectAll()
        textareaid.remove(0, textareaid.cursorPosition)
    }

    function newFile() {
        // if(textareaid.saved)
        //  {
        //    clearTextArea();
        //  }
        // else
        if (textareaid.saved == false) //&& textareaid.text.length > 0)
        {
            messageDialog.open()
        } else {
            clearTextArea()
            window.filepath = ""
            window.filename = ""
        }

        //  clearTextArea();
        //   window.filepath="";
    }

    function saveFile() {
        if (window.filepath.length == 0) //由于使用了fileOpened，所以这里可以省去
        {
            fileDialog.open()
        } else {
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
        }
        textareaid.saved = true
    }

    function saveanotherFile() {
        fileDialogsaveanother.open()
    }

    function changeCaseSensitiveState() {
        if (casecheckid.checked) {
            findtextdlg.casesensitve = true
        } else {
            findtextdlg.casesensitve = false
        }
    }

    function changeFindTextWard() {
        if (upbuttonid.checked) {
            findtextdlg.upward = true
        } else if (donwbuttonid.checked) {
            findtextdlg.upward = false
        }
    }

    function findNextText() {
        if (findtextdlg.index === -1 || textareaid.text.length == 0) {
            return
        }

        var start_index = 0
        if (findtextdlg.index > 0) {
            start_index = findtextdlg.index + textfieldid.text.length
            if (findtextdlg.upward) {
                start_index = findtextdlg.index
            }
        } else if (findtextdlg.upward) {
            start_index = textareaid.text.length
        }
        console.log("startindex :" + start_index)

        var contentstr
        var findText
        if (findtextdlg.casesensitve == true) {
            contentstr = textareaid.text.substring(start_index)
            if (findtextdlg.upward) {
                contentstr = textareaid.text.substring(0, start_index).trim()
            }
            findText = textfieldid.text
        } else {
            contentstr = textareaid.text.substring(start_index).toLowerCase()
            if (findtextdlg.upward) {
                contentstr = textareaid.text.substring(
                            0, start_index).toLowerCase().trim()
            }
            findText = textfieldid.text.toLowerCase()
        }
        console.log("contentstr :" + contentstr)
        if (contentstr.length === 0) {
            return
        }

        var index = contentstr.indexOf(findText)
        if (findtextdlg.upward) {
            index = contentstr.lastIndexOf(findText)
        }
        console.log("index :" + index)

        if (index < 0) {
            completeFindDialog.open()
            findtextdlg.index = -1
            return
        }

        var old_index = findtextdlg.index
        var select_start = old_index + index + textfieldid.text.length
        var select_end = textfieldid.text.length + old_index + textfieldid.text.length + index
        if (old_index == 0) {
            select_start = old_index + index
            select_end = old_index + textfieldid.text.length + index
        } else if (findtextdlg.upward) {
            select_start = index
            select_end = textfieldid.text.length + index
        }
        console.log("select_start :" + select_start)
        console.log("select_end :" + select_end)

        textareaid.select(select_start, select_end)
        findtextdlg.index = old_index + index + textfieldid.text.length
        if (findtextdlg.upward) {
            findtextdlg.index = index
        }
        console.log("findtextdlg.index :" + findtextdlg.index)
        if ((findtextdlg.upward && index === 0)) {
            completeFindDialog.open()
            findtextdlg.index = -1
            return
        }
    }

    function changeButtonState() {
        if (textfieldid.text.length != 0) {
            findnextid.enabled = true
        } else {
            findnextid.enabled = false
        }
    }

    function reject() {
        findtextdlg.index = 0
        findtextdlg.casesensitve = false
        findtextdlg.upward = false
        findtextdlg.close()
        casecheckid.checked = false
        upbuttonid.checked = false
        donwbuttonid.checked = true
        textfieldid.text = ""

        console.log("close dialog")
    }

    ColorDialog {
        id: colorDialog
        title: "Please choose a color"
        onAccepted: {
            setTextColor()
        }
        onRejected: {

            // console.log("Canceled")
            // Qt.quit()
        }
        //Component.onCompleted: visible = true
    }

    FontDialog {
        id: fontDialog
        title: "Please choose a font"
        font: Qt.font({
                          "family": "Arial",
                          "pointSize": 24,
                          "weight": Font.Normal
                      })
        onAccepted: {
            setTextFont()
        }
        onRejected: {
            console.log("Canceled")
            //  Qt.quit()
        }
    }

    MessageDialog {
        id: messageDialogopenvisited //打开最近文件的保存部分
        title: "提示"
        text: "是否需要保存当前文件？"
        property string texttmp: ""
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {
            //保存已打开文件
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
            textareaid.saved = true
            //openfileDialog.open()
            openVisited()
            //        var filename="";
            //        if(window.clickvisited1==true) filename=window.visited1;
            //        else if(window.clickvisited2==true) filename=window.visited2;
            //        else if(window.clickvisited3==true) filename=window.visited3;
            //        else if(window.clickvisited4==true) filename=window.visited4;
            //        else if(window.clickvisited5==true) filename=window.visited5;
            //        //var  filename = openfileDialog.fileUrl;
            //        filerwritterid.m_fileName = filename;
            //        var filedata = filerwritterid.readFile();
            //        textareaid.text = filedata;
            //        window.filepath = filename;
            //        //var tmp=window.filepath.lastIndexOf('/');
            //        window.filename=filepath.substr((filepath.lastIndexOf('/')+1));
            //        changevisited(filename);
            //        //window.visited1=filename;
            //        textareaid.saved=false;
            //        window.clickvisited1=false;
            //        window.clickvisited2=false;
            //        window.clickvisited3=false;
            //        window.clickvisited4=false;
            //        window.clickvisited5=false;
        }
        onNo: {
            //openfileDialog.open()
            openVisited()
            //        var filename="";
            //        if(window.clickvisited1==true) filename=window.visited1;
            //        else if(window.clickvisited2==true) filename=window.visited2;
            //        else if(window.clickvisited3==true) filename=window.visited3;
            //        else if(window.clickvisited4==true) filename=window.visited4;
            //        else if(window.clickvisited5==true) filename=window.visited5;
            //        //var  filename = openfileDialog.fileUrl;
            //        filerwritterid.m_fileName = filename;
            //        var filedata = filerwritterid.readFile();
            //        textareaid.text = filedata;
            //        window.filepath = filename;
            //        //var tmp=window.filepath.lastIndexOf('/');
            //        window.filename=filepath.substr((filepath.lastIndexOf('/')+1));
            //        changevisited(filename);
            //        //window.visited1=filename;
            //        textareaid.saved=false;
            //        window.clickvisited1=false;
            //        window.clickvisited2=false;
            //        window.clickvisited3=false;
            //        window.clickvisited4=false;
            //        window.clickvisited5=false;
        }
        onRejected: {
            window.clickvisited1 = false
            window.clickvisited2 = false
            window.clickvisited3 = false
            window.clickvisited4 = false
            window.clickvisited5 = false
        }

        visible: false
    }

    MessageDialog {
        id: messageDialogopen //保存部分
        title: "提示"
        text: "是否需要保存当前文件？"
        property string texttmp: ""
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {
            //保存已打开文件
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
            textareaid.saved = true
            openfileDialog.open()
        }
        onNo: {
            openfileDialog.open()
        }

        //   Cancel:
        //   {
        //       visible: false;
        //   }
        visible: false
    }

    MessageDialog {
        id: messageDialogsaveanother
        title: "提示"
        text: "是否需要保存当前文件？"
        property string texttmp: ""
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
            textareaid.saved = true
            fileDialogsaveanother.open()
        }
        onNo: {
            fileDialogsaveanother.open()
        }

        //   Cancel:
        //   {
        //       visible: false;
        //   }
        visible: false
    }

    MessageDialog {
        id: messageDialogclose
        title: "提示"
        text: "是否需要保存当前文件？"
        property string texttmp: ""
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
            textareaid.saved = true
            window.filepath = ""
            window.filename = ""
            textareaid.saved = false
            fileOpened = false
        }
        onNo: {
            window.filepath = ""
            window.filename = ""
            textareaid.saved = false
            fileOpened = false
        }

        //   Cancel:
        //   {
        //       visible: false;
        //   }
        visible: false
    }

    MessageDialog {
        id: messageDialog //新建：有文件打开但没有保存
        title: "提示"
        text: "是否需要保存当前文件？"
        property string texttmp: ""
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel
        onYes: {
            filerwritterid.m_fileName = window.filepath
            filerwritterid.saveFile(textareaid.text)
            textareaid.saved = true
            fileDialog.open()
        }
        onNo: {
            fileDialog.open()
        }

        //   Cancel:
        //   {
        //       visible: false;
        //   }
        visible: false
    }

    MessageDialog {
        id: aboutappdialog
        title: "关于outliner5"
        text: "outliner5是一款本地Markdown笔记软件，在支持对Markdown语法处理的同时将支持笔记大纲的分级处理与折叠显示。该软件系统将市面上常见的笔记管理软件与Markdown编辑器结合起来，具有功能丰富、使用方便、内容清晰等优点。"
    }

    MessageDialog {
        id: completeFindDialog
        title: "提示"
        text: "查找完毕"
        standardButtons: StandardButton.Yes
        onYes: {
            close()
        }
        onNo: {
            close()
        }

        visible: false
    }

    FileDialog {
        id: openfileDialog //打开部分
        title: "选择需要打开的文件"
        selectExisting: true
        nameFilters: [" files (*.md )", "All files (*)"]
        onAccepted: {
            if (fileOpened) {
                //打开：已有文件打开
                clearTextArea()
                window.filepath = ""
                window.filename = ""
            } else {
                fileOpened = true
            }
            var filename = openfileDialog.fileUrl
            filerwritterid.m_fileName = filename
            var filedata = filerwritterid.readFile()
            textareaid.text = filedata
            window.filepath = filename
            //var tmp=window.filepath.lastIndexOf('/');
            window.filename = filepath.substr((filepath.lastIndexOf('/') + 1))
            changevisited(filename)
            //window.visited1=filename;
            textareaid.saved = false
            console.error('data', filedata)
        }
        onRejected: {

        } //do nothing
    }

    FileDialog {
        id: fileDialog //新建部分的保存路径
        title: "选择保存路径"
        selectExisting: false

        nameFilters: [" files (*.md )", "All files (*)"]
        onAccepted: {
            if (fileOpened) {
                //新建：文件已经打开
                clearTextArea()
                window.filepath = ""
                window.filename = ""
            } else {
                fileOpened = true
            }
            var filename = fileDialog.fileUrl
            filerwritterid.m_fileName = filename
            filerwritterid.saveFile(textareaid.text)
            window.filepath = filename
            var tmp = window.filepath.lastIndexOf('/')
            window.filename = filepath.substr((filepath.lastIndexOf('/') + 1))
            changevisited(filename)
            //window.visited1=filename;
            textareaid.saved = false
        }
        onRejected: {

        } //do nothing
    }

    FileDialog {
        id: fileDialogsaveanother //另存为部分，前提：文件肯定被打开
        title: "选择保存路径"
        selectExisting: false

        nameFilters: [" files (*.md )", "All files (*)"]
        onAccepted: {
            var filename = fileDialogsaveanother.fileUrl
            filerwritterid.m_fileName = filename
            filerwritterid.saveFile(textareaid.text)
            window.filepath = filename
            var tmp = window.filepath.lastIndexOf('/')
            window.filename = filepath.substr((filepath.lastIndexOf('/') + 1))
            changevisited(filename)
            //window.visited1=filename;
            textareaid.saved = false
        }
        onRejected: {

        } //do nothing
    }

    //FileDialog {
    //    id: fileDialogcreate
    //    title: "选择保存路径"
    //    selectExisting:false;

    //    nameFilters: [ " files (*.md )", "All files (*)" ]
    //    onAccepted: {
    //       var  filename = fileDialogcreate.fileUrl;
    //        filerwritterid.m_fileName = filename;
    //        filerwritterid.saveFile(messageDialog.texttmp);
    //        //window.filepath = filename;
    //    }

    //}

    //FileDialog {
    //    id: fileDialogcreatenew
    //    title: "选择保存路径"
    //    selectExisting:false;

    //    nameFilters: [ " files (*.md )", "All files (*)" ]
    //    onAccepted: {
    //       var  filename = fileDialogcreatenew.fileUrl;
    //        filerwritterid.m_fileName = filename;
    //        if(filerwritterid.saveFile(messageDialog.texttmp))
    //        {
    //            openfileDialog.open();
    //        }

    //        //window.filepath = filename;
    //    }

    //}
    Dialog {
        id: findtextdlg
        visible: false
        property int index: 0
        property bool casesensitve: false
        property bool upward: false

        contentItem: RowLayout {

            Layout.maximumWidth: 300
            Layout.maximumHeight: 100

            // anchors.fill: parent;
            ColumnLayout {

                RowLayout {
                    Label {
                        text: "查找内容"
                    }
                    TextField {
                        id: textfieldid
                        placeholderText: qsTr("输入要查找的内容")
                        onTextChanged: changeButtonState()
                    }
                }
                RowLayout {
                    CheckBox {
                        id: casecheckid
                        text: "区分大小写"
                        onCheckedChanged: changeCaseSensitiveState()
                    }
                    GroupBox {
                        title: "方向"

                        RowLayout {
                            ExclusiveGroup {
                                id: tabPositionGroup
                            }
                            RadioButton {
                                id: upbuttonid
                                text: "向上"
                                checked: false
                                exclusiveGroup: tabPositionGroup
                                onCheckedChanged: changeFindTextWard()
                            }
                            RadioButton {
                                id: donwbuttonid
                                text: "向下"
                                exclusiveGroup: tabPositionGroup
                                onCheckedChanged: changeFindTextWard()
                                checked: true
                            }
                        }
                    }
                }
            }
            ColumnLayout {
                Button {
                    id: findnextid
                    text: "查找下一个"
                    onClicked: findNextText()
                    enabled: false
                }
                Button {
                    id: cancelid
                    text: "取消"
                    onClicked: reject()
                }
            }
        }

        onVisibleChanged: closedlg()
        //standardButtons: StandardButton.Save | StandardButton.Cancel
    }

    function closedlg() {
        if (findtextdlg.visible == false) {
            reject()
        }
    }

    //TextArea
    //{
    //    property bool saved: false;
    //    id:textareaid;
    //    anchors.fill: parent;
    //    onCursorPositionChanged:  setStatusBarState();
    //    onTextChanged: saved=false;
    //   // verticalScrollBarPolicy:Qt.ScrollBarAlwaysOff

    //}
    FileRWritter {
        id: filerwritterid
        m_fileName: ""
    }
}

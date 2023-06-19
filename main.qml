import QtQuick 2.13
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import com.mytexteditor.filerwritter 1.0
import Qt.labs.folderlistmodel 2.1


ApplicationWindow {
    //title: qsTr("TextEditor")
    title: (filename=="")?"outliner5":filename+" -outliner5"
    width: 640
    height: 480
    visible: true
    id:mainwindowid;
    property string filepath: "";
    property string filename: "";

    //最近访问文件
    property string visited1: "";
    property bool clickvisited1: false
    property string visited2: "";
    property bool clickvisited2: false
    property string visited3: "";
    property bool clickvisited3: false
    property string visited4: "";
    property bool clickvisited4: false
    property string visited5: "";
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



    toolBar:ToolBar
    {
    RowLayout {
        ToolButton {
            text:"复制";
          //  iconSource: "image/1.png"
            onClicked: if(fileOpened){textareaid.copy();}
        }
        ToolButton {
            text:"粘贴"
              onClicked: if(fileOpened){textareaid.paste();}
        }
        ToolButton {
            text:"剪切";
              onClicked: if(fileOpened){textareaid.cut();}
        }
        ToolButton {
            text:"撤销";
              onClicked: if(fileOpened){textareaid.undo();}
        }
    }
}

menuBar: MenuBar {
    Menu {
        title: qsTr("文件(&F)")
        MenuItem {
            text: qsTr("新建")
            shortcut: "Ctrl+N"
            onTriggered:  //messageDialog.open();
                          if(fileOpened && textareaid.saved==false){//有文件打开但没有保存
                              messageDialog.open();
                              //fileDialog.open();
                              //clearTextArea();
                          }
                          else{fileDialog.open();}//有文件打开并且保存 和 没有文件打开

        }
        MenuItem {
            text: qsTr("打开")
            shortcut: "Ctrl+O"
            onTriggered: //messageDialogopen.open();
                         if(fileOpened && textareaid.saved == false){//文件打开但是没有保存
                             messageDialogopen.open();
                         }
                         else{//有文件打开并且保存 和 没有文件打开
                             openfileDialog.open();
                         }

        }

        MenuItem {
            text: qsTr("保存")
            shortcut: "Ctrl+S"
            onTriggered:   if(fileOpened){saveFile();}

        }
        MenuItem {
            text: qsTr("另存为")
            //shortcut: "Ctrl+A"
            onTriggered:   //if(fileOpened){fileDialog.open();}
                           if(fileOpened && textareaid.saved == false){messageDialogsaveanother.open();}//已有文件打开但是没有保存
                           else if(fileOpened && textareaid.saved){fileDialogsaveanother.open();}
        }
        Menu {
                                    title: qsTr("最近打开文件")
                                    MenuItem {
                                        text: qsTr(mainwindowid.visited1==""?"无":mainwindowid.visited1)
                                        onTriggered:
                                        {
                                            clickvisited1=true;
                                            if(textareaid.saved==false){messageDialogopenvisited.open();}
                                            else{openVisited();}
                                        }
                                    }
                                    MenuItem {
                                        text: qsTr(mainwindowid.visited2==""?"无":mainwindowid.visited2)
                                        onTriggered:
                                        {
                                            clickvisited2=true;
                                            if(textareaid.saved==false){messageDialogopenvisited.open();}
                                            else{openVisited();}
                                        }
                                    }
                                    MenuItem {
                                        text: qsTr(mainwindowid.visited3==""?"无":mainwindowid.visited3)
                                        onTriggered:
                                        {
                                            clickvisited3=true;
                                            if(textareaid.saved==false){messageDialogopenvisited.open();}
                                            else{openVisited();}
                                        }
                                    }
                                    MenuItem {
                                        text: qsTr(mainwindowid.visited4==""?"无":mainwindowid.visited4)
                                        onTriggered:
                                        {
                                            clickvisited4=true;
                                            if(textareaid.saved==false){messageDialogopenvisited.open();}
                                            else{openVisited();}
                                        }
                                    }
                                    MenuItem {
                                        text: qsTr(mainwindowid.visited5==""?"无":mainwindowid.visited5)
                                        onTriggered:
                                        {
                                            clickvisited5=true;
                                            if(textareaid.saved==false){messageDialogopenvisited.open();}
                                            else{openVisited();}
                                        }
                                    }
                                }
        MenuSeparator{}
        MenuItem {
            text: qsTr("关闭")
            shortcut: "Ctrl+Q"
            onTriggered: //Qt.quit();程序直接结束
                         if(fileOpened && textareaid.saved){
                             mainwindowid.filepath="";
                             mainwindowid.filename="";
                             textareaid.saved = false;
                             fileOpened=false;
                         }
                         else if(fileOpened){messageDialogclose.open();}

        }

    }
    Menu {
        title: qsTr("编辑(&E)")
        MenuItem {
            text: qsTr("撤销")
            shortcut: "Ctrl+Z"
            onTriggered: if(fileOpened){textareaid.undo();}

        }
        MenuSeparator{}
        MenuItem {
            text: qsTr("复制")
            shortcut: "Ctrl+C"
            onTriggered: if(fileOpened){textareaid.copy();}

        }
        MenuItem {
            text: qsTr("剪切")
             onTriggered: if(fileOpened){textareaid.cut();}
            shortcut: "Ctrl+X"
        }
        MenuItem {
            text: qsTr("粘贴")
            shortcut: "Ctrl+V"
             onTriggered: if(fileOpened){textareaid.paste();}
        }
    }
    Menu {
        title: qsTr("关于(&V)")
        MenuItem {
            text: qsTr("关于记事本")
            onTriggered: aboutapp();

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
    width: folderOpened?parent.width - folderTreeView.width:parent.width;
    height: parent.height
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    property bool saved: false;
    onTextChanged: saved=false;
    visible: fileOpened
}

function changevisited(currentfilename)
{
    var index=0;
    if(currentfilename===visited1) index=1;
    else if(currentfilename===visited2) index=2;
    else if(currentfilename===visited3) index=3;
    else if(currentfilename===visited4) index=4;
    else if(currentfilename===visited5) index=5;

    if(index==0||index==5)
    {
        mainwindowid.visited5=mainwindowid.visited4;
        mainwindowid.visited4=mainwindowid.visited3;
        mainwindowid.visited3=mainwindowid.visited2;
        mainwindowid.visited2=mainwindowid.visited1;
        mainwindowid.visited1=currentfilename;
    }
    else if(index==2)
    {
        mainwindowid.visited2=mainwindowid.visited1;
        mainwindowid.visited1=currentfilename;
    }
    else if(index==3)
    {
        mainwindowid.visited3=mainwindowid.visited2;
        mainwindowid.visited2=mainwindowid.visited1;
        mainwindowid.visited1=currentfilename;
    }
    else if(index==4)
    {
        mainwindowid.visited4=mainwindowid.visited3;
        mainwindowid.visited3=mainwindowid.visited2;
        mainwindowid.visited2=mainwindowid.visited1;
        mainwindowid.visited1=currentfilename;
    }



}
function openVisited(){
    var filename="";
    if(mainwindowid.clickvisited1==true) filename=mainwindowid.visited1;
    else if(mainwindowid.clickvisited2==true) filename=mainwindowid.visited2;
    else if(mainwindowid.clickvisited3==true) filename=mainwindowid.visited3;
    else if(mainwindowid.clickvisited4==true) filename=mainwindowid.visited4;
    else if(mainwindowid.clickvisited5==true) filename=mainwindowid.visited5;
    //var  filename = openfileDialog.fileUrl;
    filerwritterid.m_fileName = filename;
    var filedata = filerwritterid.readFile();
    textareaid.text = filedata;
    mainwindowid.filepath = filename;
    //var tmp=mainwindowid.filepath.lastIndexOf('/');
    mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
    changevisited(filename);
    //mainwindowid.visited1=filename;
    textareaid.saved=false;
    mainwindowid.clickvisited1=false;
    mainwindowid.clickvisited2=false;
    mainwindowid.clickvisited3=false;
    mainwindowid.clickvisited4=false;
    mainwindowid.clickvisited5=false;
}
function openFile()
{
    messageDialogopen.open();
}

function aboutapp()
{
   aboutappdialog.visible = true;
}

function clearTextArea()
{
  // TODO
    console.log("TODO");
}

function newFile()
{
  // if(textareaid.saved)
 //  {
    //    clearTextArea();
 //  }
  // else
    if(textareaid.saved==false)
    //&& textareaid.text.length > 0)
   {
       messageDialog.open();
   }
    else
    {
        clearTextArea();
        mainwindowid.filepath="";
        mainwindowid.filename="";
    }

 //  clearTextArea();
 //   mainwindowid.filepath="";
}

function saveFile()
{
   if(mainwindowid.filepath.length==0)//由于使用了fileOpened，所以这里可以省去
   {
       fileDialog.open();
   }
   else
   {
       filerwritterid.m_fileName = mainwindowid.filepath;
       filerwritterid.saveFile(textareaid.text);
   }
   textareaid.saved = true;

}

function saveanotherFile()
{
    fileDialogsaveanother.open();
}

MessageDialog {
    id: messageDialogopenvisited//打开最近文件的保存部分
    title: "提示"
    text: "是否需要保存当前文件？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {//保存已打开文件
        filerwritterid.m_fileName = mainwindowid.filepath;
        filerwritterid.saveFile(textareaid.text);
        textareaid.saved = true;
        //openfileDialog.open()
        openVisited();
//        var filename="";
//        if(mainwindowid.clickvisited1==true) filename=mainwindowid.visited1;
//        else if(mainwindowid.clickvisited2==true) filename=mainwindowid.visited2;
//        else if(mainwindowid.clickvisited3==true) filename=mainwindowid.visited3;
//        else if(mainwindowid.clickvisited4==true) filename=mainwindowid.visited4;
//        else if(mainwindowid.clickvisited5==true) filename=mainwindowid.visited5;
//        //var  filename = openfileDialog.fileUrl;
//        filerwritterid.m_fileName = filename;
//        var filedata = filerwritterid.readFile();
//        textareaid.text = filedata;
//        mainwindowid.filepath = filename;
//        //var tmp=mainwindowid.filepath.lastIndexOf('/');
//        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
//        changevisited(filename);
//        //mainwindowid.visited1=filename;
//        textareaid.saved=false;
//        mainwindowid.clickvisited1=false;
//        mainwindowid.clickvisited2=false;
//        mainwindowid.clickvisited3=false;
//        mainwindowid.clickvisited4=false;
//        mainwindowid.clickvisited5=false;
    }
    onNo:
    {
        //openfileDialog.open()
        openVisited();
//        var filename="";
//        if(mainwindowid.clickvisited1==true) filename=mainwindowid.visited1;
//        else if(mainwindowid.clickvisited2==true) filename=mainwindowid.visited2;
//        else if(mainwindowid.clickvisited3==true) filename=mainwindowid.visited3;
//        else if(mainwindowid.clickvisited4==true) filename=mainwindowid.visited4;
//        else if(mainwindowid.clickvisited5==true) filename=mainwindowid.visited5;
//        //var  filename = openfileDialog.fileUrl;
//        filerwritterid.m_fileName = filename;
//        var filedata = filerwritterid.readFile();
//        textareaid.text = filedata;
//        mainwindowid.filepath = filename;
//        //var tmp=mainwindowid.filepath.lastIndexOf('/');
//        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
//        changevisited(filename);
//        //mainwindowid.visited1=filename;
//        textareaid.saved=false;
//        mainwindowid.clickvisited1=false;
//        mainwindowid.clickvisited2=false;
//        mainwindowid.clickvisited3=false;
//        mainwindowid.clickvisited4=false;
//        mainwindowid.clickvisited5=false;
    }
    onRejected:
    {
        mainwindowid.clickvisited1=false;
        mainwindowid.clickvisited2=false;
        mainwindowid.clickvisited3=false;
        mainwindowid.clickvisited4=false;
        mainwindowid.clickvisited5=false;
    }



   visible: false;
}

MessageDialog {
    id: messageDialogopen//保存部分
    title: "提示"
    text: "是否需要保存当前文件？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {//保存已打开文件
        filerwritterid.m_fileName = mainwindowid.filepath;
        filerwritterid.saveFile(textareaid.text);
        textareaid.saved = true;
        openfileDialog.open()
    }
    onNo:
    {
        openfileDialog.open()
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;
}

MessageDialog {
    id: messageDialogsaveanother
    title: "提示"
    text: "是否需要保存当前文件？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {
            filerwritterid.m_fileName = mainwindowid.filepath;
            filerwritterid.saveFile(textareaid.text);
            textareaid.saved = true;
            fileDialogsaveanother.open()
        }
    onNo:
    {
        fileDialogsaveanother.open()
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;

}

MessageDialog {
    id: messageDialogclose
    title: "提示"
    text: "是否需要保存当前文件？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {
            filerwritterid.m_fileName = mainwindowid.filepath;
            filerwritterid.saveFile(textareaid.text);
            textareaid.saved = true;
            mainwindowid.filepath="";
            mainwindowid.filename="";
            textareaid.saved = false;
            fileOpened=false;
        }
    onNo:
    {
        mainwindowid.filepath="";
        mainwindowid.filename="";
        textareaid.saved = false;
        fileOpened=false;
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;

}

MessageDialog {
    id: messageDialog//新建：有文件打开但没有保存
    title: "提示"
    text: "是否需要保存当前文件？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {
        filerwritterid.m_fileName = mainwindowid.filepath;
        filerwritterid.saveFile(textareaid.text);
        textareaid.saved = true;
        fileDialog.open();

    }
    onNo:
    {
        fileDialog.open();
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;

}

MessageDialog{
    id:aboutappdialog
    title: "关于outliner5"
    text:"outliner5是一款本地Markdown笔记软件，在支持对Markdown语法处理的同时将支持笔记大纲的分级处理与折叠显示。该软件系统将市面上常见的笔记管理软件与Markdown编辑器结合起来，具有功能丰富、使用方便、内容清晰等优点。"
}

FileDialog {
    id: openfileDialog//打开部分
    title: "选择需要打开的文件"
    selectExisting:true;
    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
        if(fileOpened){//打开：已有文件打开
            clearTextArea();
            mainwindowid.filepath="";
            mainwindowid.filename="";
        }
        else{fileOpened=true;}
        var  filename = openfileDialog.fileUrl;
        filerwritterid.m_fileName = filename;
        var filedata = filerwritterid.readFile();
        textareaid.text = filedata;
        mainwindowid.filepath = filename;
        //var tmp=mainwindowid.filepath.lastIndexOf('/');
        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
        changevisited(filename);
        //mainwindowid.visited1=filename;
        textareaid.saved=false;
    }
    onRejected: {}//do nothing
}

FileDialog {
    id: fileDialog//新建部分的保存路径
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
        if(fileOpened){//新建：文件已经打开
            clearTextArea();
            mainwindowid.filepath="";
            mainwindowid.filename="";
        }
        else{fileOpened=true;}
        var  filename = fileDialog.fileUrl;
        filerwritterid.m_fileName = filename;
        filerwritterid.saveFile(textareaid.text);
        mainwindowid.filepath = filename;
        var tmp=mainwindowid.filepath.lastIndexOf('/');
        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
        changevisited(filename);
        //mainwindowid.visited1=filename;
        textareaid.saved=false;
    }
    onRejected: {}//do nothing
}

FileDialog {
    id: fileDialogsaveanother//另存为部分，前提：文件肯定被打开
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
        var  filename = fileDialogsaveanother.fileUrl;
        filerwritterid.m_fileName = filename;
        filerwritterid.saveFile(textareaid.text);
        mainwindowid.filepath = filename;
        var tmp=mainwindowid.filepath.lastIndexOf('/');
        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
        changevisited(filename);
        //mainwindowid.visited1=filename;
        textareaid.saved=false;
    }
    onRejected: {}//do nothing
}

FileRWritter
{
    id:filerwritterid;
    m_fileName: "";
}


}


/*import QtQuick 2.13
import QtQuick.Window 2.13
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
ApplicationWindow {
    id: outliner5
    width: 640
    height: 480
    visible: true
    flags: Qt.Window
    title: qsTr("Outliner5")*/

    /*Button {
        text: "新建"
    }*/
   /* menuBar: MenuBar {
        Menu{
            id: menu
            y: fileButton.height
            title: "文件(File)"
            MenuItem{
                text: "新建(New...)"
            }
            MenuItem{
                text: "打开(Open...)"
                onTriggered:
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
        /*Menu {
            title: qsTr("&文件(File)")
            Action { text: qsTr("&新建(New...)")}
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

    }*/
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
 /*   ScrollView {
        id: view
        anchors.fill: parent

        TextArea {
            text: ""
        }
    }




}*/




import QtQuick 2.13
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.2;
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.3
import com.mytexteditor.filerwritter 1.0



ApplicationWindow {
    //title: qsTr("TextEditor")
    title: (filename=="")?"untitled file -outliner5":filename+" -outliner5"
    width: 640
    height: 480
    visible: true
    id:mainwindowid;
    property string filepath: "";
    property string filename: "";




    toolBar:ToolBar
    {
    RowLayout {
        ToolButton {
            text:"复制";
          //  iconSource: "image/1.png"
            onClicked: textareaid.copy();
        }
        ToolButton {
            text:"粘贴"
              onClicked: textareaid.paste();
        }
        ToolButton {
            text:"剪切";
              onClicked: textareaid.cut();
        }
        ToolButton {
            text:"撤销";
              onClicked: textareaid.undo();
        }
        ToolButton {
           text:"字体颜色"
           onClicked: colorDialog.open();
        }

    }
}

menuBar: MenuBar {
    Menu {
        title: qsTr("文件(&F)")
        MenuItem {
            text: qsTr("新建")
            shortcut: "Ctrl+N"
            onTriggered:  messageDialog.open();

        }
        MenuItem {
            text: qsTr("打开")
            shortcut: "Ctrl+O"
            onTriggered: messageDialogopen.open();
        }
        MenuItem {
            text: qsTr("保存")
            shortcut: "Ctrl+S"
            onTriggered:   saveFile();
        }
        MenuItem {
            text: qsTr("另存为")
            shortcut: "Ctrl+A"
            onTriggered:   fileDialog.open();
        }
        MenuSeparator{}
        MenuItem {
            text: qsTr("退出")
            shortcut: "Ctrl+Q"
            onTriggered: Qt.quit();

        }

    }
    Menu {
        title: qsTr("编辑(&E)")
        MenuItem {
            text: qsTr("撤销")
            shortcut: "Ctrl+Z"
            onTriggered: textareaid.undo();

        }
        MenuSeparator{}
        MenuItem {
            text: qsTr("复制")
            shortcut: "Ctrl+C"
            onTriggered: textareaid.copy();

        }
        MenuItem {
            text: qsTr("剪切")
             onTriggered: textareaid.cut();
            shortcut: "Ctrl+X"
        }
        MenuItem {
            text: qsTr("粘贴")
            shortcut: "Ctrl+V"
             onTriggered: textareaid.paste();
        }
        MenuItem {
            text: qsTr("删除")
            shortcut: "Del"
             onTriggered: textareaid.remove(textareaid.selectionStart,textareaid.selectionEnd);
        }


        MenuSeparator{}
        MenuItem {
            text: qsTr("查找")
            shortcut: "Ctrl+F"
            onTriggered:findtextdlg.visible = true;
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
        MenuSeparator{}
        MenuItem {
            text: qsTr("全选")
            shortcut: "Ctrl+A";
            onTriggered: textareaid.selectAll();

        }
        MenuItem {
            text: qsTr("日期/时间")
            onTriggered: textareaid.insert(textareaid.cursorPosition,Qt.formatDateTime(new Date(), "dddd yyyy-MM-dd MMM hh-mm-ss"))
            // shortcut: "Ctrl+X"
        }

    }
    Menu {
        title: qsTr("格式(&O)")
        MenuItem {
            id:autoReturnMenuid;
            text: qsTr("自动换行")
            //shortcut: "Ctrl+Z"
            checkable: true;
            onTriggered:  setStatusBarState();

        }

        MenuItem {
            text: qsTr("字体")
            //shortcut: "Ctrl+C"
             onTriggered: fontDialog.open();

        }
    }
    Menu {
        title: qsTr("查看(&V)")
        MenuItem {
            id:showStatusBarMenuid;
            text: qsTr("状态栏")
            //shortcut: "Ctrl+Z"
            checkable: true;
            onTriggered:  setStatusBarState();

        }


    }
    Menu {
        title: qsTr("关于(&V)")
        MenuItem {
            text: qsTr("关于记事本")
            onTriggered: aboutapp();

        }


    }
}

statusBar: StatusBar {
    id:statusbarid;
    visible: false;
        RowLayout {
          //  anchors.fill: parent
        Label {
        text: ""
        id:statuslabel;
    }
        Rectangle
        {
            width: 100;
            height: parent.height;
            color: "red";
        }
            Label {
            text: "555"
            id:positionlabel;
        }
        }
    }



function openFile()
{
    messageDialogopen.open()
}

function aboutapp()
{
   aboutappdialog.visible = true;
}

function setTextColor()
{
   textareaid.textColor = colorDialog.color;
}

function setStatusBarState()
{
   positionlabel.text = textareaid.cursorPosition;
   if(autoReturnMenuid.checked)
    {
        statusbarid.visible = false;
        showStatusBarMenuid.enabled=false;
    }
   else
   {
       showStatusBarMenuid.enabled=true;
       if(showStatusBarMenuid.checked)
       {
           statusbarid.visible = true;
       }
       else
       {
           statusbarid.visible = false;
       }
   }
}

function setTextFont()
{
    textareaid.font = fontDialog.font;
}

function clearTextArea()
{
  textareaid.selectAll();
     textareaid.remove(0,textareaid.cursorPosition);
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
   if(mainwindowid.filepath.length==0)
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

function changeCaseSensitiveState()
{
   if(casecheckid.checked)
   {
       findtextdlg.casesensitve = true;
   }
   else
   {
       findtextdlg.casesensitve = false;
   }
}

function changeFindTextWard()
{
    if(upbuttonid.checked)
    {
        findtextdlg.upward = true;
    }
    else if(donwbuttonid.checked)
    {
        findtextdlg.upward = false;
    }
}

function findNextText()
{
   if( findtextdlg.index === -1 || textareaid.text.length == 0)
   {
       return;
   }

   var start_index = 0;
   if(findtextdlg.index > 0)
   {
       start_index = findtextdlg.index+textfieldid.text.length;
       if(findtextdlg.upward)
       {
           start_index = findtextdlg.index;
       }
   }
   else if(findtextdlg.upward  )
   {
       start_index = textareaid.text.length;

   }
   console.log("startindex :"+start_index)

   var contentstr;
   var findText ;
   if(findtextdlg.casesensitve == true)
   {
       contentstr = textareaid.text.substring(start_index);
       if(findtextdlg.upward)
       {
            contentstr = textareaid.text.substring(0,start_index).trim();
       }
       findText = textfieldid.text;
   }
   else
   {
       contentstr = textareaid.text.substring(start_index).toLowerCase();
       if(findtextdlg.upward)
       {
            contentstr = textareaid.text.substring(0,start_index).toLowerCase().trim();
       }
       findText = textfieldid.text.toLowerCase();
   }
   console.log("contentstr :"+contentstr)
   if(contentstr.length == 0)
   {
       return;
   }


   var index = contentstr.indexOf(findText);
   if(findtextdlg.upward)
   {
       index = contentstr.lastIndexOf(findText);
   }
   console.log("index :"+index)

   if(index < 0 )
   {
       completeFindDialog.open();
       findtextdlg.index = -1;
       return;
   }

   var old_index = findtextdlg.index;
   var select_start = old_index+index+textfieldid.text.length;
   var select_end = textfieldid.text.length+old_index+textfieldid.text.length+index;
   if(old_index == 0)
   {
       select_start = old_index+index;
       select_end = old_index+textfieldid.text.length+index;

   }
   else if(findtextdlg.upward)
   {
       select_start = index;
       select_end = textfieldid.text.length+index;
   }
   console.log("select_start :"+select_start)
   console.log("select_end :"+select_end)

   textareaid.select(select_start,select_end);
   findtextdlg.index = old_index+index+textfieldid.text.length;
   if(findtextdlg.upward)
   {
       findtextdlg.index = index;
   }
    console.log("findtextdlg.index :"+findtextdlg.index)
   if((findtextdlg.upward && index === 0))
   {
       completeFindDialog.open();
       findtextdlg.index = -1;
       return;
   }
}

function changeButtonState()
{
    if(textfieldid.text.length != 0)
    {
        findnextid.enabled=true;
    }
    else
    {
        findnextid.enabled=false;
    }
}

function reject()
{
    findtextdlg.index= 0;
    findtextdlg.casesensitve =false;
     findtextdlg.upward= false;
    findtextdlg.close();
    casecheckid.checked = false;
    upbuttonid.checked = false;
    donwbuttonid.checked = true;
    textfieldid.text = "";


    console.log("close dialog")
}



ColorDialog {
    id: colorDialog
    title: "Please choose a color"
    onAccepted: {
        setTextColor();
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
    font: Qt.font({ family: "Arial", pointSize: 24, weight: Font.Normal })
    onAccepted: {
        setTextFont();
    }
    onRejected: {
        console.log("Canceled")
      //  Qt.quit()
    }

}

MessageDialog {
    id: messageDialogopen
    title: "提示"
    text: "是否需要保存？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {
          //saveFile();
        if(mainwindowid.filepath.length==0)
        {
            texttmp=textareaid.text
            fileDialogcreatenew.open();

        }
        else
        {
            filerwritterid.m_fileName = mainwindowid.filepath;
            filerwritterid.saveFile(textareaid.text);
            openfileDialog.open()
        }
        textareaid.saved = true;
        //openfileDialog.open();
    }
    onNo:
    {
        textareaid.saved = true;
        openfileDialog.open()
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;

}


FileDialog {
    id: openfileDialog
    title: "选择需要打开的文件"
      selectExisting:true;
    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
       var  filename = openfileDialog.fileUrl;
        filerwritterid.m_fileName = filename;

        var filedata = filerwritterid.readFile();
        textareaid.text = filedata;
        mainwindowid.filepath = filename;
        var tmp=mainwindowid.filepath.lastIndexOf('/');
        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));
    }




}

FileDialog {
    id: fileDialog
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
       var  filename = fileDialog.fileUrl;
        filerwritterid.m_fileName = filename;
        filerwritterid.saveFile(textareaid.text);
        mainwindowid.filepath = filename;
        var tmp=mainwindowid.filepath.lastIndexOf('/');
        mainwindowid.filename=filepath.substr((filepath.lastIndexOf('/')+1));

    }


}

FileDialog {
    id: fileDialogsaveanother
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
       var  filename = fileDialogsaveanother.fileUrl;
        filerwritterid.m_fileName = filename;
        filerwritterid.saveFile(textareaid.text);
        //mainwindowid.filepath = filename;

    }
}

FileDialog {
    id: fileDialogcreate
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
       var  filename = fileDialogcreate.fileUrl;
        filerwritterid.m_fileName = filename;
        filerwritterid.saveFile(messageDialog.texttmp);
        //mainwindowid.filepath = filename;
    }

}

FileDialog {
    id: fileDialogcreatenew
    title: "选择保存路径"
    selectExisting:false;

    nameFilters: [ " files (*.md )", "All files (*)" ]
    onAccepted: {
       var  filename = fileDialogcreatenew.fileUrl;
        filerwritterid.m_fileName = filename;
        if(filerwritterid.saveFile(messageDialog.texttmp))
        {
            openfileDialog.open();
        }

        //mainwindowid.filepath = filename;
    }

}

MessageDialog {
    id: messageDialog
    title: "提示"
    text: "是否需要保存？"
    property string texttmp: ""
    standardButtons:StandardButton.Yes|StandardButton.No|StandardButton.Cancel
    onYes:  {
          //saveFile();
        if(mainwindowid.filepath.length==0)
        {
            texttmp=textareaid.text
            fileDialogcreate.open();

        }
        else
        {
            filerwritterid.m_fileName = mainwindowid.filepath;
            filerwritterid.saveFile(textareaid.text);
        }
        textareaid.saved = true;
        clearTextArea();
        mainwindowid.filepath="";
        mainwindowid.filename="";

    }
    onNo:
    {
        textareaid.saved = true;
        newFile();
        clearTextArea();
        mainwindowid.filepath="";
        mainwindowid.filename="";
    }
 //   Cancel:
 //   {
 //       visible: false;
 //   }

   visible: false;

}

MessageDialog{
    id:aboutappdialog
    title: "关于程序"
    text:"该程序主要实现简单的记事本功能，写该程序的目的是为了解qml的用法"
}

MessageDialog {
    id: completeFindDialog
    title: "提示"
    text: "查找完毕"
    standardButtons:StandardButton.Yes
    onYes:  {
        close()
    }
    onNo:
    {
     close()
    }

   visible: false;
}

Dialog
{
    id:findtextdlg
    visible: false;
    property int index: 0;
    property bool casesensitve :false;
    property bool upward: false;

contentItem:
    RowLayout
    {

        Layout.maximumWidth:    300;
       Layout.maximumHeight:  100;
        // anchors.fill: parent;

    ColumnLayout
    {

        RowLayout
        {
            Label {
                text: "查找内容"
            }
            TextField
            {
                id:textfieldid;
                placeholderText: qsTr("输入要查找的内容");
                onTextChanged: changeButtonState();
            }

        }
        RowLayout
        {
            CheckBox
            {
                id:casecheckid;
                text:"区分大小写"
                onCheckedChanged: changeCaseSensitiveState();
            }
            GroupBox {
                title: "方向"

                RowLayout {
                    ExclusiveGroup { id: tabPositionGroup }
                    RadioButton {
                        id:upbuttonid;
                        text: "向上"
                        checked: false
                        exclusiveGroup: tabPositionGroup
                        onCheckedChanged: changeFindTextWard();


                    }
                    RadioButton {
                        id:donwbuttonid;
                        text: "向下"
                        exclusiveGroup: tabPositionGroup
                        onCheckedChanged: changeFindTextWard();
                        checked: true;
                    }
                }
            }



        }

    }
    ColumnLayout
    {
        Button
        {
            id:findnextid;
            text:"查找下一个"
            onClicked:  findNextText();
            enabled: false;
        }
        Button
        {
            id:cancelid;
            text:"取消"
            onClicked: reject();
        }
    }
    }


   onVisibleChanged:    closedlg();
 //standardButtons: StandardButton.Save | StandardButton.Cancel


}

function  closedlg()
{
   if(findtextdlg.visible == false)
   {
       reject();
   }

}

TextArea
{
    property bool saved: false;
    id:textareaid;
    anchors.fill: parent;
    onCursorPositionChanged:  setStatusBarState();
    onTextChanged: saved=false;
   // verticalScrollBarPolicy:Qt.ScrollBarAlwaysOff

}

FileRWritter
{
    id:filerwritterid;
    m_fileName: "";
}


}


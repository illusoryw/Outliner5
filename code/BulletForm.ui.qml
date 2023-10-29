import QtQuick 2.4

Item {
    id: item1
    width: 400
    height: 30

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 30
        height: 30
        color: "#ffffff"
    }

    TextEdit {
        id: textEdit
        y: 0
        width: 364
        height: 30
        text: qsTr("Text Edit")
        anchors.left: rectangle.right
        font.pixelSize: 12
        anchors.leftMargin: 3
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:8}D{i:2}
}
##^##*/

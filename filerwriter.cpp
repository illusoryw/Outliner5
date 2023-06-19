#include "filerwriter.h"
#include <QByteArray>
#include<QString>
#include <QtWidgets/QMessageBox>
#include <stdio.h>

FileRWritter::FileRWritter(QObject *parent):QObject(parent)
{
    //  if(filename.isEmpty())
    //  {
    //      return;
    //  }
    // m_fileName = filename;  QString filename ,
}

bool FileRWritter::saveFile(QString filedata)
{
    //if(filedata.isEmpty())
    //{
    //    return;
    //}
    //  int index = m_fileName.lastIndexOf(":");
    QString filePath =m_fileName.right(m_fileName.length() - 8);
    QFile file(filePath);
    if(file.exists())
    {
        file.remove();
    }

    if(!file.open(QIODevice::ReadWrite))
    {
        //QMessageBox::information(NULL,"提示","文件打开失败"+filePath);
        return false;
    }
    int length = file.write(filedata.toStdString().data());
    if(length != filedata.length())
    {
        //QMessageBox::information(NULL,"提示","保存失败");
    }
    file.close();
    return true;
}

QString FileRWritter::readFile()
{
    QString filePath =m_fileName.right(m_fileName.length() - 8);
    QFile file(filePath);

    if(!file.open(QIODevice::ReadWrite))
    {
       //QMessageBox::information(NULL,"提示","文件打开失败"+filePath);
        return "";
    }
    QByteArray filedata =  file.readAll();

    file.close();
    return filedata;
}


QString FileRWritter::getFileName()
{
    return m_fileName;
}

void FileRWritter::setFileName(QString filename)
{
    m_fileName = filename;
}

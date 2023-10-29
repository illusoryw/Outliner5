#ifndef FILERWRITER_H
#define FILERWRITER_H

//#endif // FILERWRITER_H

#include <QQuickTextDocument>

#include <QtGui/QTextCharFormat>
#include <QtCore/QTextCodec>

#include <qqmlfile.h>
#include<QFile>


#include<QObject>
//该类主要实现文件的读写功能
class FileRWritter:public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString m_fileName READ getFileName WRITE setFileName)
public:
    FileRWritter(QObject *parent= NULL); //QString filename,
    // void saveFile(QString filedata);
    // QString readFile();
    Q_INVOKABLE  bool  saveFile(QString filedata);

    Q_INVOKABLE QString readFile();

    QString getFileName();
    void    setFileName(QString filename);


private:
    QString   m_fileName;
};

#endif // FILERWRITER

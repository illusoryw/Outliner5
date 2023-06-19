/*#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
*/
#include <QtWidgets/QApplication>
#include <QQmlApplicationEngine>
#include "filerwriter.h"
#include <QtQml>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    app.setOrganizationName("WHUCS-HY-SE5");
    app.setOrganizationDomain("cn.edu.whu.cs");

    QQmlApplicationEngine engine;
    qmlRegisterType<FileRWritter>("com.mytexteditor.filerwritter", 1, 0, "FileRWritter");
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

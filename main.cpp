#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonValue>
#include <QIcon>
#include <QAudioSink>
#include <QMediaDevices>

class CppAudioPlayer : public QObject
{
    Q_OBJECT

public slots:
    CppAudioPlayer* createInstance() {
        auto* result = new CppAudioPlayer;
        QQmlEngine::setObjectOwnership(result, QQmlEngine::CppOwnership);
        return result;
    }
    void playThenDestroySelf(const QString& file) {
        m_file.setFileName(file);
        m_file.open(QIODevice::ReadOnly);

        QAudioFormat format;
        format.setSampleFormat(QAudioFormat::Int16);
        format.setChannelCount(2);
        format.setSampleRate(44100);
        m_sink = new QAudioSink{QMediaDevices::defaultAudioOutput(), format, this};
        connect(m_sink, &QAudioSink::stateChanged, [this](QAudio::State state) {
            if(state == QAudio::State::IdleState || state == QAudio::State::StoppedState || state == QAudio::State::SuspendedState) {
                emit finished();
                this->deleteLater();
            }
        });
        m_sink->start(&m_file);
    }

signals:
    void finished();

private:
    QFile m_file;
    QAudioSink* m_sink;
};

int main(int argc, char *argv[])
{
    Q_INIT_RESOURCE(resources);

    QGuiApplication app(argc, argv);

    app.setWindowIcon(QIcon{":/assets/watabee.png"});
    app.setApplicationDisplayName("Wataboard");
    app.setApplicationName("Wataboard");

    QQmlApplicationEngine engine;

    QFile soundData{":/sounds.json"};
    if(soundData.open(QFile::ReadOnly)) {
        engine.globalObject().setProperty("loadedSounds", engine.toScriptValue(QJsonDocument::fromJson(soundData.readAll()).array()));
        engine.globalObject().setProperty("cppPlayer", engine.newQObject(new CppAudioPlayer{}));
#ifdef Q_OS_WASM
        engine.globalObject().setProperty("useCppPlayer", true);
#else
        engine.globalObject().setProperty("useCppPlayer", false);
#endif
    }

    const QUrl url(u"qrc:/watasounds/main.qml"_qs);
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl)
    {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    }, Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}

#include "main.moc"

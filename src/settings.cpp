/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include "settings.h"
#include <QtCore/QSettings>
#include <QDebug>
#include <QGuiApplication>

// Constants
const char *Organisation = "mjm";
const char *Application = "harbour-scocadigo";
const QString PrefsPath = QGuiApplication::applicationDirPath() + "harbour-scocadigo/scocadigo";


/*!
  \class Settings
  \brief This class loads and stores settings used by client application.
*/


/*!
  Constructor.
*/
Settings::Settings(QObject *parent)
    : QObject(parent)
{
}


/*!
  Copy constructor.
  Not used.
*/
Settings::Settings(const Settings &settings)
    : QObject(0)
{
    Q_UNUSED(settings)
}


/*!
  Stores the setting as a key value pair.
*/
void Settings::setSetting(const QString &setting, const QVariant &value)
{
    QSettings settings(PrefsPath);
    settings.setValue(setting, value);
    //qDebug() << "changed setting: " << setting << "to value: " << value;
    emit settingChanged(setting, value);
}


/*!
  Loads the setting by key. Returns value or the default value if no setting is found.
*/
QVariant Settings::setting(const QString &setting, const QVariant &defaultValue)
{
    QSettings settings(PrefsPath);
    //qDebug() << "returning settings value: " << settings.value(setting);
    return settings.value(setting, defaultValue);
}

/*!
  Loads the setting by key. Returns value.
*/
QVariant Settings::setting(const QString &setting)
{
    QSettings settings(PrefsPath);
    //qDebug() << "returning settings value: " << settings.value(setting);
    return settings.value(setting);
}


/*!
  Removes the setting by key. Returns true, if setting removed
  successfully. Otherwise false.
*/
bool Settings::removeSetting(const QString &setting)
{
    QSettings settings(PrefsPath);
    if (!settings.contains(setting)) {
        return false;
    }

    settings.remove(setting);
    return true;
}


/*!
  Removes all settings.
*/
void Settings::clear()
{
    QSettings settings(PrefsPath);
    settings.clear();
}


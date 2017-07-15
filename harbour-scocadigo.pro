# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-scocadigo

CONFIG += sailfishapp

SOURCES += \
    src/harbour-scocadigo.cpp \
    src/settings.cpp

OTHER_FILES += qml/harbour-scocadigo.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-scocadigo.spec \
    rpm/harbour-scocadigo.yaml \
    translations/*.ts \
    harbour-scocadigo.desktop


SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256




# to disable building translations every time, comment out the
# following CONFIG line



# Translations
CONFIG += sailfishapp_i18n




TRANSLATIONS += translations/harbour-scocadigo-sv.ts

TRANSLATIONS +=  translations/harbour-scocadigo-fi.ts

TRANSLATIONS +=  translations/harbour-scocadigo.ts

DISTFILES += \
    qml/pages/Buttons.qml \
    qml/pages/Database.js \
    qml/pages/newcoursebutton.png \
    qml/pages/newgamebutton.png \
    qml/pages/newgameIcon.png \
    qml/pages/newplayerbutton.png \
    qml/pages/settingsbutton.png \
    qml/pages/statisticsbutton.png \
    qml/pages/bebasNeue Regular.otf \
    qml/pages/Courses.qml \
    qml/pages/NewCourses.qml \
    qml/pages/DefinePar.qml \
    qml/pages/bebasNeue Regular.otf \
    qml/pages/fontawesome-webfont.ttf \
    qml/pages/courseicon.png \
    qml/pages/flattr.png \
    qml/pages/harbour-scocadigo.png \
    qml/pages/playersicon.png \
    qml/pages/statisticsicon.png \
    qml/pages/About.qml \
    qml/pages/Banner.qml \
    qml/pages/EditPlayers.qml \
    qml/pages/NewGame.qml \
    qml/pages/NewGameCourses.qml \
    qml/pages/NewPlayer.qml \
    qml/pages/Players.qml \
    qml/pages/Round_Results.qml \
    qml/pages/Round_Scorecard.qml \
    qml/pages/Round.qml \
    qml/pages/Settings.qml \
    qml/pages/Statistics.qml \
    rpm/harbour-scocadigo.changes \
    qml/pages/CreatedScorecard.qml \
    translations/harbour-scocadigo-sv.ts
    #translations/harbour-scocadigo-de.ts

HEADERS += \
    src/settings.h


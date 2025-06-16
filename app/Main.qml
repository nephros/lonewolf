import QtQuick 2.4
import Sailfish.Silica 1.0
//import Qt.labs.settings 1.0
//import Ubuntu.Components 1.3
import Lonewolf 1.0
import Nemo.Configuration 1.0

ApplicationWindow {
    id: mainView
    objectName: "mainView"
    //applicationName: "lonewolf.timsueberkrueb"
    // SFOS: TODO: restore twocolumn layout
    allowedOrientations: Orientation.PortraitMask

    ConfigurationGroup {
        id: settings
        path: "/apps/games/lonewolf"
    }

    ConfigurationGroup {
        id: uisettings
        scope: settings
        path: "ui"
        property int font: 2
        property bool saveOnQuit: false
        property bool styleHtml: true
        property bool autoTts: false
    }

    GameState {
        path: "quicksave"
        id: quickSaveState
    }

    GameState {
        path: "current"
        id: gameState
    }

    /* detect closing of app*/
    signal willQuit()
    Connections { target: __quickWindow; onClosing: willQuit() }
    // AND/OR
    Connections { target: Qt.application; onAboutToQuit: willQuit() }
    onWillQuit: {
        if (_willquitHandled) return
        if (uisettings.saveOnQuit) {
             gameState.copyTo(quickSaveState);
        }
        _willquitHandled=true
    }
    property bool _willquitHandled: false

    initialPage: menuPage
    cover: coverPage

    function goToBookTab() {
      mainView.bookTitle = menuPage.getTitle()
      pageStack.replaceAbove(null, bookComponent)
    }
    function popBookTab() {
      pageStack.replaceAbove(null, menuPage)
    }
    function loadQuickSave()
    {
        quickSaveState.copyTo(gameState);
        goToBookTab();
    }

    MenuPage {
        id: menuPage
    }

    BookPage {
        id: bookComponent
        you: gameState
    }

    property alias tts: ttsplugin.item
    property bool ttsSpeaking
    property bool ttsAvailable: false
    onTtsSpeakingChanged: { console.info("Text-to-speech has" + (ttsSpeaking ? " begun " : " stopped " ) + "speaking.") }
    function ttsPlay(text) { if (!ttsAvailable) return; tts.play(text); console.debug("TTS: Requested to read", text.split(/\s/).length, "words.") }
    function ttsStop() { if (!ttsAvailable) return; tts.stop(); console.debug("TTS: Requested to stop")}
    Connections {
        target: ttsplugin.item
        onSpeakingChanged: { mainView.ttsSpeaking = ttsplugin.item.speaking }
    }
    Loader { id: ttsplugin
        // start this late, so startup performance is better
        active: false
        source: Qt.resolvedUrl("TTS.qml")
        onLoaded: {
            mainView.ttsAvailable = true
            console.info("Text-to-speech plugin found.")
        }
    }

    Component.onCompleted: {
        // start this late, so startup performance is better
        ttsplugin.active = true
    }

    CoverBackground { id: coverPage
      Image {
          source: "./lonewolf-bighead.png"
          z: -1
          anchors.fill: parent
          fillMode: Image.PreserveAspectFit
      }
      SectionHeader { text: mainView.bookTitle
          horizontalAlignment: Text.AlignHCenter
          anchors.horizontalCenter: parent.horizontalCenter
          anchors.top: parent.top; anchors.topMargin: Theme.paddingLarge
          font.pixelSize: Theme.fontSizeLarge
          wrapMode: Text.Wrap
      }
      SectionHeader { text: mainView.endurance + "/" + mainView.maxendurance + "EP"
          horizontalAlignment: Text.AlignHCenter
          visible: mainView.endurance > 0
          anchors.bottom: parent.bottom; anchors.bottomMargin: Theme.paddingLarge
          color: Theme.secondaryColor
      }
    }

    property bool nightModeEnabled: false
    property string bookTitle: "Lone Wolf"
    readonly property int endurance: inneworder ? gameState.neworder_endurance : gameState.endurance
    readonly property int maxendurance: inneworder ? gameState.neworder_maxendurance : gameState.maxendurance
    readonly property int combatskill: inneworder ? gameState.neworder_combatskill : gameState.combatskill
    readonly property int gold: inneworder ? gameState.neworder_gold : gameState.gold
    readonly property int meals: inneworder ? gameState.neworder_meals : gameState.meals
    readonly property int quiver: inneworder ? gameState.neworder_quiver : gameState.quiver

    function adjustEndurance(amount) {
        if (inneworder) {
            gameState.neworder_endurance += amount;
        } else {
            gameState.endurance += amount;
        }
    }

    function adjustGold(amount) {
        if (inneworder) {
            gameState.neworder_gold += amount;
        } else {
            gameState.gold += amount;
        }
    }

    function adjustProperty(prop, amount) {
        if (inneworder) {
            gameState["neworder_" + prop] += amount;
        } else {
            gameState[prop] += amount;
        }
    }

    readonly property bool inkai: gameState.book == "" ||
                                  gameState.book == "01fftd" ||
                                  gameState.book == "02fotw" ||
                                  gameState.book == "03tcok" ||
                                  gameState.book == "04tcod" ||
                                  gameState.book == "05sots"
    readonly property bool inmagnakai: gameState.book == "06tkot" ||
                                       gameState.book == "07cd" ||
                                       gameState.book == "08tjoh" ||
                                       gameState.book == "09tcof" ||
                                       gameState.book == "10tdot" ||
                                       gameState.book == "11tpot" ||
                                       gameState.book == "12tmod"
    readonly property bool ingrandmaster: gameState.book == "13tplor" ||
                                          gameState.book == "14tcok" ||
                                          gameState.book == "15tdc" ||
                                          gameState.book == "16tlov" ||
                                          gameState.book == "17tdoi" ||
                                          gameState.book == "18dotd" ||
                                          gameState.book == "19wb" ||
                                          gameState.book == "20tcon"
    readonly property bool inneworder: gameState.book == "21votm" ||
                                       gameState.book == "22tbos" ||
                                       gameState.book == "23mh" ||
                                       gameState.book == "24rw" ||
                                       gameState.book == "25totw" ||
                                       gameState.book == "26tfobm" ||
                                       gameState.book == "27v" ||
                                       gameState.book == "28thos"
}

import QtQuick 2.4
import QtFeedback 5.0
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0

ApplicationWindow {
initialPage: WebViewPage {
    id: root
    readonly property string resourceDir: [
        StandardPaths.cache,
        "imagetest",
    ].join("/")
    readonly property string pageContent: '
        <html>
        <head>
        <!-- Things to try: -->
        <!-- meta http-equiv="Content-Security-Policy" content="img-src \'self\' *;" / -->
        <!-- If you set this to file:// + resourceDir, you will see CORS errors in Mozilla console -->
        <!-- base href="INSERT resourceDir path here" / -->
        <style> :-moz-suppressed { border: 2px dashed #ff0000; }</style>
        <style> :-moz-broken { border: 2px dashed #00ff00; }</style>
        <style> :-moz-user-disabled { border: 2px dashed #0000ff; }</style>
        <style> img { border: 1px solid #000000; }</style>
        </head>
        <body>
        <p>"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."</p>
        <img width="100%" src="test.png" />
        <p>"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."</p>
        </body>
        <html>
    '
    SilicaFlickable { id: flickable
        anchors.fill: parent
        contentHeight: testView.height

        PullDownMenu {
            busy: true
            MenuItem {
                text: "Load"
                onClicked: {
                    console.log("Loading page, setting base to:", Qt.resolvedUrl(root.resourceDir) + "/")
                    testView.loadHtml(root.pageContent, Qt.resolvedUrl(root.resourceDir) + "/")
                }
            }
        }
        WebView {
            id: testView
            anchors.fill: parent
            anchors.margins: Theme.horizontalPageMargin

            onRecvAsyncMessage: function(message, data) {
                console.log("Async Message: ", message, JSON.stringify(data));
            }
            Component.onCompleted: {
                WebEngine.onRecvObserve.connect(function(message, data) {
                    console.log("Engine event: ", message, JSON.stringify(data));
                })
                WebEngineSettings.pixelRatio = 3
                WebEngineSettings.autoLoadImages = true
                //WebEngineSettings.setPreference("permissions.default.image", 1, WebEngineSettings.IntPref)
                //WebEngineSettings.javascriptEnabled = true // <-- This apparently does not work, but the following does:
                //WebEngineSettings.setPreference("javascript.enabled", true, WebEngineSettings.BoolPref)

                WebEngineSettings.setPreference("security.fileuri.strict_origin_policy", false, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("security.disable_cors_checks", true, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("security.mixed_content.block_active_content", false, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("security.mixed_content.block_display_content", false, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("security.mixed_content.upgrade_display_content.image", false, WebEngineSettings.BoolPref)
                //WebEngineSettings.setPreference("privacy.file_unique_origin", false, WebEngineSettings.BoolPref)
            }
        }

    }
}
}

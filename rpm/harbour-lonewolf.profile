# -*- mode: sh -*-
#
# x-sailjail-translation-catalog = sailjail-permissions
# x-sailjail-description = Lonewolf TTS
# x-sailjail-long-description = Permission to talk to the DSNote TTS service


## PERMISSIONS
# x-sailjail-permission = Internet
# x-sailjail-permission = Audio
# x-sailjail-permission = WebView

include /etc/sailjail/permissions/Base.permission
include /etc/sailjail/permissions/Internet.permission
include /etc/sailjail/permissions/Audio.permission
include /etc/sailjail/permissions/WebView.permission

# Sessions
dbus-user.talk org.mkiol.Speech
# Signals
dbus-user.broadcast org.mkiol.Speech=org.mkiol.Speech.*@/
# Methods
dbus-user.call org.mkiol.Speech=org.mkiol.Speech.TtsPlaySpeech@/
dbus-user.call org.mkiol.Speech=org.mkiol.Speech.TtsPlaySpeech2@/
dbus-user.call org.mkiol.Speech=org.mkiol.Speech.TtsStopSpeech@/


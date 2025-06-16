rm -f $PWD/mozlog.moz_log
#       MOZ_LOG="all:2,nsComponentManager:0,imgRequest:5,ImageUtils:5,nsSSService:5,CSMLog:5,nsHtml:5,nsURILoader:5,URILoader:5" \
#MOZ_LOG="CSMLog:5,imgRequest:4,nsURILoader:5,URILoader:5" \
#MOZ_LOG="imgRequest:4,nsURILAoader:5,URILoader:5,nsCORSListenerProxy:5,nsCORSListener:5,CORSListener:5" \
env \
EMBED_CONSOLE=1 \
MOZ_LOG_FILE=$PWD/mozlog \
MOZ_LOG="CSMLog:5,imgRequest:5,nsURILoader:5,URILoader:5" \
qmlscene app/Main.qml

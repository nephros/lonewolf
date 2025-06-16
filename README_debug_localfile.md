## Showing the problem with local file loading:

1. Start the app "normally" (`qmlscene app/Main.qml`)
1. Start a book, (Book 1 is OK)
1. Accept the license, wait for the book data having been downloaded
1. Use the next buttons in the book intro part until you reach the "Equipment" page. This page contains several images of the weapons and things.
1. Close the app

Now, add any of your experimental changes.

e.g. it may be useful to add things like:

```
'<style> :-moz-suppressed { border: 2px dashed #ff0000; }</style>',
'<style> :-moz-broken { border: 2px dashed #00ff00; }</style>',
'<style> :-moz-user-disabled { border: 2px dashed #000000; }</style>',
```
and make sure something like `newcontent = newcontent.replace(/onerror=[^ ]+/g, '')` removes the dont-display-on-error css part for images.


look at `debug.sh and set the appropriate MOZ_LOG variables.

run `./debug.sh` and inspect the logs

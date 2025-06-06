# Lone Wolf

Lone Wolf is a role-playing book series from the 80s.

This is a fork of Lonewolf by [Tim Süberkrüb](https://github.com/timsueberkrueb), which is a fork of [Michael Terry](https://github.com/mikix)'s Lone Wolf app for Ubuntu Phone.

Lone Wolf for Sailfish OS is available for download from [Sailfish OS Chum](https://sailfishos-chum.github.io/apps/lonewolf/).

## Story

You are the sole survivor of a devastating attack on the monastery where you were learning the skills of the Kai Lords. You swear vengeance on the Darklords for the massacre of the Kai warriors, and with a sudden flash of insight you know what you must do. You must set off on a perilous journey to the capital city to warn the King of the terrible threat that faces his people: For you are now the last of the Kai. You are now Lone Wolf.

## Differences to upstream

 - Ported to Silica while trying to retain most of the logic and UI flow of the original where applicable.
 - Dropped two-column layout (see #3)
 - New feature: Text-to-Speech support (see #4) via [dsnote](https://github.com/mkiol/dsnote) by @mkiol
   - packaged separately as a "Plugin", so it can be installed as an additional option
 - New feature: Font configuration: 
   - if you use fontconfig to define an alias called `lone-wolf`, that will be the preferred font used.
   - if you happen to have the original (non-free) Souvenir, or ITC Souvenitr fonts installed, they will be used
   - otherwise, the shipped "AG Souvenir Regular" font will be used
   - styling can be turned off in the menu

See the issues section for planned and implemented features, and currently-known bugs.

## Credits

[Tim Süberkrüb](https://github.com/timsueberkrueb) for the port for Ubuntu Touch.
[Michael Terry](https://github.com/mikix) for creating the original version.

[Project Aon](https://www.projectaon.org/) for curating the original game material.

## Licensing

Licensed under the terms of the GNU General Public License version 3.

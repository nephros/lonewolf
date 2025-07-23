# Lone Wolf

Lone Wolf is a role-playing book series from the 80s.

This is a fork of Lonewolf by [Tim Süberkrüb](https://github.com/timsueberkrueb), which is a fork of [Michael Terry](https://github.com/mikix)'s Lone Wolf app for Ubuntu Phone.

## Story

You are the sole survivor of a devastating attack on the monastery where you were learning the skills of the Kai Lords. You swear vengeance on the Darklords for the massacre of the Kai warriors, and with a sudden flash of insight you know what you must do. You must set off on a perilous journey to the capital city to warn the King of the terrible threat that faces his people: For you are now the last of the Kai. You are now Lone Wolf.

## Differences of the Sailfish OS version to the original

 - Ported to Silica while trying to retain most of the logic and UI flow of the original.
 - Dropped two-column layout (see [#3](https://github.com/nephros/lonewolf/issues/3))
 - New feature: Text-to-Speech support (see [#4](https://github.com/nephros/lonewolf/issues/4)) via [dsnote](https://github.com/mkiol/dsnote) by @mkiol
   - packaged separately as a "Plugin", so it can be installed as an additional option.
   - the plugin is available for download from [Sailfish OS Chum](https://sailfishos-chum.github.io/apps/lonewolf/).
 - New feature: Font configuration:
   - The original books were printed using the "Souvenir" typeface. Since no freely distributable version of this font could be found ([suggestions welcome!]((https://github.com/nephros/lonewolf/issues/13)), we do not ship this. Instead we use the free font Alegreya.
   - Hovever, if you use fontconfig to define an alias called `lone-wolf`, that will be the preferred font used.
   - If you happen to have the original (non-free) Souvenir, ITC Souvenir, or AG Souvenir fonts installed, they will be used
   - Styling (overriding system fonts, and other things,) can be turned off in the menu

See the issues section for planned and implemented features, and currently-known bugs.

Example fontconfig file for setting up a font for the game:

This should be installed as e.g. `~/config/fontconfig/lone-wolf.conf`, and font files be placed in `~/.local/share/fonts`.
```
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>

<description>Custom family alias for the Lone Wolf books.</description>

<alias binding="strong">
    <family>lone-wolf</family>
    <prefer>
        <family>Philosopher</family>
        <family>Alegreya ht</family>
        <family>Rosario</family>
        <family>Linux Biolinum</family>
    </prefer>
</alias>
</fontconfig>
```

## Credits

[Tim Süberkrüb](https://github.com/timsueberkrueb) for the port for Ubuntu Touch.
[Michael Terry](https://github.com/mikix) for creating the original version.

[Project Aon](https://www.projectaon.org/) for curating the original game material.

## Licensing

Licensed under the terms of the GNU General Public License version 3.

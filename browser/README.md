# Browser
Browser settings / configs that cant be easily installed

## Firefox options

- `about:config` - Docs: [source](https://searchfox.org/firefox-main/source/modules/libpref/init/all.js), [mozillazine](https://kb.mozillazine.org/About:config_entries)
  - `browser.quitShortcut.disabled` - set to `true`, prevent closing firefox accidentally (restart is needed for the changes to take effect).
  - Download directory - i prefer my downloads folder to not start with an uppercase letter
    - `browser.download.folderList` - set to `1`. This tells firefox to use the system downloads directory (should be the default).
    - `~/.config/user-dirs.dirs` - change the download path here to `$HOME/downloads`
  - `browser.fullscreen.autohide` - set to `false` - prevents firefox from hiding the tab and address bars when toggling sway's fullscreen mode.


## Included Files

- `vimium-options.json`
  Configuration file for the [Vimium](https://github.com/philc/vimium) browser extension, including custom styling and key mappings. (CSS adapted from [catppuccin/vimium](https://github.com/catppuccin/vimium) with a custom color palette)

- `vimium-c-style.css`: Configuration file for the [Vimium C](https://github.com/gdh1995/vimium-c) browser extension. This theme is adapted from [darukutsu/vimiumc-themes](https://github.com/darukutsu/vimiumc-themes). Some repetition in the CSS is necessary due to the way Vimium C parses custom styles, see the [Vimium C custom CSS documentation](https://github.com/gdh1995/vimium-c/wiki/Style-the-UI-of-Vimium-C-using-custom-CSS#basic-structure).

- `userChrome.css` used to customize the Firefox interface and declutter the UI.

  1. Open Firefox and type 'about:support' in the address bar.
  2. In the 'Application Basics' section, find 'Profile Directory' and click 'Open Directory'.
  3. Place this file in the 'chrome' subfolder within your Profile Directory.
     If the 'chrome' folder does not exist, you will need to create it.
  4. Enable legacy user profile customizations:
    a. go to 'about:config'
    b. set `toolkit.legacyUserProfileCustomizations.stylesheets` to true

## Vimium C configuration

### Key mappings

[Sed docs](https://github.com/gdh1995/vimium-c/wiki/Substitute-URLs-and-text-during-commands)

*NOTE: `LinkHints.activate excludeOnHost` was generated using `./dev/vimium_c_hints_exclude_generator.py`*

```vim
map gw firstTab
map gI LinkHints.activateOpenImage

" remove parameters from the current url
map gq goToRoot sed="s/\\?.*//"

" when visiting a github repo, copy the ssh url
map yS copyCurrentUrl sed="s|.*github\\.com/([^/]+)/([^/?#]+).*|git@github.com:$1/$2.git|"

" ignore github contribution calendar squares
map f LinkHints.activate excludeOnHost="github.com##.ContributionCalendar-day"
```

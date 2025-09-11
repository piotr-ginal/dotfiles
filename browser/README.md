# Browser
Browser settings / configs that cant be easily installed

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

# Browser
Browser settings / configs that cant be easily installed

## Included Files

- `vimium-options.json`
  Configuration file for the [Vimium](https://github.com/philc/vimium) browser extension, including custom styling and key mappings. (CSS adapted from [catppuccin/vimium](https://github.com/catppuccin/vimium) with a custom color palette)


- `userChrome.css` used to customize the Firefox interface and declutter the UI.

  1. Open Firefox and type 'about:support' in the address bar.
  2. In the 'Application Basics' section, find 'Profile Directory' and click 'Open Directory'.
  3. Place this file in the 'chrome' subfolder within your Profile Directory.
     If the 'chrome' folder does not exist, you will need to create it.
  4. Enable legacy user profile customizations:
    a. go to 'about:config'
    b. set `toolkit.legacyUserProfileCustomizations.stylesheets` to true

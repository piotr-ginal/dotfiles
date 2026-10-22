user_pref("browser.quitShortcut.disabled", true);

user_pref("browser.download.folderList", 1);

user_pref("browser.fullscreen.autohide", false);

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

user_pref("signon.rememberSignons", false);

user_pref("signon.autofillForms", false);

user_pref("devtools.chrome.enabled", true);

// Disables Nova redesign (rounded tabs/URL bar). Likely removed in Firefox 161
// (after 160, Nov 10 2026). userChrome.css does the same for the corners.
user_pref("browser.nova.enabled", false);

// Disable "This time search with" in new tab url bar
user_pref("browser.urlbar.scotchBonnet.enableOverride", false);

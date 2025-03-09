user_pref("network.IDN_show_punycode", true);
// disk cache in memory
user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox");
user_pref("findbar.highlightAll", true);
user_pref("full-screen-api.warning.timeout", 0);
user_pref("layout.frame_rate", 288);
// hybrid post-quantum key exchange
user_pref("security.tls.enable_kyber", true);
// maybe helps with high-resolution video playback
user_pref("dom.ipc.processCount", 4);
// hardware video decoding acceleration, libva-nvidia-driver
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.rdd-ffmpeg.enabled", true);
user_pref("media.av1.enabled", true);
user_pref("gfx.x11-egl.force-enabled", true);
user_pref("widget.dmabuf.force-enabled", true);
user_pref("browser.bookmarks.openInTabClosesMenu", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("browser.startup.page", 3);
user_pref("ui.key.menuAccessKeyFocuses", false);

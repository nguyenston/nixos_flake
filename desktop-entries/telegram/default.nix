{
  "org.telegram.desktop" = {
    categories = [ "Chat" "Network" "InstantMessaging" "Qt" ];
    comment = "Official desktop version of Telegram messaging app";
    exec = "/usr/bin/env bash -c \"QT_QPA_PLATFORM='wayland;xcb' telegram-desktop -- %u\"";
    icon = "telegram";
    name = "Telegram Desktop";
    type = "Application";
    terminal = false;
    mimeType = [ "x-scheme-handler/tg" ];
    actions = {
      quit = {
        exec = "/usr/bin/env bash -c \"QT_QPA_PLATFORM='wayland;xcb' telegram-desktop -quit\"";
        name = "Quit Telegram";
        icon = "application-exit";
      };
    };
    settings = {
      Categories = "Chat;Network;InstantMessaging;Qt;";
      TryExec = "telegram-desktop";
      StartupWMClass = "TelegramDesktop";
      Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
      DBusActivatable = "true";
      SingleMainWindow = "true";
      X-GNOME-UsesNotifications = "true";
      X-GNOME-SingleWindow = "true";
    };
  };
} 

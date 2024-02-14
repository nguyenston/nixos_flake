{
  webcord = {
    categories = [ "Chat" "Network" "InstantMessaging" "Qt"];
    comment = "Official desktop version of Telegram messaging app";
    exec = "QT_QPA_PLATFORM=\"wayland;xcb\" telegram-desktop";
    icon = "telegram";
    name = "Telegram Desktop";
    type = "Application";
    terminal = false;
    mimeType = "x-scheme-handler/tg";
    actions = {
      quit = {
        exec = "QT_QPA_PLATFORM=\"wayland;xcb\" telegram-desktop -quit";
        name = "Quit Telegram";
        icon = "application-exit";
      };
    };
    settings = {
      TryExec = "QT_QPA_PLATFORM=\"wayland;xcb\" telegram-desktop";
      StartupWMClass = "TelegramDesktop";
      Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop";
      DBusActivatable = "true";
      SingleMainWindow = "true";
      X-GNOME-UsesNotifications = "true";
      X-GNOME-SingleWindow = "true";
    };
  };
} 

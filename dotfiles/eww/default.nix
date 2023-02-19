let
  colors = (import ../../global-params.nix).colors;
in
{
  ".config/eww" = {
    source = ./source;
    recursive = true;
  };
  ".config/eww/colors.scss" = {
    text = ''
      $grey: #c0caf5;
      $bg_button: #414868;
      $bg_button_hover: #3958ad;
      $bg_alt: #2b3047;
      $bg_alt_transparent: transparentize($bg_alt, 0.3);
      $bg_alt_dark_transparent: darken($bg_alt_transparent, 6);
      $bg: transparentize(#1a1b26, 0.15);

      $white: #ffffff;
      $pink: #cd85d0;
      $red: #d08585;
      $cyan: #85c3d0;
      $green: #78bb7b;
      $purple: #9185d0;
      $brown: #bda488;
      $gold: #dbac3f;

      $cpu_color: #db7adb;
      $ram_color: #7adbdb;
      $battery_color_charging: #dbdb7a;
      $battery_color_discharging: #dbab7a;
      $battery_color_full: #abdb7a;
      $temperature_color: #e07f86;

      $bluetooth: #4780c6;
      $wifi: #47c0c6;

      $disk: #576dcc;

      $speaker_color: #a96add;
      $speaker_color_muted: darken(desaturate($speaker_color, 40), 25);
      $audio_color: #6a9edd;
      $mic_color: #6adda9;
      $mic_color_muted: darken(desaturate($mic_color, 40), 25);
      $brightness_color: #dda96a;
    '';
  };
}

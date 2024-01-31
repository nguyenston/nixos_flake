let
  colors = (import ../../global-params.nix).colors;
in
{
  ".config/alacritty" = {
    source = ./source;
    recursive = true;
  };
  ".config/alacritty/colors.toml" = {
    text = ''
      [colors]
      transparent_background_colors = true

      # Default colors
      [colors.primary]
      background = "${colors.Base}" # base
      foreground = "${colors.Text}" # text
      # Bright and dim foreground colors
      dim_foreground = "${colors.Text}" # text
      bright_foreground = "${colors.Text}" # text

      # Cursor colors
      [colors.cursor]
      text = "${colors.Base}" # base
      cursor = "${colors.Rosewater}" # rosewater
      [colors.vi_mode_cursor]
      text = "${colors.Base}" # base
      cursor = "${colors.Lavender}" # lavender

      # Search colors
      [colors.search.matches]
      foreground = "${colors.Base}" # base
      background = "${colors.Subtext0}" # subtext0
      [colors.search.focused_match]
      foreground = "${colors.Base}" # base
      background = "${colors.Green}" # green
      [colors.footer_bar]
      foreground = "${colors.Base}" # base
      background = "${colors.Subtext0}" # subtext0

      # Keyboard regex hints
      [colors.hints.start]
      foreground = "${colors.Base}" # base
      background = "${colors.Yellow}" # yellow
      [colors.hints.end]
      foreground = "${colors.Base}" # base
      background = "${colors.Subtext0}" # subtext0

      # Selection colors
      [colors.selection]
      text = "${colors.Base}" # base
      background = "${colors.Rosewater}" # rosewater

      # Normal colors
      [colors.normal]
      black = "${colors.Surface1}" # surface1
      red = "${colors.Red}" # red
      green = "${colors.Green}" # green
      yellow = "${colors.Yellow}" # yellow
      blue = "${colors.Blue}" # blue
      magenta = "${colors.Pink}" # pink
      cyan = "${colors.Teal}" # teal
      white = "${colors.Subtext1}" # subtext1

      # Bright colors
      [colors.bright]
      black = "${colors.Surface2}" # surface2
      red = "${colors.Red}" # red
      green = "${colors.Green}" # green
      yellow = "${colors.Yellow}" # yellow
      blue = "${colors.Blue}" # blue
      magenta = "${colors.Pink}" # pink
      cyan = "${colors.Teal}" # teal
      white = "${colors.Subtext0}" # subtext0

      # Dim colors
      [colors.dim]
      black = "${colors.Surface1}" # surface1
      red = "${colors.Red}" # red
      green = "${colors.Green}" # green
      yellow = "${colors.Yellow}" # yellow
      blue = "${colors.Blue}" # blue
      magenta = "${colors.Pink}" # pink
      cyan = "${colors.Teal}" # teal
      white = "${colors.Subtext1}" # subtext1

      [[colors.indexed_colors]]
      index = 16
      color = "${colors.Peach}"
      [[colors.indexed_colors]]
      index = 17
      color = "${colors.Rosewater}"
    '';
  };
}

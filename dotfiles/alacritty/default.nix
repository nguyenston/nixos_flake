let
  colors = (import ../../global-params.nix).colors;
in
{
  ".config/alacritty" = {
    source = ./source;
    recursive = true;
  };
  ".config/alacritty/colors.yml" = {
    text = ''
      colors:
          # Default colors
          primary:
              background: "${colors.Base}" # base
              foreground: "${colors.Text}" # text
              # Bright and dim foreground colors
              dim_foreground: "${colors.Text}" # text
              bright_foreground: "${colors.Text}" # text

          # Cursor colors
          cursor:
              text: "${colors.Base}" # base
              cursor: "${colors.Rosewater}" # rosewater
          vi_mode_cursor:
              text: "${colors.Base}" # base
              cursor: "${colors.Lavender}" # lavender

          # Search colors
          search:
              matches:
                  foreground: "${colors.Base}" # base
                  background: "${colors.Subtext0}" # subtext0
              focused_match:
                  foreground: "${colors.Base}" # base
                  background: "${colors.Green}" # green
              footer_bar:
                  foreground: "${colors.Base}" # base
                  background: "${colors.Subtext0}" # subtext0

          # Keyboard regex hints
          hints:
              start:
                  foreground: "${colors.Base}" # base
                  background: "${colors.Yellow}" # yellow
              end:
                  foreground: "${colors.Base}" # base
                  background: "${colors.Subtext0}" # subtext0

          # Selection colors
          selection:
              text: "${colors.Base}" # base
              background: "${colors.Rosewater}" # rosewater

          # Normal colors
          normal:
              black: "${colors.Surface1}" # surface1
              red: "${colors.Red}" # red
              green: "${colors.Green}" # green
              yellow: "${colors.Yellow}" # yellow
              blue: "${colors.Blue}" # blue
              magenta: "${colors.Pink}" # pink
              cyan: "${colors.Teal}" # teal
              white: "${colors.Subtext1}" # subtext1

          # Bright colors
          bright:
              black: "${colors.Surface2}" # surface2
              red: "${colors.Red}" # red
              green: "${colors.Green}" # green
              yellow: "${colors.Yellow}" # yellow
              blue: "${colors.Blue}" # blue
              magenta: "${colors.Pink}" # pink
              cyan: "${colors.Teal}" # teal
              white: "${colors.Subtext0}" # subtext0

          # Dim colors
          dim:
              black: "${colors.Surface1}" # surface1
              red: "${colors.Red}" # red
              green: "${colors.Green}" # green
              yellow: "${colors.Yellow}" # yellow
              blue: "${colors.Blue}" # blue
              magenta: "${colors.Pink}" # pink
              cyan: "${colors.Teal}" # teal
              white: "${colors.Subtext1}" # subtext1

          indexed_colors:
              - { index: 16, color: "${colors.Peach}" } # peach
              - { index: 17, color: "${colors.Rosewater}" } # rosewater
    '';
  };
}

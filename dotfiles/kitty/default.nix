let
  colors = (import ../../global-params.nix).colors;
in
{
  ".config/kitty" = {
    source = ./source;
    recursive = true;
  };
  ".config/kitty/color.conf" = {
    text=''
      background ${colors.Base}
      foreground ${colors.Text}

      selection_foreground ${colors.Base}
      selection_background ${colors.Rosewater}

      color0 ${colors.Surface1}
      color8 ${colors.Surface2}
      #: black

      color1 ${colors.Red}
      color9 ${colors.Red}
      #: red

      color2  ${colors.Green}
      color10 ${colors.Green}
      #: green

      color3  ${colors.Yellow}
      color11 ${colors.Yellow}
      #: yellow

      color4  ${colors.Blue}
      color12 ${colors.Blue}
      #: blue

      color5  ${colors.Pink}
      color13 ${colors.Pink}
      #: magenta

      color6  ${colors.Teal}
      color14 ${colors.Teal}
      #: cyan

      color7  ${colors.Subtext1}
      color15 ${colors.Subtext0}
      #: white

      background_opacity 0.85
    '';
  };
}

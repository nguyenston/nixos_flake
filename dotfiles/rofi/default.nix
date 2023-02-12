let
  colors = (import ../../global-params.nix).colors;
in
{
  ".config/rofi" = {
    source = ./source;
    recursive = true;
  };
  ".config/rofi/colors.rasi" = {
    text = ''
      * {
          background:     ${colors.Crust};
          background-alt: ${colors.Mantle};
          foreground:     ${colors.Text};
          selected:       ${colors.Blue};
          active:         ${colors.Green};
          urgent:         ${colors.Red};
      }
    '';
  };
}

{
  obsidian_wayland = {
    categories = [ "Office" ];
    comment = "Knowledge base";
    exec = "/usr/bin/env bash -c \"env LD_LIBRARY_PATH=\\$(nix build --print-out-paths --no-link nixpkgs#libGL)/lib obsidian --ozone-platform-hint=auto %u\"";
    icon = "obsidian";
    mimeType = [ "x-scheme-handler/obsidian" ];
    name = "Obsidian Wayland";
    type = "Application";
  };
}

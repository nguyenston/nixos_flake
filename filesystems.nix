{ ... }:
let
  user = (import ./global-params.nix).user;
  system = (import ./global-params.nix).system;
in
{
  fileSystems."/home/${user}/Projects/mounts/BMC" = {
    device = "//emcnas1.bmc.bmcroot.bmc.org/HYPERTENSIONRESEARCH$";
    fsType = "cifs";
    options = [
      "username=nguyen.nguyen@bmc.org"
      "noauto"
      "user"
    ];
  };
}

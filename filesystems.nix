{ ... }:
let
  user = (import ./global-params.nix).user;
  system = (import ./global-params.nix).system;
in
{
  fileSystems."/mnt/BMC" = {
    device = "//emcnas1.bmc.bmcroot.bmc.org/HYPERTENSIONRESEARCH$";
    fsType = "cifs";
    options = [
      "username=nguyen.nguyen@bmc.org"
      "noauto"
      "user"
    ];
  };
}

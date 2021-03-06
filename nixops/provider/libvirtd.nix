let
  libvirt = {
    deployment.targetEnv = "libvirtd";

    services.avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
    };

    system.activationScripts.nixops-vm-fix-931 = {
      text = ''
    if ls -l /nix/store | grep sudo | grep -q nogroup; then
      mount -o remount,rw  /nix/store
      chown -R root:nixbld /nix/store
    fi
  '';
      deps = [];
    };
  };

in {
  railsapp-db = libvirt;
}

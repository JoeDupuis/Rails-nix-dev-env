let
  libvirt = {
    deployment.targetEnv = "virtualbox";

    services.avahi = {
      enable = true;
      nssmdns = true;
      publish.enable = true;
      publish.addresses = true;
    };
  };

in {
  rails-db = libvirt;
}

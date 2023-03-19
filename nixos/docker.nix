{ pkgs, ... }:

{
  virtualisation.docker.enable = true;

  users.users.hkmangla = {
    extraGroups = [ "docker" ];
  };

  environment.systemPackages = [ pkgs.docker-compose ];
}
  

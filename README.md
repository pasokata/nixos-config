# nixos-config

```
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
sudo ln -s ~/nixos-config /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

OR

```
cd ~/nixos-config
# Switch to the previous commit
git checkout HEAD^1
# Deploy the flake.nix located in the current directory,
# with the nixosConfiguration's name `my-nixos`
sudo nixos-rebuild switch --flake .#my-nixos
```


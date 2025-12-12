{pkgs, ...}: let
  versions = import ../versions.nix;

  baseHaskellPackages = p:
    with p; [
      cabal-install

      regex-tdfa
      regex-pcre

      universe-base # diagonal lines through enumerables
      linear # helpers for linear algebra, mostly V2 point coordinates
      array # arrays that are great for creating grids with the above
      split # split lists on characters
      multiset # bag, or set which counts
      fgl # graphs & algos
      fgl-visualize # ...and their visualization
      multiset # bag for counting elements
      pqueue # priority queue
      astar # path finding
      alex # parsers
      happy

      # used by neovim
      haskell-language-server
      hlint
    ];
  # linuxHaskellPackages = p: with p; [
  #   xmonad
  #   xmonad-contrib
  #   xmonad-extras
  #   hxt-regex-xmlschema
  #   MissingH
  # ];
  #
  # allHaskellPackages = p:
  #   (baseHaskellPackages p) ++
  #   (if pkgs.stdenv.hostPlatform.isLinux then linuxHaskellPackages p else []);
in {
  home.packages = [
    # for -fllvm
    pkgs.llvm_19

    # (pkgs.haskell.packages.${versions.ghc}.ghcWithPackages allHaskellPackages)
    (pkgs.haskell.packages.${versions.ghc}.ghcWithPackages baseHaskellPackages)
  ];
}

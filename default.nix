{ pkgs ? import <nixpkgs> { } }:

let
  jonas-nix = pkgs.fetchFromGitHub {
    owner = "jonascarpay";
    repo = "nix";
    rev = "819286dffb10fc6ea301e000b7abe32422fba22f";
    sha256 = "08qnbavsw4ipynq2y6pmn9dypijcfsd5i0s1jnwdf7vzgdq87pzw";
  };
in
# originally from jonas: https://github.com/justinwoo/.dotfiles/blob/b0e01cd84250475c341fbae5146404d4f3e35075/alacritty/alacritty.yml#L29
pkgs.st.overrideAttrs (old: {
  buildInputs = old.buildInputs ++ [ pkgs.harfbuzz ];

  patches = old.patches ++ [
    # Scrollback
    # note this causes the most problems with trying to apply future
    # patches on top, requiring rebases
    (builtins.fetchurl {
      url = "https://st.suckless.org/patches/scrollback/st-scrollback-0.8.4.diff";
      sha256 = "0i0fav13sxnsydpllny26139gnzai66222502cplh18iy5fir3j1";
    })
    # Shift-mousewheel scroll
    (builtins.fetchurl {
      url = "https://st.suckless.org/patches/scrollback/st-scrollback-mouse-20191024-a2c479c.diff";
      sha256 = "0z961sv4pxa1sxrbhalqzz2ldl7qb26qk9l11zx1hp8rh3cmi51i";
    })
    # non-shift mousewheel scroll (needs previous 2)
    "${jonas-nix}/desktop/st/mousewheelincrement.diff"

    # some image hell
    (builtins.fetchurl {
      url = "https://st.suckless.org/patches/w3m/st-w3m-0.8.3.diff";
      sha256 = "1cwidwqyg6qv68x8bsnxns2h0gy9crd5hs2z99xcd5m0q3agpmlb";
    })

    ./url.diff
    ./invert.diff
    ./term.diff
    ./solarized-accented.diff
    ./font.diff
    ./shortcuts.diff
  ];
})

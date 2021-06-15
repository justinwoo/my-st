{ pkgs ? import <nixpkgs> { } }:

let
  jonas-nix = pkgs.fetchFromGitHub {
    owner = "jonascarpay";
    repo = "nix";
    rev = "84813c67f9cb1b4c6dccd1b73bf91a8acd6d8753";
    sha256 = "0vhswpq8h5v43h6cqqpl7g0agai16jxkgbjik36y3728lp8zcisy";
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

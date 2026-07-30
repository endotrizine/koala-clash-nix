{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,

  gtk3,
  glib,
  nss,
  nspr,
  dbus,
  cups,
  expat,

  alsa-lib,
  at-spi2-atk,
  atk,
  cairo,
  pango,
  gdk-pixbuf,

  mesa,
  libdrm,
  libgbm,

  libsecret,
  systemd,

  libx11,
  libxcb,
  libxi,
  libxcursor,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxrender,
  libxtst,
  libxscrnsaver,
  libxinerama,
  libxcomposite,
  libxshmfence,
}:

stdenv.mkDerivation rec {
  pname = "koala-clash";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/coolcoala/koala-clash/releases/download/${version}/Koala.Clash_amd64.deb";
    hash = "sha256-ChCDgnnx+vLyONoFiNHlP6RChnjZXlsGbSX6LOt4lxo=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    gtk3
    glib
    nss
    nspr
    dbus
    cups
    expat

    alsa-lib
    atk
    at-spi2-atk
    cairo
    pango
    gdk-pixbuf

    mesa
    libdrm
    libgbm

    libsecret
    systemd

    libx11
    libxcb
    libxi
    libxcursor
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxtst
    libxscrnsaver
    libxinerama
    libxcomposite
    libxshmfence
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out

    cp -r usr/* $out/ || true
    cp -r opt $out/ || true

    mkdir -p $out/bin

    ln -s "$out/opt/Koala.Clash/koala-clash" \
      "$out/bin/koala-clash"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Koala Clash";
    homepage = "https://github.com/coolcoala/koala-clash";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "koala-clash";
  };
}

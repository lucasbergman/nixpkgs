{ lib, stdenv, fetchzip, makeWrapper, openjdk21, openjfx21, jvmFlags ? [ ] }:
let jdk = openjdk21.override { enableJavaFX = true; };
in stdenv.mkDerivation (finalAttrs: {
  pname = "moneydance";
  version = "2023.3_5064";

  src = fetchzip {
    url = "https://infinitekind.com/stabledl/${finalAttrs.version}/moneydance-linux.tar.gz";
    hash = "sha256-jHr1V/gV1seenw2Q0/G405lTiabEYEsOS8p/XyByrtM=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jdk openjfx21 ];

  dontConfigure = true;
  dontUnpack = true;
  dontBuild = true;
  dontFixup = true;

  # N.B. The quotes around the classpath value protect the `*` from shell
  # expansion. The JVM interprets a classpath value like `dir/*` specially,
  # adding every JAR file in `dir` to the classpath.
  installPhase = let
    jvmFlagString = lib.optionalString (jvmFlags != [ ])
      (''--add-flags "${lib.strings.escapeShellArgs jvmFlags}"'');
  in ''
    runHook preInstall

    mkdir -p $out/libexec $out/bin
    cp -p $src/lib/* $out/libexec/
    makeWrapper ${jdk}/bin/java $out/bin/moneydance \
      --add-flags -client \
      --add-flags --add-modules \
      --add-flags javafx.swing,javafx.controls,javafx.graphics \
      --add-flags -classpath \
      --add-flags "'${placeholder "out"}/libexec/*'" \
      ${jvmFlagString} \
      --add-flags Moneydance

    runHook postInstall
  '';

  passthru = { inherit jdk; };

  meta = {
    homepage = "https://infinitekind.com/moneydance";
    description =
      "An easy to use and full-featured personal finance app that doesn't compromise your privacy";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.unfree;
    platforms = jdk.meta.platforms;
    maintainers = [ lib.maintainers.lucasbergman ];
  };
})

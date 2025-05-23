{
  lib,
  buildDunePackage,
  fetchurl,
  alcotest,
  domain-name,
  duration,
  gmap,
  ipaddr,
  logs,
  lru,
  metrics,
  ptime,
  fmt,
  base64,
  ohex,
}:

buildDunePackage rec {
  pname = "dns";
  version = "10.0.0";

  minimalOCamlVersion = "4.13";

  src = fetchurl {
    url = "https://github.com/mirage/ocaml-dns/releases/download/v${version}/dns-${version}.tbz";
    hash = "sha256-dPO9BjvTE0UrpxKrmtgPrgfV/2uG/E9Wd/BNYSMtFwI=";
  };

  propagatedBuildInputs = [
    fmt
    logs
    ptime
    domain-name
    gmap
    ipaddr
    lru
    duration
    metrics
    base64
    ohex
  ];

  doCheck = true;
  checkInputs = [ alcotest ];

  meta = {
    description = "Domain Name System (DNS) library";
    homepage = "https://github.com/mirage/ocaml-dns";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };

}

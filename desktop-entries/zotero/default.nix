{
  zotero = {
    categories = [ "Office" "Database" ];
    comment = "Collect, organize, cite, and share your research sources";
    exec = "/usr/bin/env bash -c \"env LD_LIBRARY_PATH=\\$NIX_LD_LIBRARY_PATH zotero -url %U\"";
    genericName = "Reference Management";   
    icon = "zotero";
    mimeType = [ "x-scheme-handler/zotero" "text/plain" ];
    name = "Zotero";
    type = "Application";
    version = "1.4";
  };
}

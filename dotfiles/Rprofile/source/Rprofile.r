.First <- function() {
  options(repos=structure(c(CRAN="http://cran.rstudio.com/")))
  options(browser="firefox-beta")
  options(pdfviewer="zathura")
  options(width=250)
  options(defaultPackages=c(getOption("defaultPackages"), "data.table"))
}

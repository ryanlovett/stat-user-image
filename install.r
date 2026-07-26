#!/usr/bin/env Rscript

# List of packages to ensure are installed
required_packages <- c("renv", "pak")

# Check and install required packages
new_packages <- required_packages[!sapply(required_packages, requireNamespace, quietly = TRUE)]
if (length(new_packages) > 0) {
  install.packages(new_packages)
}

packages <- c(
  "cobalt@4.6.2",
  "countdown@0.6.0",
  "fivethirtyeight@0.6.2",
  "gapminder@1.0.1",
  "ggrepel@0.9.8",
  "gt@1.3.0",
  "markdown@2.0",
  "MatchIt@4.7.2",
  "openintro@2.5.0",
  "pagedown@0.24",
  "palmerpenguins@0.1.1",
  "plotly@4.10.4",
  "quarto@1.5.1",
  "reshape2@1.4.5",
  "rsample@1.3.2",
  "showtext@0.9-7",
  "swirl@2.4.5",
  "tidycensus@1.7.1",
  "tidymodels@1.5.0",
  "unvotes@0.3.0",
  "xaringanthemer@0.4.4"

  # When adding or removing packages, note that the last package in this list
  # should not have a trailing comma, but every other package should.

  # When adding, try first installing the packages within a datahub session to
  # verify that you have valid versions for the snapshotted package repository.

)

renv::install(packages)

pak::pak("mdbeckman/dcData@d72ca9e")
pak::pak("hadley/emo@3f03b11")
pak::pak("andrewpbray/boxofdata@8afd934")
pak::pak("stat20/stat20data@2536a78")

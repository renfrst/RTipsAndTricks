path <- file.path("H:", "CHSE", "ActiveProjects", "Sandbox", "RTipsAndTricks")
f1 <- file.path(path, "optimizationVectorIndexing.Rmd")
f2 <- file.path(path, "optimizationVectorIndexing.md")
require(knitr)
knit(f1, f2)
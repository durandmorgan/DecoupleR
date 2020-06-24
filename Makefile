all: test

init: ## Setp-up dev environment
	rm -rf renv || true
	rm -rf venv || true
	sed -i '/source("renv\/activate.R")/d' .Rprofile || true
	R -e 'install.packages("renv", repos="https://cran.rstudio.com/")'
	R -e 'renv::init(bare=TRUE)'
	R -e 'renv::restore()'
	R -e 'reticulate::install_miniconda()' || true
	R -e 'precommit::install_precommit()'
	R -e 'precommit::use_precommit(open=FALSE)'

init-renv:  ## Should be only use to generate the first version of revn.lock
	rm -rf renv || true
	rm -rf venv || true
	sed -i '/source("renv\/activate.R")/d' .Rprofile || true
	R -e 'install.packages("renv", repos="https://cran.rstudio.com/")'
	R -e 'renv::init()'
	R -e 'install.packages("devtools", repos="https://cran.rstudio.com/")'
	R -e 'devtools::install_dev_deps()'
	R -e 'install.packages(c("spelling", "goodpractice", "docopt", "styler",  "R.cache"), repos="https://cran.rstudio.com/")'
	R -e 'install.packages("reticulate", repos="https://cran.rstudio.com/")'
	R -e 'reticulate::install_miniconda()' || true
	R -e 'remotes::install_github("lorenzwalthert/precommit")'
	R -e 'precommit::install_precommit()'
	R -e 'precommit::use_precommit(open=FALSE)'
	R -e 'precommit::autoupdate()'
	R -e 'remotes::install_github("dreamRs/prefixer")'
	R -e 'renv::snapshot(type="all")'


depts-update:  ## Update all dependencies
	R -e 'renv::update()'

freeze:  ## renv snapshot
	R -e 'renv::snapshot(type="all")'

pre-commit:  ## Run pre-commit 
	# pre-commit autoupdate 
	pre-commit run --all-files

lint: ## Perform code sanity checks if needed
	R -e 'lintr::lint_package()'

sanity-check: ## Perform code sanity checks if needed
	R -e "goodpractice::gp()"
	R -e 'devtools::spell_check()'

test: ## Run the test suite
	R -e 'devtools::test()'
	
test-cov: ## Run the test suite with coverage statistics
	R -e 'covr::package_coverage()'
	
document: ## Build package documentation
	R -e 'devtools::document()'

style: ## Apply styler::style_pkg function
	R -e 'styler::style_pkg()'
	
build: document ## Build the package source
	R -e 'devtools::build()'

help:  ## Show this help
	@grep -E "^[^._][a-zA-Z_-]*:" Makefile | awk -F '[:#]' '{print $$1, ":", $$NF}' | sort | column -t -s:


.SILENT: build help init init-dev lint test test-cov document
.PHONY: build help init init-dev lint test test-cov document

.PHONY: initialise
initialise: ## Initialises the project, set ups git hooks
	pre-commit install

.PHONY: semtag-%
semtag-%: ## Creates a new tag using semtag
	semtag final -s $*

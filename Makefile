.PHONY: test clean lint

test:
	mkdir -p ~/dotfiles-install-dir
	export HOME=~/dotfiles-install-dir
	chmod +x ./install
	./install

clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete

lint:
	pre-commit run --all-files

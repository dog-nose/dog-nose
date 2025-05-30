SHELL := /bin/zsh

init:
	@echo "link config file..."
	ln -sf $(CURDIR)/config ~/.config

	@echo "Installing oh-my-zsh..."
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

test:
	@echo ">>> Install zsh plugins..."

	cat $(CURDIR)/template/default.zsh > ~/.zshrc

	git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

	source ~/.zshrc


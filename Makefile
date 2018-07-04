help:
	@echo "install"
	@echo "    Install qa"
	@echo "uninstall"
	@echo "    Uninstall qa"

install:
	mkdir -p ~/bin
	cp -f src/qa.sh ~/bin/qa
	chmod +x ~/bin/qa

uninstall:
	rm ~/bin/qa

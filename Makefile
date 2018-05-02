help:
	@echo "install"
	@echo "    Install hermione"
	@echo "uninstall"
	@echo "    Uninstall hermione"

install:
	cp -f hermione.sh ~/bin/hermione
	chmod +x ~/bin/hermione

uninstall:
    rm ~/bin/hermione
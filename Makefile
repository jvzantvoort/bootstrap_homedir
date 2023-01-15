MAKESELF := $(shell which makeself)
NAME = bootstrap_homedir
FILE_NAME = "$(NAME).run"
LABEL = "bootstrap_homedir"
STARTUP_SCRIPT = "./main"

all:
	$(MAKESELF) src $(FILE_NAME) $(LABEL) $(STARTUP_SCRIPT) --gzip --nox11 --nowait

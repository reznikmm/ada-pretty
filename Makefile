GPRBUILD_FLAGS = -p -j0
PREFIX                 ?= /usr
INSTALL_PROJECT_DIR    ?= $(DESTDIR)$(GPRDIR)
INSTALL_INCLUDE_DIR    ?= $(DESTDIR)$(PREFIX)/include/ada-pretty
INSTALL_LIBRARY_DIR    ?= $(DESTDIR)$(LIBDIR)
INSTALL_ALI_DIR        ?= ${INSTALL_LIBRARY_DIR}/ada-pretty

GPRINSTALL_FLAGS = --prefix=$(PREFIX) --sources-subdir=$(INSTALL_INCLUDE_DIR)\
 --lib-subdir=$(INSTALL_ALI_DIR) --project-subdir=$(INSTALL_PROJECT_DIR)\
--link-lib-subdir=$(INSTALL_LIBRARY_DIR)
#INSTALL = install
#INSTALL_project = $(INSTALL) -m 644

all:
	gprbuild $(GPRBUILD_FLAGS) -P gnat/ada_pretty.gpr

install:
	gprinstall $(GPRINSTALL_FLAGS) -p -P gnat/ada_pretty.gpr
#	$(INSTALL) -d ${INSTALL_PROJECT_DIR}
#	$(INSTALL_project) gnat/install/league.gpr  $(INSTALL_PROJECT_DIR)/matreshka_league.gpr

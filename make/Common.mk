# "Header" subscript containing common stuff for all configurations.
# First, include the "GNU Make Standard Library"
include make/gmsl


# Helpful character macros
space:=$(null) $(null)
define endl


endef
define tab
	
endef


# Make sure BASE_DIR is flattened, and have a place to specify initial values
# for other additive internal vars just for the sake of completeness.
BASE_DIR           := $(BASE_DIR)
PROJECT_NAME        = Project113
SRC_LIST            = $(null)
P113_SRC_LIST       = $(null)
P113_OBJ_LIST       = $(null)
P113_INCLUDE_DIR    = $(INCLUDE_DIR)/$(PROJECT_NAME)
BUILD_DIRS_LIST     = $(BUILD_DIR) $(BIN_DIR) $(LIB_DIR)
INTERNAL_DEFS       = $(null)
COMMON_CFLAGS       = $(null)
COMMON_LINKFLAGS    = $(null)
COMMON_LINKLIBS     = $(null)
BIN_LINKLIBS        = $(null)
FINAL_TARGETS       = $(null)
BUILD_PROGRESS      = $(null)


# Specify default target here so it's always the first one found. 'build' is a
# dummy target at the bottom of the main Makefile, after everything else is included.
all: build
	@$(ECHO) *** Finished Project113 Make script ***

.PHONY: all pre-build build clean

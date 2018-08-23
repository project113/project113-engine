# Project113 main makefile
# Build system requires (hopefully) just GNU Make and your toolchain of choice.
$(info *** Started Project113 Make script ***)
include make/Common.mk


# *** Change or override the variables below as needed (toolchain at a minimum)***
  BUILD_TYPE            = Debug
  BUILD_TOOLCHAIN       = PleaseSetToolchain
  BUILD_SHARED_LIBS     = Yes
  BUILD_STATIC_LIBS     = No
#Tests can always be compiled and run with 'make buildtests' & 'make runtests'
# respectively, these just control whether it happens automatically for the
# default 'all' target.
  BUILD_TESTS           = Yes
  RUN_TESTS             = Yes
  CUSTOM_CFLAGS         = $(null)
#3RDPARTY_LIST: Libraries in 3RDPARTY_DIR/ to build from source
# (instead of using system versions), separated by spaces.
  3RDPARTY_LIST         = $(null)
  SYSTEM_LIBS           = SDL2
  BASE_DIR              = $(CURDIR)
  3RDPARTY_DIR          = 3rdparty
  SRC_DIR               = src
  BASE_INCLUDE_DIR      = include
  INCLUDE_DIRS_LIST     = $(BASE_INCLUDE_DIR)
  TESTS_DIR             = tests
  BUILD_DIR             = obj
  BIN_DIR               = $(BUILD_DIR)/bin
  LIB_DIR               = $(BUILD_DIR)/lib
#TESTS_LIST by default includes all tests
  TESTS_LIST            = TestBasicInitDestroy
# *** End of config options ***

# Flatten some config options to avoid constantly making the calls shown during expansions
ifeq ($(call lc,$(call substr,$(BUILD_SHARED_LIBS),1,1)),y)
  BUILDING_SHARED_LIBS := y
endif
ifeq ($(call lc,$(call substr,$(BUILD_STATIC_LIBS),1,1)),y)
  BUILDING_STATIC_LIBS := y
endif


# Pull in subscripts and display build options
# They are intermingled because the toolchain subscript may modify the build type.
$(info *** Build options)
$(info * BUILD_TOOLCHAIN   - $(BUILD_TOOLCHAIN))
include make/$(BUILD_TOOLCHAIN).mk
$(info * BUILD_TYPE        - $(BUILD_TYPE))
$(info * RUN_TESTS         - $(RUN_TESTS))
$(info * BUILD_SHARED_LIBS - $(BUILD_SHARED_LIBS))
$(info * BUILD_STATIC_LIBS - $(BUILD_STATIC_LIBS))
include $(3RDPARTY_DIR)/3rdparty.mk
include $(SRC_DIR)/src.mk
include $(TESTS_DIR)/tests.mk


# Calculate total number of sources (for info output). Really only useful for a
# a clean build, but can still provide an interesting metric otherwise.
TOTAL_SRCS := $(call length,$(SRC_LIST))


# Would have been nice if the normal pattern rule worked, but apparently not...
$(foreach src,$(P113_SRC_LIST) $(TESTS_SRC_LIST),$(eval $(src)_DEPS+=$(P113_INCLUDE_DIR)/Config.hxx))


# Here's where the real magic happens; once SRC_LIST and *_DEPS have been
# filled in by the scripts above, we generate a build target for every object
# file using a generic compile / dependency rule template. It's all based on
# the (possibly foolish) assumptions that 1 object file = 1 source file (plus a
# possible dependency list), and that most compilations use the same command.
# If special cases are needed, just add regular old-fashioned rules where appropriate.
define OBJ_COMPILE_RULE =
$(eval objfile:=$(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(src))))
$(objfile): $(src) $($(src)_DEPS)
	$(eval BUILD_PROGRESS:=$(call int_inc,$(BUILD_PROGRESS)))
	@$(ECHO)   BUILD [$(call int_decode,$(BUILD_PROGRESS))/$(TOTAL_SRCS)] $(objfile)
	@$(COMPILE_CMD)
endef
$(foreach src,$(SRC_LIST),$(eval $(OBJ_COMPILE_RULE)))
$(foreach dir,$(BUILD_DIRS_LIST),$(eval $(BUILD_DIR_RULE)))


# Make sure there's actually some valid target somewhere
FINAL_TARGETS_LEN = $(call length,$(FINAL_TARGETS))
ifdef FINAL_TARGETS_LEN
  $(info *** Checking $(FINAL_TARGETS_LEN) final targets)
else
  $(error No final targets found!)
endif


# Set up build targets and make sure build directories are created
# Default target 'all' is in the Common script included at the top, and depends
# on 'build' and possibly 'runtests' depending on the build options.
pre-build: $(BUILD_DIRS_LIST)
build: pre-build $(FINAL_TARGETS)
	@$(ECHO) *** Finished build target

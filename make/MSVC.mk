# MS Visual C++ Command-Line toolchain subscript
# Basic platform variables
BUILD_PLATFORM       = Windows
ECHO                 = echo
MKDIR                = mkdir
MKLINK               = mklink
COPY                 = copy
CC                   = cl
AR                   = lib
LINK                 = link
BIN_SUFFIX           = .exe
STATICLIB_EXT        = lib
SHLIB_EXT            = dll
OBJ_EXT              = obj
COMMON_CDEFS        += /DP113_PLATFORM_$(call uc,$(BUILD_PLATFORM)) /DP113_BUILD_$(call uc,$(BUILD_TYPE)) $(if $(BUILDING_SHARED_LIBS),/DP113_BUILD_SHARED)
COMMON_CFLAGS       += /nologo /utf-8 /EHsc /permissive- $(foreach dir,$(INCLUDE_DIRS_LIST),/I$(dir))
COMMON_LINKFLAGS    += /nologo /SUBSYSTEM:CONSOLE
COMMON_LINKLIBS     += $(addsuffix .$(STATICLIB_EXT),$(SYSTEM_LIBS))
BIN_LINKLIBS        += SDL2main.lib


# Build type configuration
# Generic library targets (using the link commands below) are in src.mk
# TODO: Fix implib in SHLIB_LINK_CMD so we can use the same command for 3rdparty libs
ifeq ($(BUILD_TYPE),Release)
  BUILD_CFLAGS       = /O2 /GR- /fp:fast
  SHARED_LIB_FILE    = $(BIN_DIR)/$(lib).$(SHLIB_EXT)
  IMPORT_LIB_FILE    = $(LIB_DIR)/$(lib).$(SHLIB_EXT).$(STATICLIB_EXT)
  STATIC_LIB_FILE    = $(LIB_DIR)/$(lib).$(STATICLIB_EXT)
  BUILD_LINKFLAGS    = /NXCOMPAT /DEBUG:NONE

# Default to a Debug build type if another one wasn't already handled
else
  BUILD_TYPE         = Debug
  BUILD_CFLAGS       = /Od /Fd$(addprefix $(BUILD_DIR)/,$(addsuffix .pdb,$(src))) /Zi /GS /fp:strict /RTC1
  SHARED_LIB_FILE    = $(BIN_DIR)/$(lib)d.$(SHLIB_EXT)
  IMPORT_LIB_FILE    = $(LIB_DIR)/$(lib)d.$(SHLIB_EXT).$(STATICLIB_EXT)
  STATIC_LIB_FILE    = $(LIB_DIR)/$(lib)d.$(STATICLIB_EXT)
  BUILD_LINKFLAGS    = /NXCOMPAT /DEBUG:FULL /DYNAMICBASE:NO
endif


# Command string creation
INTERNAL_CDEFS       = $(foreach def,$(INTERNAL_DEFS),/D$(def))
COMPILE_CMD          = $(CC) $(COMMON_CFLAGS) $(BUILD_CFLAGS) $(COMMON_CDEFS) $(INTERNAL_CDEFS) $(INTERNAL_CFLAGS) $(CUSTOM_CFLAGS) /c /Fo$(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(src))) $(src)
SHLIB_LINK_CMD       = $$(LINK) $$(COMMON_LINKFLAGS) $$(BUILD_LINKFLAGS) /DLL /OUT:$$@ /IMPLIB:$(IMPORT_LIB_FILE) $$^ $$(COMMON_LINKLIBS)
STATICLIB_LINK_CMD   = $$(AR) $$(COMMON_LINKFLAGS) /OUT:$$@ $$^
TEST_LINK_CMD        = $(LINK) $(COMMON_LINKFLAGS) $(BUILD_LINKFLAGS) /OUT:$(testbin) $(testobj) $(COMMON_LINKLIBS) $(BIN_LINKLIBS)


# Library rule template
define MAKE_LIBS_RULE =
ifdef BUILDING_SHARED_LIBS
  FINAL_TARGETS  += $(SHARED_LIB_FILE)
  BUILT_LINKLIBS += $(IMPORT_LIB_FILE)
  $(IMPORT_LIB_FILE): $(SHARED_LIB_FILE)
  $(SHARED_LIB_FILE): $$($(lib)_LIB_OBJS)
	@$$(ECHO)   LINK  $$@
	$(SHLIB_LINK_CMD)
else
  # Link target executables exclusively to either static or shared libs
  BUILT_LINKLIBS += $(STATIC_LIB_FILE)
endif

ifdef BUILDING_STATIC_LIBS
  FINAL_TARGETS  += $(STATIC_LIB_FILE)
  $(STATIC_LIB_FILE): $$($(lib)_LIB_OBJS)
	@$$(ECHO)   LINK  $$@
	@$(STATICLIB_LINK_CMD)
endif
  BIN_LINKLIBS += $$(BUILT_LINKLIBS)
endef


# Link creation
# Preferably this would use MKLINK but I'm too lazy to figure out the "File not
# found" CreateProcess error at the moment.
define FILE_MKLINK_RULE =
  $(target):
	@$(ECHO)   MKLINK  $(src) [to] $(target)
	@$(COPY) /B /V "$(subst /,\,$(src))" "$(subst /,\,$(target))"
endef

define DIR_MKLINK_RULE =
  $(target):
	@$(ECHO)   MKLINK  $(src) [to] $(target)
	@$(MKLINK) /D $(subst /,\,$(target)) $(subst /,\,$(src))
endef


# Directory creation and cleanup
define BUILD_DIR_RULE =
  $(dir):
	@$(ECHO)   MKDIR  $(dir)
	@$(MKDIR) $(subst /,\,$(dir))
endef

clean:
	$(eval REMOVE_DIRS_LIST:=$(subst /,\,$(call reverse,$(BUILD_DIRS_LIST))))
	@$(ECHO)   RMDIR  $(REMOVE_DIRS_LIST)
	-@rmdir /S /Q $(REMOVE_DIRS_LIST)

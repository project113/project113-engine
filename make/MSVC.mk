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
  P113_SHARED_LIB    = $(BIN_DIR)/$(PROJECT_NAME).$(SHLIB_EXT)
  P113_IMPORT_LIB    = $(LIB_DIR)/$(PROJECT_NAME).$(SHLIB_EXT).$(STATICLIB_EXT)
  P113_STATIC_LIB    = $(LIB_DIR)/$(PROJECT_NAME).$(STATICLIB_EXT)
  BUILD_LINKFLAGS    = /NXCOMPAT /DEBUG:NONE

# Default to a Debug build type if another one wasn't already handled
else
  BUILD_TYPE         = Debug
  BUILD_CFLAGS       = /Od /Fd$(addprefix $(BUILD_DIR)/,$(addsuffix .pdb,$(src))) /Zi /GS /fp:strict /RTC1
  P113_SHARED_LIB    = $(BIN_DIR)/$(PROJECT_NAME)d.$(SHLIB_EXT)
  P113_IMPORT_LIB    = $(LIB_DIR)/$(PROJECT_NAME)d.$(SHLIB_EXT).$(STATICLIB_EXT)
  P113_STATIC_LIB    = $(LIB_DIR)/$(PROJECT_NAME)d.$(STATICLIB_EXT)
  BUILD_LINKFLAGS    = /NXCOMPAT /DEBUG:FULL /DYNAMICBASE:NO
endif


# We might build both lib versions, but only link tests/etc to one or the other
# Ideally we'd stick this in src.mk, but we want to handle the import lib case
ifdef BUILDING_SHARED_LIBS
  P113_BIN_LINK_LIB  = $(P113_IMPORT_LIB)
else
  P113_BIN_LINK_LIB  = $(P113_STATIC_LIB)
endif
BIN_LINKLIBS        += $(P113_BIN_LINK_LIB)
$(P113_IMPORT_LIB): $(P113_SHARED_LIB)


# Command string creation
INTERNAL_CDEFS       = $(foreach def,$(INTERNAL_DEFS),/D$(def))
COMPILE_CMD          = $(CC) $(COMMON_CFLAGS) $(BUILD_CFLAGS) $(COMMON_CDEFS) $(INTERNAL_CDEFS) $(INTERNAL_CFLAGS) $(CUSTOM_CFLAGS) /c /Fo$(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(src))) $(src)
SHLIB_LINK_CMD       = $(LINK) $(COMMON_LINKFLAGS) $(BUILD_LINKFLAGS) /DLL /OUT:$@ /IMPLIB:$(P113_IMPORT_LIB) $^ $(COMMON_LINKLIBS)
STATICLIB_LINK_CMD   = $(AR) $(COMMON_LINKFLAGS) /OUT:$@ $^
TEST_LINK_CMD        = $(LINK) $(COMMON_LINKFLAGS) $(BUILD_LINKFLAGS) /OUT:$(testbin) $(testobj) $(COMMON_LINKLIBS) $(BIN_LINKLIBS)


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

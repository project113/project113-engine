# MS Visual C++ Command-Line toolchain subscript
# Basic platform variables
BUILD_PLATFORM       = Windows
ECHO                 = echo
MKDIR                = mkdir
CC                   = cl
AR                   = lib
LINK                 = link
BIN_SUFFIX           = .exe
STATICLIB_EXT        = lib
SHLIB_EXT            = dll
OBJ_EXT              = obj
COMMON_CDEFS        += /DP113_PLATFORM_$(call uc,$(BUILD_PLATFORM)) /DP113_BUILD_$(call uc,$(BUILD_TYPE)) $(if $(BUILDING_SHARED_LIBS),/DP113_BUILD_SHARED)
COMMON_CFLAGS       += /nologo /I$(INCLUDE_DIR) /utf-8 /EHsc /permissive-
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
  BIN_LINKLIBS      += $(P113_IMPORT_LIB)
else
  BIN_LINKLIBS      += $(P113_STATIC_LIB)
endif


# Even though we don't currently use any (other) extensions, Windows requires an
# extension loader to use anything beyond OpenGL 1.1, so we include GLAD for now.
3RDPARTY_LIST       += glad


# Command string creation
INTERNAL_CDEFS       = $(foreach def,$(INTERNAL_DEFS),/D$(def))
COMPILE_CMD          = $(CC) $(COMMON_CFLAGS) $(BUILD_CFLAGS) $(COMMON_CDEFS) $(INTERNAL_CDEFS) $(CUSTOM_CFLAGS) /c /Fo$(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(src))) $(src)
SHLIB_LINK_CMD       = $(LINK) $(COMMON_LINKFLAGS) $(BUILD_LINKFLAGS) /DLL /OUT:$@ /IMPLIB:$(P113_IMPORT_LIB) $^ $(COMMON_LINKLIBS)
STATICLIB_LINK_CMD   = $(AR) $(COMMON_LINKFLAGS) /OUT:$@ $^
TEST_LINK_CMD        = $(LINK) $(COMMON_LINKFLAGS) $(BUILD_LINKFLAGS) /OUT:$(testbin) $(testobj) $(COMMON_LINKLIBS) $(BIN_LINKLIBS)

# Directory creation and cleanup
define BUILD_DIR_RULE =
$(dir):
	@$(ECHO)   MKDIR  $(dir)
	@$(MKDIR) $(subst /,\,$(dir))
endef

clean:
	@$(ECHO)   RMDIR  $(BUILD_DIRS_LIST)
	-@rmdir /S /Q $(subst /,\,$(BUILD_DIRS_LIST))

# Project113 "3rdparty" subscript: BX
BX_DIR               = $(3RDPARTY_DIR)/bx
BX_INCLUDE_DIR       = $(BX_DIR)/include
BX_SRC               = $(BX_DIR)/src/amalgamated.cpp
$(BX_SRC)_DEPS       = $(wildcard $(BX_INCLUDE_DIR)/bx/*.h) \
                       $(wildcard $(BX_DIR)/src/*.h) \
                       $(wildcard $(BX_DIR)/src/*.cpp)
INCLUDE_DIRS_LIST   += $(BX_INCLUDE_DIR) $(BX_DIR)/3rdparty
BUILD_DIRS_LIST     += $(BUILD_DIR)/$(BX_DIR) $(BUILD_DIR)/$(BX_DIR)/src
SRC_LIST            += $(BX_SRC)
bx_LIB_OBJS          = $(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(BX_SRC)))

# BX doesn't have special support for building as a shared library
old_shlib_option:=$(BUILDING_SHARED_LIBS)
old_statlib_option:=$(BUILDING_STATIC_LIBS)
BUILDING_SHARED_LIBS:=$(null)
BUILDING_STATIC_LIBS:=y
lib:=bx
$(eval $(MAKE_LIBS_RULE))
BUILDING_SHARED_LIBS:=$(old_shlib_option)
BUILDING_STATIC_LIBS:=$(old_statlib_option)


# Build config
ifeq ($(BUILD_TYPE),Debug)
  INTERNAL_DEFS     += BX_CONFIG_DEBUG=1
endif

ifeq ($(BUILD_TOOLCHAIN),MSVC)
  INCLUDE_DIRS_LIST += $(BX_INCLUDE_DIR)/compat/msvc
endif

# TODO: Figure out where this is actually supposed to be defined
INTERNAL_DEFS       += __STDC_FORMAT_MACROS=1

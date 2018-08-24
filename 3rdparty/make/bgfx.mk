# Project113 "3rdparty" subscript: BGFX
BGFX_DIR           = $(3RDPARTY_DIR)/bgfx
BGFX_3RDPARTY_DIR  = $(BGFX_DIR)/3rdparty
BGFX_INCLUDE_DIR   = $(BGFX_DIR)/include
BGFX_SRC           = $(BGFX_DIR)/src/amalgamated.cpp
$(BGFX_SRC)_DEPS   = $(wildcard $(BGFX_INCLUDE_DIR)/bgfx/*.h) $(wildcard $(BGFX_DIR)/src/*.h) $(wildcard $(BGFX_DIR)/src/*.cpp)
INCLUDE_DIRS_LIST += $(BGFX_INCLUDE_DIR)                \
                     $(BGFX_3RDPARTY_DIR)               \
					 $(BGFX_3RDPARTY_DIR)/khronos       \
					 $(BGFX_3RDPARTY_DIR)/dxsdk/include

BUILD_DIRS_LIST   += $(BUILD_DIR)/$(BGFX_DIR) $(BUILD_DIR)/$(BGFX_DIR)/src
SRC_LIST          += $(BGFX_SRC)
bgfx_LIB_OBJS      = $(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(BGFX_SRC)))


# BGFX doesn't have special support for building as a shared library
old_shlib_option:=$(BUILDING_SHARED_LIBS)
old_statlib_option:=$(BUILDING_STATIC_LIBS)
BUILDING_SHARED_LIBS:=$(null)
BUILDING_STATIC_LIBS:=y
lib:=bgfx
$(eval $(MAKE_LIBS_RULE))
BUILDING_SHARED_LIBS:=$(old_shlib_option)
BUILDING_STATIC_LIBS:=$(old_statlib_option)


ifeq ($(BUILD_TYPE),Debug)
  INTERNAL_DEFS   += BGFX_CONFIG_DEBUG=1
endif

ifeq ($(BUILD_PLATFORM),Windows)
  SYSTEM_LIBS += User32 Gdi32
endif

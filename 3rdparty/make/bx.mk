# Project113 "3rdparty" subscript: BX
# For now just cheat and link it directly into P113.
BX_DIR               = $(3RDPARTY_DIR)/bx
BX_INCLUDE_DIR       = $(BX_DIR)/include
BX_SRC               = $(BX_DIR)/src/amalgamated.cpp
$(BX_SRC)_DEPS       = $(wildcard $(BX_INCLUDE_DIR)/bx/*.h) \
                       $(wildcard $(BX_DIR)/src/*.h) \
                       $(wildcard $(BX_DIR)/src/*.cpp)
P113_SRC_LIST       += $(BX_SRC)
INCLUDE_DIRS_LIST   += $(BX_INCLUDE_DIR) $(BX_DIR)/3rdparty
BUILD_DIRS_LIST     += $(BUILD_DIR)/$(BX_DIR) $(BUILD_DIR)/$(BX_DIR)/src

ifeq ($(BUILD_TYPE),Debug)
  INTERNAL_DEFS     += BX_CONFIG_DEBUG=1
endif

ifeq ($(BUILD_TOOLCHAIN),MSVC)
  INCLUDE_DIRS_LIST += $(BX_INCLUDE_DIR)/compat/msvc
endif

# TODO: Figure out where this is actually supposed to be defined
INTERNAL_DEFS       += __STDC_FORMAT_MACROS=1

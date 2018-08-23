# Project113 "3rdparty" subscript: BGFX
# For now just cheat and link it directly into P113.
BGFX_DIR           = $(3RDPARTY_DIR)/bgfx
BGFX_3RDPARTY_DIR  = $(BGFX_DIR)/3rdparty
BGFX_INCLUDE_DIR   = $(BGFX_DIR)/include
BGFX_SRC           = $(BGFX_DIR)/src/amalgamated.cpp
$(BGFX_SRC)_DEPS   = $(wildcard $(BGFX_INCLUDE_DIR)/bgfx/*.h) $(wildcard $(BGFX_DIR)/src/*.h) $(wildcard $(BGFX_DIR)/src/*.cpp)
P113_SRC_LIST     += $(BGFX_SRC)
INCLUDE_DIRS_LIST += $(BGFX_INCLUDE_DIR)                \
                     $(BGFX_3RDPARTY_DIR)               \
					 $(BGFX_3RDPARTY_DIR)/khronos       \
					 $(BGFX_3RDPARTY_DIR)/dxsdk/include

BUILD_DIRS_LIST   += $(BUILD_DIR)/$(BGFX_DIR) $(BUILD_DIR)/$(BGFX_DIR)/src

ifeq ($(BUILD_TYPE),Debug)
  INTERNAL_DEFS   += BGFX_CONFIG_DEBUG=1
endif

ifeq ($(BUILD_PLATFORM),Windows)
  SYSTEM_LIBS += User32 Gdi32
endif

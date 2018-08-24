# Project113 "3rdparty" subscript: BIMG

# Directories
BIMG_DIR            = $(3RDPARTY_DIR)/bimg
BIMG_3RDPARTY_DIR   = $(BIMG_DIR)/3rdparty
BIMG_INCLUDE_DIR    = $(BIMG_DIR)/include
BIMG_LIBSQUISH_DIR  = $(BIMG_3RDPARTY_DIR)/libsquish
BIMG_IQA_DIR        = $(BIMG_3RDPARTY_DIR)/iqa
BIMG_ETC1_DIR       = $(BIMG_3RDPARTY_DIR)/etc1
BIMG_ETC2_DIR       = $(BIMG_3RDPARTY_DIR)/etc2
BIMG_NVTT_DIR       = $(BIMG_3RDPARTY_DIR)/nvtt
BIMG_PVRTC_DIR      = $(BIMG_3RDPARTY_DIR)/pvrtc
BIMG_EDTAA_DIR      = $(BIMG_3RDPARTY_DIR)/edtaa3
BIMG_ASTC_DIR       = $(BIMG_3RDPARTY_DIR)/astc


# Source and include files
BIMG_SRC            = $(wildcard $(BIMG_DIR)/src/*.cpp)
BIMG_LIBSQUISH_SRC  = $(wildcard $(BIMG_LIBSQUISH_DIR)/*.cpp)
BIMG_IQA_SRC        = $(wildcard $(BIMG_IQA_DIR)/source/*.c)
BIMG_ETC1_SRC       = $(BIMG_ETC1_DIR)/etc1.cpp
BIMG_ETC2_SRC       = $(wildcard $(BIMG_ETC2_DIR)/*.cpp)
BIMG_NVTT_SRC       = $(BIMG_NVTT_DIR)/nvtt.cpp               \
                      $(wildcard $(BIMG_NVTT_DIR)/bc6h/*.cpp) \
                      $(wildcard $(BIMG_NVTT_DIR)/bc7/*.cpp)  \
                      $(BIMG_NVTT_DIR)/nvmath/fitting.cpp
BIMG_PVRTC_SRC      = $(wildcard $(BIMG_PVRTC_DIR)/*.cpp)
BIMG_EDTAA_SRC      = $(BIMG_EDTAA_DIR)/edtaa3func.cpp
BIMG_ASTC_SRC       = $(wildcard $(BIMG_ASTC_DIR)/*.cpp)


BIMG_SRC_LIST       = $(BIMG_SRC)             \
                      $(BIMG_LIBSQUISH_SRC)   \
                      $(BIMG_IQA_SRC)         \
                      $(BIMG_ETC1_SRC)        \
                      $(BIMG_ETC2_SRC)        \
                      $(BIMG_NVTT_SRC)        \
                      $(BIMG_PVRTC_SRC)       \
                      $(BIMG_EDTAA_SRC)       \
                      $(BIMG_ASTC_SRC)


INCLUDE_DIRS_LIST  += $(BIMG_INCLUDE_DIR)     \
                      $(BIMG_DIR)/3rdparty    \
                      $(BIMG_IQA_DIR)/include \
                      $(BIMG_NVTT_DIR)


BUILD_DIRS_LIST    += $(BUILD_DIR)/$(BIMG_DIR)             \
                      $(BUILD_DIR)/$(BIMG_DIR)/src         \
                      $(BUILD_DIR)/$(BIMG_3RDPARTY_DIR)    \
                      $(BUILD_DIR)/$(BIMG_LIBSQUISH_DIR)   \
                      $(BUILD_DIR)/$(BIMG_IQA_DIR)         \
                      $(BUILD_DIR)/$(BIMG_IQA_DIR)/source  \
                      $(BUILD_DIR)/$(BIMG_ETC1_DIR)        \
                      $(BUILD_DIR)/$(BIMG_ETC2_DIR)        \
                      $(BUILD_DIR)/$(BIMG_NVTT_DIR)        \
                      $(BUILD_DIR)/$(BIMG_NVTT_DIR)/bc6h   \
                      $(BUILD_DIR)/$(BIMG_NVTT_DIR)/bc7    \
                      $(BUILD_DIR)/$(BIMG_NVTT_DIR)/nvmath \
                      $(BUILD_DIR)/$(BIMG_PVRTC_DIR)       \
                      $(BUILD_DIR)/$(BIMG_EDTAA_DIR)       \
                      $(BUILD_DIR)/$(BIMG_ASTC_DIR)

SRC_LIST           += $(BIMG_SRC_LIST)
bimg_LIB_OBJS       = $(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(BIMG_SRC_LIST)))

# Add dependencies; just trigger a rebuild of the whole sub-lib if any of its
# headers change, rather than trying to be exact.
$(foreach src,$(BIMG_SRC),$(eval $(src)_DEPS=$(wildcard $(BIMG_INCLUDE_DIR)/bimg/*.h) $(BIMG_DIR)/src/bimg_p.h))
$(foreach src,$(BIMG_LIBSQUISH_SRC),$(eval $(src)_DEPS=$(addsuffix .h,$(basename $(src)))))
$(foreach src,$(BIMG_IQA_SRC),$(eval $(src)_DEPS=$(wildcard $(BIMG_IQA_DIR)/include/*.h)))
$(BIMG_ETC1_SRC)_DEPS = $(BIMG_ETC1_DIR)/etc1.h
$(foreach src,$(BIMG_ETC2_SRC),$(eval $(src)_DEPS=$(wildcard $(BIMG_ETC2_DIR)/*.hpp)))
$(foreach src,$(BIMG_NVTT_SRC),$(eval $(src)_DEPS=$(BIMG_NVTT_DIR)/nvtt.h $(wildcard $(BIMG_NVTT_DIR)/bc6h/*.h) $(wildcard $(BIMG_NVTT_DIR)/bc7/*.h) $(wildcard $(BIMG_NVTT_DIR)/nvcore/*.h) $(wildcard $(BIMG_NVTT_DIR)/nvmath/*.h)))
$(foreach src,$(BIMG_PVRTC_SRC),$(eval $(src)_DEPS=$(wildcard $(BIMG_PVRTC_DIR)/*.h)))
$(BIMG_EDTAA_SRC)_DEPS = $(BIMG_EDTAA_DIR)/edtaa3func.h
$(foreach src,$(BIMG_ASTC_SRC),$(eval $(src)_DEPS=$(wildcard $(BIMG_ASTC_DIR)/*.h)))


# BIMG doesn't have special support for building as a shared library
old_shlib_option:=$(BUILDING_SHARED_LIBS)
old_statlib_option:=$(BUILDING_STATIC_LIBS)
BUILDING_SHARED_LIBS:=$(null)
BUILDING_STATIC_LIBS:=y
lib:=bimg
$(eval $(MAKE_LIBS_RULE))
BUILDING_SHARED_LIBS:=$(old_shlib_option)
BUILDING_STATIC_LIBS:=$(old_statlib_option)


# Disable silly codepage warning caused by NVTT author name
ifeq ($(BUILD_TOOLCHAIN),MSVC)
  INTERNAL_CFLAGS += /wd4828
endif

# Project113 "3rdparty" subscript that further includes 3RDPARTY_LIST scripts
# TODO: Add functionality to actually create separate libs for users to use
# rather than just integrating 3rdparty objs directly into P113.
# - See /LIBPATH for MSVC (or of course -L for GCC when we get there...)
# - Use COMMON_LINKLIBS and BIN_LINKLIBS

3RDPARTY_LIST_LEN = $(call length,$(3RDPARTY_LIST))
ifdef 3RDPARTY_LIST_LEN
  ifneq ($(3RDPARTY_LIST_LEN),0)
    $(info *** Adding $(3RDPARTY_LIST_LEN) 3rdparty libs - $(3RDPARTY_LIST))
    BUILD_DIRS_LIST   += $(BUILD_DIR)/$(3RDPARTY_DIR)
    INCLUDE_DIRS_LIST += $(3RDPARTY_DIR)
    include $(foreach lib,$(3RDPARTY_LIST),$(3RDPARTY_DIR)/make/$(lib).mk)
  else
    $(info *** Not building any 3rdparty libs - using SYSTEM_LIBS versions)
  endif
else
  $(info *** Not building any 3rdparty libs - using SYSTEM_LIBS versions)
endif

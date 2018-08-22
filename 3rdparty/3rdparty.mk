# Project113 "3rdparty" subscript that includes subscripts according to 3RDPARTY_LIST
# TODO: Add functionality to actually create separate libs for users to use
# rather than just integrating 3rdparty objs directly into P113.

3RDPARTY_LIST_LEN = $(call length,$(3RDPARTY_LIST))
ifdef 3RDPARTY_LIST_LEN
  $(info *** Adding $(3RDPARTY_LIST_LEN) 3rdparty libs - $(3RDPARTY_LIST))
  BUILD_DIRS_LIST += $(BUILD_DIR)/$(3RDPARTY_DIR)
  include $(foreach lib,$(3RDPARTY_LIST),$(3RDPARTY_DIR)/$(lib)/$(lib).mk)
else
  $(info *** Not building any 3rdparty libs)
endif

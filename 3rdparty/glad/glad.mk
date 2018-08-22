# Project113 "3rdparty" subscript: GLAD
# For now just cheat and link it directly into P113.
GLAD_DIR          = $(3RDPARTY_DIR)/glad
GLAD_SRC          = $(GLAD_DIR)/glad.c
$(GLAD_SRC)_DEPS  = $(GLAD_DIR)/glad.h
P113_SRC_LIST    += $(GLAD_SRC)
BUILD_DIRS_LIST  += $(BUILD_DIR)/$(GLAD_DIR)

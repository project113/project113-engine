# Project113 sources subscript
P113_SRC_LIST            += $(SRC_DIR)/Engine.cxx  \
                            $(SRC_DIR)/ISystem.cxx

SRC_LIST                 += $(P113_SRC_LIST)
LIBS_BUILD_LIST          += $(PROJECT_NAME)
$(PROJECT_NAME)_LIB_OBJS  = $(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(P113_SRC_LIST)))
BUILD_DIRS_LIST          += $(BUILD_DIR)/$(SRC_DIR)


# Header (and other) dependency lists
# Most actual object targets and dependency rules are generated in the main
# Makefile (except for special cases requiring different build commands).
$(SRC_DIR)/Engine.cxx_DEPS  = $(P113_INCLUDE_DIR)/Engine.hxx
$(SRC_DIR)/ISystem.cxx_DEPS = $(P113_INCLUDE_DIR)/ISystem.hxx

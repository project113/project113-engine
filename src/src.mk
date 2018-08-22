# Project113 sources subscript
P113_SRC_LIST    += $(SRC_DIR)/Engine.cxx

SRC_LIST         += $(P113_SRC_LIST)
P113_OBJ_LIST    += $(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(P113_SRC_LIST)))
BUILD_DIRS_LIST  += $(BUILD_DIR)/$(SRC_DIR)


# Header (and other) dependency lists
# Most actual object targets and dependency rules are generated in the main
# Makefile (except for special cases requiring different build commands).
$(SRC_DIR)/Engine.cxx_DEPS = $(P113_INCLUDE_DIR)/Engine.hxx


# Add P113 library targets
ifdef BUILDING_SHARED_LIBS
  FINAL_TARGETS  += $(P113_SHARED_LIB)
endif

ifdef BUILDING_STATIC_LIBS
  FINAL_TARGETS  += $(P113_STATIC_LIB)
endif

$(P113_SHARED_LIB):	$(P113_OBJ_LIST)
	@$(ECHO)     LINK $@
	@$(SHLIB_LINK_CMD)

$(P113_STATIC_LIB):	$(P113_OBJ_LIST)
	@$(ECHO)     LINK $@
	@$(STATICLIB_LINK_CMD)

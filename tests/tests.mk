# Project113 Tests subscript
TESTS_BIN_DIR      = $(BIN_DIR)
BUILD_DIRS_LIST   += $(BUILD_DIR)/$(TESTS_DIR)

# If TESTS_BIN_DIR is overridden, make sure the dir is created if needed
ifneq ($(TESTS_BIN_DIR),$(BIN_DIR))
  BUILD_DIRS_LIST += $(TESTS_BIN_DIR)
endif


# Generate the test link/run rules, for now foolishly assuming that each test
# binary is derived from a single corresponding .cxx/object file. TODO: Fix that
define TEST_RULES =
  $(eval testsrc:=$(addprefix $(TESTS_DIR)/,$(addsuffix .cxx,$(test))))
  $(eval testobj:=$(addprefix $(BUILD_DIR)/,$(addsuffix .$(OBJ_EXT),$(testsrc))))
  $(eval testbin:=$(addprefix $(TESTS_BIN_DIR)/,$(addsuffix $(BIN_SUFFIX),$(test))))
  $(eval TESTS_BIN_LIST+=$(testbin))
  $(eval TESTS_RUN_LIST+=RUN_$(test))
  $(eval TESTS_SRC_LIST+=$(testsrc))

  $(testbin): $(testobj)
	@$(ECHO)   LINK  $(testbin)
	@$(TEST_LINK_CMD)

  .PHONY: RUN_$(test)
  RUN_$(test): $(testbin)
	@$(ECHO)   TEST  $(test)
	@$(testbin)
endef
$(foreach test,$(TESTS_LIST),$(eval $(TEST_RULES)))
SRC_LIST          += $(TESTS_SRC_LIST)


# Generic test targets
.PHONY: buildtests runtests
buildtests: $(TESTS_BIN_LIST)
	@$(ECHO) *** Finished building tests

runtests: $(TESTS_RUN_LIST)
	@$(ECHO) *** Finished running tests


# Add tests to default target if flagged to do so
ifeq ($(call lc,$(call substr,$(BUILD_TESTS),1,1)),y)
  FINAL_TARGETS   += $(TESTS_BIN_LIST)
endif

ifeq ($(call lc,$(call substr,$(RUN_TESTS),1,1)),y)
  all: runtests
endif

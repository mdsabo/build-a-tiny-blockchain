
# ----- TEST BUILDS -----
TEST_TARGET   := $(BINDIR)/$(PROJECT_NAME)-tests
TEST_AFLAGS   :=
TEST_CFLAGS   :=
TEST_CXXFLAGS :=
TEST_DEFINES  :=

# Any modules that define a test should be added to this list
TEST_MODULES  := \
	module

TEST_SRCS	  := $(PROJECT_PATH)/test/test.cpp
TEST_OBJS     := $(addsuffix .o, $(patsubst $(PROJECT_PATH)/test%, $(PROJECT_PATH)/test/obj%, $(TEST_SRCS)))
TEST_OBJDIR   := $(PROJECT_PATH)/test/obj
TEST_DEPLIBS  := $(foreach module, $(TEST_MODULES), $(OBJTOP)/$(module)/$(module).a)
TEST_DEPFILES := $(TEST_OBJS:.o=.d)

TESTS ?=
# -----------------------

.PHONY: $(TEST_DEPLIBS)

test: $(TEST_TARGET)
	@$(TEST_TARGET) $(TESTS)

$(TEST_TARGET): $(TEST_DEPLIBS) $(TEST_OBJS)
	$(LD) $(LDFLAGS) -o $(TEST_TARGET) $(TEST_OBJS) $(LIBFLAGS) $(TEST_DEPLIBS)

$(PROJECT_PATH)/test/obj/%.cpp.o: $(PROJECT_PATH)/test/%.cpp
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@
	$(info $(CXX) $(patsubst $(PROJECT_PATH)/%,%,$<))

$(BINDIR):
	@$(shell mkdir -p $(BINDIR))

$(TEST_OBJS): | $(TEST_OBJDIR) $(BINDIR)

$(TEST_OBJDIR):
	@$(shell mkdir -p $(TEST_OBJDIR))

$(TEST_DEPLIBS):
	@$(MAKE) -C $(addprefix $(PROJECT_PATH)/, $(patsubst %.a, %, $(subst -,/,$(notdir $@)))) -f module.mk -s

.PHONY: clean
clean:
	$(RM) -r $(TEST_OBJDIR)

-include $(TEST_DEPFILES)

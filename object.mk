
# This file is a general-purpose makefile that can be used to build a module given
# that is defines the proper variables before including this file
#
# Required Definitions: module, module.PATH, module.SRCS
# Optional Defines: module.INCLUDES, module.DEPS, module.DEFINES
#					module.AFLAGS, module.CFLAGS, module.CXXFLAGS
#					module.LDFLAGS
#

#modules build into $(PROJECT_PATH)/obj/$(module)
$(module).OBJTOP := $(PROJECT_PATH)/obj/$(module)
$(module).OBJS := $(addsuffix .o, $(patsubst $($(module).PATH)/src%, $($(module).OBJTOP)%, $($(module).SRCS)))
$(module).OBJDIRS := $(sort $(dir $($(module).OBJS)))
$(module).DEPFILES := $($(module).OBJS:.o=.d)

# modules correspond to a static library
$(module).TARGET := $($(module).OBJTOP)/$(module).a

#$(info Module: $(module))
#$(info Path: $($(module).PATH))
#$(info Includes: $($(module).INCLUDES))
#$(info Srcs: $($(module).SRCS))
#$(info Deps: $($(module).DEPS))
#$(info Incdeps: $($(module).INCDEPS))
#$(info AFlags: $($(module).AFLAGS))
#$(info CFlags: $($(module).CFLAGS))
#$(info CXXFlags: $($(module).CXXFLAGS))
#$(info DFlags: $($(module).DEFINES))
#$(info ObjTop: $($(module).OBJTOP))
#$(info Objs: $($(module).OBJS))
#$(info Objdirs: $($(module).OBJDIRS))
#$(info Target: $($(module).TARGET))

INCDEPDIRS := $(addsuffix /include, $(addprefix $(PROJECT_PATH)/, $(subst -,/,$($(module).DEPS) $($(module).INCDEPS))))
$(module).INCLUDES := $(addprefix -I, $($(module).INCLUDES) $(INCDEPDIRS) $(PROJECT_INCLUDES))
$(module).DEFINES := $(addprefix -D, $($(module).DEFINES))

$($(module).TARGET): $($(module).OBJS)
	@$(LIBTOOL) -static $($(module).LDFLAGS) -o $($(module).TARGET) $($(module).OBJS)

$($(module).OBJTOP)/%.s.o: $($(module).PATH)/src/%.s
	@$(AS) $(AFLAGS) $($(module).AFLAGS) $($(module).INCLUDES) $($(module).DEFINES) -c $< -o $@
	$(info $(AS)      $(patsubst $(PROJECT_PATH)/%,%,$<))

$($(module).OBJTOP)/%.c.o: $($(module).PATH)/src/%.c
	@$(CC) $(CFLAGS) $($(module).CFLAGS) $($(module).INCLUDES) $($(module).DEFINES) -c $< -o $@
	$(info $(CC)   $(patsubst $(PROJECT_PATH)/%,%,$<))

$($(module).OBJTOP)/%.cpp.o: $($(module).PATH)/src/%.cpp
	@$(CXX) $(CXXFLAGS) $($(module).CXXFLAGS) $($(module).INCLUDES) $($(module).DEFINES) -c $< -o $@
	$(info $(CXX) $(patsubst $(PROJECT_PATH)/%,%,$<))

$($(module).OBJS): | $($(module).OBJDIRS) # add order-only dep so it doesnt rebuild all objects every time diretcory is updated
$($(module).OBJDIRS):
	@$(shell mkdir -p $($(module).OBJDIRS))

-include $($(module).DEPFILES)

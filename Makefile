#
# 'make'        build executable file
# 'make run'    build and run the executable
# 'make clean'  removes all .o and executable files
# 'make test'	build and run all tests
#

#------ Project-wide Variables ------#

export PROJECT_PATH := $(shell pwd)
export PROJECT_NAME := $(notdir $(PROJECT_PATH))
export BINDIR := $(PROJECT_PATH)/bin
export OBJTOP := $(PROJECT_PATH)/obj

# define the compilers to use
export COMPILERDIR :=
export AS   := $(COMPILERDIR)as
export CC   := $(COMPILERDIR)clang
export CXX  := $(COMPILERDIR)clang++
export LD   := $(COMPILERDIR)clang++

# define static library tools/flags
export LIBTOOL  := libtool

# define any compile-time flags
GLOBAL_FLAGS    := -Qunused-arguments -MMD -MP
export AFLAGS   := $(GLOBAL_FLAGS)
export CFLAGS   := $(GLOBAL_FLAGS) -Wall
export CXXFLAGS := $(GLOBAL_FLAGS) -Wall -std=c++17
export DEFINES  :=
export LDFLAGS  := $(GLOBAL_FLAGS)

# Platform can be overriden on the command line to compile for somethign else
# Prevents having to change the makefile if the project is compiled on another
# platform
PLATFORM ?= APPLE
WIN32_LIBS :=
APPLE_LIBS :=
LINUX_LIBS :=

export LIBS :=

ifeq ($(PLATFORM), APPLE)
	LIBS += $(APPLE_LIBS)
else ifeq ($(PLATFORM), WIN32)
	LIBS += $(WIN32_LIBS)
else ifeq ($(PLATFORM), LINUX)
	LIBS += $(LINUX_LIBS)
endif

export PROJECT_INCLUDES := $(PROJECT_PATH)

#------ Top-level Module ------#

INCLUDES := -I$(PROJECT_PATH)/include

# define the C/C++/ASM source files
SRCS := \
	$(shell find $(PROJECT_PATH)/src -type f -name "*.s")   \
	$(shell find $(PROJECT_PATH)/src -type f -name "*.c")   \
	$(shell find $(PROJECT_PATH)/src -type f -name "*.cpp")

# List of all modules needed to build the executable
MODULES := module

# These modules are not considered dependencies but they are added to the include path
# This is especially useful for header only modules
INCMODULES :=

OBJS := $(addsuffix .o, $(patsubst $(PROJECT_PATH)/src%, $(PROJECT_PATH)/obj%, $(SRCS)))
OBJDIRS := $(sort $(dir $(OBJS)))
DEPS := $(OBJS:.o=.d)

# define the executable file
TARGET := $(BINDIR)/$(PROJECT_NAME)

DEPLIBS := $(foreach module, $(MODULES), $(OBJTOP)/$(module)/$(module).a)
INCDEPDIRS := $(addsuffix /include, $(addprefix $(PROJECT_PATH)/, $(subst -,/,$(MODULES) $(INCMODULES))))
INCLUDES += $(addprefix -I, $(INCDEPDIRS))
export LIBFLAGS := $(addprefix -l, $(LIBS))

# Just helps printing things
define NEWLINE

endef

.PHONY: run test clean $(DEPLIBS)
all: $(TARGET)

$(TARGET): $(DEPLIBS) $(OBJS)
	$(LD) $(LDFLAGS) -o $(TARGET) $(OBJS) $(LIBFLAGS) $(DEPLIBS)

$(PROJECT_PATH)/obj/%.s.o: $(PROJECT_PATH)/src/%.s
	@$(AS) $(AFLAGS) $(INCLUDES) -c $< -o $@
	$(info $(AS)      $(patsubst $(PROJECT_PATH)/%,%,$<))

$(PROJECT_PATH)/obj/%.c.o: $(PROJECT_PATH)/src/%.c
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@
	$(info $(CC)   $(patsubst $(PROJECT_PATH)/%,%,$<))

$(PROJECT_PATH)/obj/%.cpp.o: $(PROJECT_PATH)/src/%.cpp
	@$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@
	$(info $(CXX) $(patsubst $(PROJECT_PATH)/%,%,$<))

$(OBJS): $(SRCS) | $(OBJDIRS) $(BINDIR) # add order-only deps so it doesnt rebuild all objects every time diretcory is updated
$(OBJDIRS):
	@$(shell mkdir -p $(OBJDIRS))
$(BINDIR):
	@$(shell mkdir -p $(BINDIR))

$(DEPLIBS):
	@$(MAKE) -C $(addprefix $(PROJECT_PATH)/, $(patsubst %.a, %, $(subst -,/,$(notdir $@)))) -f module.mk -s

run: $(TARGET)
	@$(TARGET)

test:
	@$(MAKE) -C $(PROJECT_PATH)/test -f test.mk -s

clean:
	$(RM) -r obj/ $(BINDIR)
	@$(MAKE) -C $(PROJECT_PATH)/test -f test.mk clean

-include $(DEPS)

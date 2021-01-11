# include guard
# name should be relative-path-to-module.mk
ifndef module.mk
module.mk := 1

# module name
# format: relative-path-to-module
module := module

# Absolute path to this module
$(module).PATH := $(PROJECT_PATH)/module

# Directories to add to this module's include path
$(module).INCLUDES := \
	$($(module).PATH)/include

# define the C/C++/ASM source files
$(module).SRCS := \
	$(shell find $($(module).PATH)/src -type f -name "*.s")   \
	$(shell find $($(module).PATH)/src -type f -name "*.c")   \
	$(shell find $($(module).PATH)/src -type f -name "*.cpp")

# modules on which this module depends
# modules in this list are automatically added to the include path
$(module).DEPS :=

# Assembler flags
$(module).AFLAGS   :=
# C Compiler flags
$(module).CFLAGS   :=
# C++ Compiler Flags
$(module).CXXFLAGS :=
# Compiler Defines (e.g. -DMY_DEFINE=1)
$(module).DEFINES  :=

include $(PROJECT_PATH)/object.mk

endif
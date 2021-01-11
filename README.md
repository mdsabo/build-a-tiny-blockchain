# cxx-module-template
Module-based CXX Project Template

This template is meant as a base for medium and large C/C++/Assembly Projects.
It is based around encapsulation of code in modules which are then linked in the final executable.  Each module corresponds to a static library that is linked at build.

# Modules
Modules are a synonymous with libraries.  They define their own makefiles (module.mk) and are built independent of the main project.  However, for convenience the project is set up so that instead of building each module by itself, the developer just needs to build the project as a whole.  It is not possible to build a module by itself as the module.mk depends on some variables from the project makefile.

All modules must use the same basic structure:
```
module/
| include/
| src/
| module.mk
```

The makefile tree assumes that modules are structured like this in the build process.  Use the module.mk in the sample module directory as a base to set up new modules.

Module object files are placed in a subfolder of the top-level obj/ directory.  So for example, a module called "mymodule" will have its object files and the final static library placed under $(PROJECT_PATH)/obj/mymodule/.

# Tests
This template has basic support for a test framework.  Modules can include test/test.h to add tests to the framework.  Tests are then enabled in test/test.cpp and will be run automatically with 'make test'. An example is included in the template.
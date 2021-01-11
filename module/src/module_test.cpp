
#include <test/test.h>

extern "C" {
    #include "module.h"
}

TEST_DEFINE(module_test)
{
    module_print();

    TEST_FINISH();
}
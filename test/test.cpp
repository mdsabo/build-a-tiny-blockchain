
#include "test.h"

/*TEST_DEFINE(mytest)
{
    TEST_ASSERT(true);

    TEST_FINISH();
}

TEST_DEFINE(mytest2)
{
    TEST_ASSERT(false);

    TEST_FINISH();
}*/

int main(int argc, char* argv[])
{
    TEST_INIT();

    // ∨∨∨∨∨ ENABLE TESTS HERE ∨∨∨∨∨
    //TEST_ENABLE(mytest);
    //TEST_ENABLE(mytest2);

    TEST_ENABLE(module_test);
    // ∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧∧

    if (argc > 0) { RUN_SELECTED(argc, argv); }
    else { RUN_ENABLED(); }

    SUMMARIZE();
}
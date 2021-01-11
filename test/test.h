
#ifndef TEST_H_
#define TEST_H_

#include <map>
#include <string>
#include <iostream>

// --- DO NOT MODIFY THESE DEFINITIONS ---

#define TERM_RED            "\033[0;31m"
#define TERM_GREEN          "\033[0;32m"
#define TERM_RESET          "\033[0m"

typedef int test_result_t;
typedef std::map<std::string, int(*)()> test_set_t;

// Source files define tests with this macro
#define TEST_DEFINE(func)   test_result_t func()
// Tests can test conditions using this assertion
#define TEST_ASSERT(expr) TEST_ASSERT_WRAP(expr, #expr, __LINE__ , __FILE__)
#define TEST_ASSERT_WRAP(expr, sexpr, line, func)       \
    if (!static_cast<bool>(expr))                       \
    {                                                   \
        std::cout << TERM_RED                           \
                  << "TEST_ASSERT("                     \
                  << sexpr                              \
                  << ") Failed"                         \
                  << std::endl                          \
                  << "Line "                            \
                  << line                               \
                  << " of "                             \
                  << func                               \
                  << TERM_RESET                         \
                  <<std::endl;                          \
        return -1;                                      \
    }
// All tests need to call this to return
#define TEST_FINISH() return 0;

// Tests need to be enabled in tests.cpp using this macro
#define TEST_ENABLE(func)                   \
    extern test_result_t func();            \
    tests[#func] = func;

#define TEST_PASSED(func)                   \
    tests_passed++;                         \
    std::cout << TERM_GREEN                 \
              << func                       \
              << " Passed"                  \
              << TERM_RESET                 \
              << std::endl;

#define TEST_FAILED(func)                   \
    std::cout << TERM_RED                   \
              << func                       \
              << " Failed"                  \
              << TERM_RESET                 \
              << std::endl;

#define TEST_RUN(name, func)                \
    std::cout << "Running Test ("           \
              << current_test               \
              << "/"                        \
              << num_tests                  \
              << "): "                      \
              << name                       \
              << std::endl;                 \
    if (func() == 0) { TEST_PASSED(name);}  \
    else { TEST_FAILED(name); }             \
    current_test++;

#define TEST_INIT()                         \
    test_set_t tests;                       \
    unsigned int tests_passed{0};           \
    unsigned int current_test{1};           \
    unsigned int num_tests{0};              \
    unsigned int tests_skipped{0};          \
    argc--; // adjust for exe name

#define RUN_SELECTED(argc, argv)            \
    num_tests = argc;                       \
    for (int i = 0; i < argc; i++)          \
    {                                       \
        std::string s{argv[i+1]};           \
        if (tests.find(s) == tests.end())   \
        {                                   \
            std::cout << TERM_RED           \
                      << "No test named "   \
                      << s                  \
                      << TERM_RESET         \
                      << std::endl;         \
            tests_skipped++;                \
            continue;                       \
        }                                   \
        TEST_RUN(s, tests[s]);              \
    }

#define RUN_ENABLED()                       \
    num_tests = tests.size();               \
    for (auto const& [name, f] : tests)     \
    { TEST_RUN(name, f); }

#define SUMMARIZE()                         \
    std::cout << "Test Result: "            \
              << tests_passed               \
              << "/"                        \
              << num_tests                  \
              << " Passed";                 \
    if (tests_skipped)                      \
    {                                       \
        std::cout << ", "                   \
                  << tests_skipped          \
                  << " Skipped";            \
    }                                       \
    std::cout << std::endl;

#endif

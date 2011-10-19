/**
 * @file  test_stdaux.cxx
 * @brief Test stdaux.cxx module.
 *
 * Copyright (c) 2011 University of Pennsylvania. All rights reserved.
 * See https://www.rad.upenn.edu/sbia/software/license.html or COPYING file.
 *
 * Contact: SBIA Group <sbia-software at uphs.upenn.edu>
 */

#include <sbia/basis/test.h>       // unit testing framework
#include "stdaux.h"                // testee

#include <sbia/basis/exceptions.h> // SubprocessException
#include <vector>
#include <string>


using namespace SBIA_UTILITIESTEST_NAMESPACE;
using namespace std;
using sbia::basis::SubprocessException;


// ---------------------------------------------------------------------------
// Test exception when execute_process() is not used as intended.
TEST(StdAux, ExecuteProcessInvalidUse)
{
    vector<string> argv;
    EXPECT_THROW(execute_process(""), SubprocessException);
    EXPECT_THROW(execute_process(argv), SubprocessException);
}

// ---------------------------------------------------------------------------
// Test execution of executable target.
TEST(StdAux, ExecuteTarget)
{
    vector<string> args;
    int status;
    std::ostringstream output;
    EXPECT_NO_THROW(status = execute_process("basis::dummy_command"));
    EXPECT_EQ(0, status) << "exit code of basis::dummy_command is 0";
    EXPECT_NO_THROW(status = execute_process("basis::dummy_command --greet", true, &output));
    EXPECT_EQ(0, status) << "exit code of basis::dummy_command --greet is 0";
    EXPECT_STREQ("Hello, BASIS!\n", output.str().c_str());
    args.clear();
    output.str("");
    args.push_back("basis::dummy_command");
    args.push_back("--warn");
    EXPECT_NO_THROW(status = execute_process(args, true, &output));
    EXPECT_EQ(0, status) << "exit code of basis::dummy_command --warn is 0";
    EXPECT_STREQ("WARNING: Cannot greet in other languages!\n", output.str().c_str());
}

// ---------------------------------------------------------------------------
// Test execution of some non-target command.
TEST(StdAux, ExecuteCommand)
{
#if WINDOWS
    const string args = "dir C:/";
#else
    const string args = "ls /";
#endif
    int status;
    std::ostringstream output;
    EXPECT_NO_THROW(status = execute_process(args, true, &output));
    EXPECT_EQ(0, status) << "exit code of dir or ls is 0";
    EXPECT_STRNE("", output.str().c_str()) << "output of dir or ls is not empty";
}
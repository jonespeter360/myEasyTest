OutputName = tests
TEST_NAME = testSuite.cpp
EXE = $(OutputName).out
LOG = $(OutputName).log
GTEST_DIR = ./googletest/googletest
TEST_FLAGS = -isystem $(GTEST_DIR)/include -pthread
TEST_LIB = $(GTEST_DIR)/libgtest.a

.PHONY = all build debug run test gTest runTests

# runs the exe
run: all
	./$(EXE)

# builds the executable
all: build
	@g++ -Wall -Werror -std=c++11 -o $(EXE) *.o 2> $(LOG)

# debugs the executable
debug: all
	gdb ./$(EXE)
	
# creates the object files
build:
	@g++ -g -c *.cpp 2> $(LOG)

# runs the unit tests:
runTests: gTest build_test test

test: build_test
	@./$(EXE)

build_test:
	@g++ $(TEST_FLAGS) $(TEST_NAME) $(TEST_LIB) -o $(EXE)

# makes the googletest framework, so that we can write our own tests:
gTest:
	@g++ -isystem $(GTEST_DIR)/include -I$(GTEST_DIR) -pthread -c $(GTEST_DIR)/src/gtest-all.cc
	@ar -rv $(GTEST_DIR)/libgtest.a gtest-all.o
	@rm gtest-all.o > /dev/null

cmake_minimum_required(VERSION 3.21)
project(CS3 C ASM)

#set(CMAKE_C_STANDARD 99)

set(GCC_COVERAGE_COMPILE_FLAGS "-no-pie")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${GCC_COVERAGE_COMPILE_FLAGS}")
#add_executable(CS3 run_main-test.c main.c func_select.s pstring.h pstrings.s)
add_executable(CS3 run_main-test.c main.c func_select.s pstring.h pstrings.s)



#add_executable(your_project_name main.c hello.s)

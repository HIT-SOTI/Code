cmake_minimum_required(VERSION 3.22)
project(Parsing)

set(CMAKE_CXX_STANDARD 14)

add_executable(Parsing main.cpp Symbol.cpp Symbol.h GenerateExpression.cpp GenerateExpression.h Item.cpp Item.h Items.cpp Items.h Direction.cpp Direction.h Act.cpp Act.h Parser.cpp Parser.h Utils.cpp Utils.h)

cmake_minimum_required(VERSION 3.10)

project(VPN)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED YES)

#add_subdirectory(Bong)

add_executable(VPN

   include/application.h
   include/slavemanager.h

   src/slavemanager.cpp
   src/slave.cpp
   src/application.cpp

main.cpp
)

target_include_directories(VPN PRIVATE)
target_link_libraries(VPN PRIVATE)

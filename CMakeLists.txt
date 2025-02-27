cmake_minimum_required(VERSION 3.10)

project(VPN)

set(CMAKE_CXX_STANDARD 20)

add_subdirectory(Bong)

add_executable(VPN
    main.cpp
)

target_include_directories(VPN PRIVATE Bong)
target_link_libraries(VPN PRIVATE BongLibrary)

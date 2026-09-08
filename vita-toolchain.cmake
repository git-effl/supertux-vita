set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-vita-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-vita-eabi-g++)
set(CMAKE_AR arm-vita-eabi-ar)
set(CMAKE_RANLIB arm-vita-eabi-ranlib)

set(CMAKE_C_FLAGS "-mcpu=cortex-a9 -mtune=cortex-a9 -march=armv7-a -Wl,-q -O2")
set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS}")

set(CMAKE_FIND_ROOT_PATH $ENV{VITASDK}/arm-vita-eabi)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

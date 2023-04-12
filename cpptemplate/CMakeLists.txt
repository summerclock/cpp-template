project(cpptemplate)

set(Header_Files "cpptemplate.hpp")
set(Source_Files "cpptemplate.cpp")
set(ALL_FILES ${Header_Files} ${Source_Files})
set(TEST_NAME "${PROJECT_NAME}_test")
set(TEST_FILE "cpptemplate.test.cpp")

add_library(${PROJECT_NAME} SHARED ${ALL_FILES})
target_compile_definitions(${PROJECT_NAME} PRIVATE BUILDING_DLL)

target_include_directories(
  ${PROJECT_NAME} PUBLIC ${OpenCV_INCLUDE_DIRS} ${Boost_INCLUDE_DIRS}
                         ${EIGEN3_INCLUDE_DIRS}
)

target_link_libraries(${PROJECT_NAME} glog::glog TBB::tbb)

add_executable(${TEST_NAME} ${TEST_FILE})

target_link_libraries(${TEST_NAME} PUBLIC ${PROJECT_NAME} CLI11::CLI11)

if(MSVC)
  add_custom_command(
    TARGET ${TEST_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:${TEST_NAME}>
            $<TARGET_FILE_DIR:${TEST_NAME}>
    COMMAND_EXPAND_LISTS
  )
endif()

install(
  TARGETS ${PROJECT_NAME}
  CONFIGURATIONS Release
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

message("Project ${PROJECT_NAME}")

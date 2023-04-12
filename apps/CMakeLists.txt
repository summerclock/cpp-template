project(cpptemplate-bin)
set(Lib_Name "cpptemplate")
set(Bin_Name "cpptemplate")
set(ALL_FILES "cpptemplate.bin.cpp")
add_executable(${PROJECT_NAME} ${ALL_FILES})
target_include_directories(
  ${PROJECT_NAME} PUBLIC ${Boost_INCLUDE_DIRS} "${CMAKE_SOURCE_DIR}"
)
target_link_libraries(
  ${PROJECT_NAME} PUBLIC ${Lib_Name} glog::glog CLI11::CLI11 TBB::tbb
)

if(MSVC)
  add_custom_command(
    TARGET ${PROJECT_NAME}
    POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_RUNTIME_DLLS:cpptemplate-bin>
            $<TARGET_FILE_DIR:cpptemplate-bin>
    COMMAND_EXPAND_LISTS
  )
endif()

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${Bin_Name})
install(
  TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)
message("Project ${PROJECT_NAME}")

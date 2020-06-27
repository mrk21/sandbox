add_executable(main main.cpp native_plugin/generator.cpp)
target_include_directories(main PUBLIC ${vendor_product_INCLUDE_DIRS})
target_link_libraries(main ${vendor_product_LIBRARIES})

if (APPLE)
  add_library(NativePlugin MODULE plugin.cpp native_plugin/generator.cpp)
  set_target_properties(NativePlugin PROPERTIES BUNDLE TRUE)

  install(
    DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Debug/NativePlugin.bundle"
    DESTINATION x86_64
  )
else()
  add_library(NativePlugin SHARED plugin.cpp native_plugin/generator.cpp)

  install(
    TARGETS NativePlugin
    DESTINATION x86_64
  )
endif()

target_include_directories(NativePlugin PUBLIC ${vendor_product_INCLUDE_DIRS})
target_link_libraries(NativePlugin ${vendor_product_LIBRARIES})

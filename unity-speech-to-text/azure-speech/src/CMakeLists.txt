add_executable(main main.cpp azure_speech/recognizer.cpp)
target_include_directories(main PUBLIC ${vendor_product_INCLUDE_DIRS})
target_link_libraries(main ${vendor_product_LIBRARIES})

if (APPLE)
  add_library(AzureSpeech MODULE plugin.cpp azure_speech/recognizer.cpp)
  set_target_properties(AzureSpeech PROPERTIES BUNDLE TRUE)

  install(
    DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/Release/AzureSpeech.bundle"
    DESTINATION x86_64
  )
else()
  add_library(AzureSpeech SHARED plugin.cpp azure_speech/recognizer.cpp)

  install(
    TARGETS AzureSpeech
    DESTINATION x86_64
  )
endif()

target_include_directories(AzureSpeech PUBLIC ${vendor_product_INCLUDE_DIRS})
target_link_libraries(AzureSpeech ${vendor_product_LIBRARIES})

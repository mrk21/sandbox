# -----------------------------------------------------------------------------
# Custom target
# -----------------------------------------------------------------------------
add_custom_target(vendor)
add_custom_target(vendor_product)
add_custom_target(vendor_develop)

add_dependencies(vendor vendor_develop)
add_dependencies(vendor_develop vendor_product)

# -----------------------------------------------------------------------------
# Libraries
# -----------------------------------------------------------------------------
## boost
append_project_var(vendor_product_INCLUDE_DIRS ${Boost_INCLUDE_DIRS})
append_project_var(vendor_product_LIBRARIES ${Boost_LIBRARIES})

## MicrosoftCognitiveServicesSpeech
if(APPLE)
  find_library(
    MICROSOFT_COGNITIVE_SERVICES_SPEECH
    NAMES MicrosoftCognitiveServicesSpeech
    PATHS ${PROJECT_SOURCE_DIR}/vendor/MicrosoftCognitiveServicesSpeech
  )
  message(${MICROSOFT_COGNITIVE_SERVICES_SPEECH})
  append_project_var(vendor_product_LIBRARIES ${MICROSOFT_COGNITIVE_SERVICES_SPEECH})
endif()

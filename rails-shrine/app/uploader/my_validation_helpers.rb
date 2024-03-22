module MyValidationHelpers
  def self.load_dependencies(uploader, *)
    uploader.plugin :validation
  end

  module AttacherMethods
    def validate_mime_type(types)
      unless types.include?(file.mime_type)
        errors << [:invalid_mime_type, value: file.mime_type, valid_types: types.join(', ')]
      end
    end
  end
end

Shrine::Plugins.register_plugin(:my_validation_helpers, MyValidationHelpers)

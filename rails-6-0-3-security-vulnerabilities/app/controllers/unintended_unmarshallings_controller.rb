class UnintendedUnmarshallingsController < ApplicationController
  class DummyObject
    def initialize
      puts '#'*100
    end
  end

  def edit
    @current_data = Rails.cache.fetch('current_data') rescue Rails.cache.fetch('current_data', raw: true)
    @new_data = Marshal.dump(DummyObject.new)
  end

  def create
    # NOTE: When `Rails.cache.write()` was specified marshaled value with `raw: true` option, `Rails.cache.read()` constructs Ruby object by unmarshaling, so user can inject any Ruby object.
    # @see [[CVE-2020-8165] Potentially unintended unmarshalling of user-provided objects in MemCacheStore and RedisCacheStore - Google グループ](https://groups.google.com/forum/#!topic/rubyonrails-security/bv6fW4S0Y1c)
    Rails.cache.delete('current_data')
    Rails.cache.fetch('current_data', raw: true) { params[:new_data] }
    redirect_to edit_unintended_unmarshalling_path
  end
end

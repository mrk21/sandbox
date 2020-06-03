class UnintendedUnmarshallingsController < ApplicationController
  def edit
    @current_data = Rails.cache.read('current_data') rescue Rails.cache.read('current_data', raw: true)
    @new_data = Marshal.dump({a: 1})
  end

  def create
    # NOTE: When `Rails.cache.write()` was specified marshaled value with `raw: true` option, `Rails.cache.read()` constructs Ruby object by unmarshaling, so user can inject any Ruby object.
    # @see [[CVE-2020-8165] Potentially unintended unmarshalling of user-provided objects in MemCacheStore and RedisCacheStore - Google グループ](https://groups.google.com/forum/#!topic/rubyonrails-security/bv6fW4S0Y1c)
    Rails.cache.write('current_data', params[:new_data], raw: true)
    redirect_to edit_unintended_unmarshalling_path
  end
end

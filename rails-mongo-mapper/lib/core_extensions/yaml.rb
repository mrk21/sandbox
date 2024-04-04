# [Ruby で YAML のエイリアスが使えなくなった？ #Ruby - Qiita](https://qiita.com/scivola/items/da2e4687726fb20953c0)
module YAMLForceAliasEnabled
  def load(*args, **kargs)
    kargs[:aliases] = true
    super(*args, **kargs)
  end
end

YAML.singleton_class.prepend(YAMLForceAliasEnabled)

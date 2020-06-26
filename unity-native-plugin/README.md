# Unity native plugin

## Dependencies

* Unity 2019.4.0f1

### Native Plugin

* C++ 17 Compiler
  * Apple Clang: >= 10.0
* CMake: >= 3.10.0

## Setup

```sh
# 1. Build native plugin
cd native-plugin
mkdir build
cd build
cmake .. -G Xcode
cmake --build . --config Release
cmake --install .
```

## Refer to

- [ネイティブプラグインから Unity の関数（Debug.Log 等）を呼び出す - 凹みTips](http://tips.hecomi.com/entry/2016/01/05/230405)
- [Unityネイティブプラグインマニアクス #denatechcon](https://www.slideshare.net/dena_tech/unity-denatechcon)
- [[Unity] C#とObjective-Cの連携まとめ - Qiita](https://qiita.com/tkyaji/items/74d485a021c75ed10bca#objective-c%E3%81%AE%E3%82%A4%E3%83%B3%E3%82%B9%E3%82%BF%E3%83%B3%E3%82%B9)
- [Unity Native PluginでC++の処理を非同期に呼び出す - かみのメモ](https://kamino.hatenablog.com/entry/unity_native_plugin)

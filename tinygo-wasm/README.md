# TinyGo WebAssembly

## Dependencies

- Go: 1.21.x
- TinyGo: 0.30.x
- Node.js: 20.x
- direnv

## Setup

```sh
# Install TinyGo
brew tap tinygo-org/tools
arch -arm64 brew install tinygo

# Install wasm tools
brew install wabt
brew install wasmer
brew install wasmtime

# Enable direnv
direnv allow .

# Install npm modules
npm install
```

## Start

```sh
go generate
npm run dev
open http://localhost:5173/
```

## Memo

Node.js project creation by vite

```sh
$ npm create vite@latest
...
cd tinygo-wasm/
npm install
```

## References

- [tinygo-org/tinygo: Go compiler for small places. Microcontrollers, WebAssembly (WASM/WASI), and command-line tools. Based on LLVM.](https://github.com/tinygo-org/tinygo)
- [GoのWebAssemblyで、Node.jsからGo内の関数を実行する - Kajindows XP](https://kajindowsxp.com/go-tinygo-webassembly/)
- [Adafruit MacroPad RP2040 Starter KitとTinyGoでLチカ](https://zenn.dev/nkmrkz/articles/tinygo-get-start)
- [GoのWebAssemblyで、Node.jsからGo内の関数を実行する - Kajindows XP](https://kajindowsxp.com/go-tinygo-webassembly/)
- [TinyGoを使ってexportした関数の引数と返り値にstringを使う方法 - Kajindows XP](https://kajindowsxp.com/go-tinygo-webassembly-string/)

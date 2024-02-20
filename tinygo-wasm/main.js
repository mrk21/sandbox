import '@tinygo/targets/wasm_exec';

async function callWasm() {
  const go = new Go();
  const obj = await WebAssembly.instantiateStreaming(fetch("main.wasm"), go.importObject);
  const wasm = obj.instance;
  go.run(wasm);

  console.log(wasm.exports.add(2,3));
  {
    const text = "Hello World!";
    const [addr, length] = writeBuffer(text, wasm);
    const result = wasm.exports.stringFromJS(addr, length);
    console.log(result);
  }
  {
    const addr = wasm.exports.stringToJS();
    const length = wasm.exports.getBufSize();
    const result = readBuffer(addr, length, wasm);
    console.log(result);
  }
}

function readBuffer(addr, size, module) {
  let memory = module.exports.memory;
  let bytes = memory.buffer.slice(addr, addr + size);
  let text = String.fromCharCode.apply(null, new Int8Array(bytes));
  return text;
}

function writeBuffer(text, module) {
  const addr = module.exports.getBuffer();
  const buffer = module.exports.memory.buffer;

  const mem = new Int8Array(buffer);
  const view = mem.subarray(addr, addr + text.length);

  for (let i = 0; i < text.length; i++) {
    view[i] = text.charCodeAt(i);
  }

  return [addr, text.length];
}

callWasm();

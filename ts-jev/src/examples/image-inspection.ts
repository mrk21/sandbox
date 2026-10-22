// 画像判定 (experimental): 写真に写っているのが編みぐるみかどうかを判定し、編みぐるみなら位置も特定する (box は jev-preview)
// usage: op run -- node src/examples/image-inspection.ts path/to/photo.jpg
import { openAsBlob } from "node:fs";
import { BadRequestError, box, choice, image, noul, TypeSafeClient } from "@typesafe-ai/sdk";

const path = process.argv[2];
if (!path) {
  console.error("usage: node src/examples/image-inspection.ts <photo.(jpg|png)>");
  process.exit(1);
}

const client = new TypeSafeClient({
  defaultHeaders: { "TypeSafe-Danger-Zone-Images": "true" },
});
const photo = image(await openAsBlob(path));

const { answers } = await client
  .systemOne({
    state: photo,
    questions: {
      amigurumi: noul("この写真の主な被写体は編みぐるみですか？", {
        true: "毛糸をかぎ針編みや棒針編みで作った小さなぬいぐるみで、編み目が見えるもの",
        false: "それ以外のもの（布製のぬいぐるみ、フェルトのおもちゃ、フィギュア、本物の動物など）",
      }),
      kind: choice("この写真の主な被写体は何ですか？", {
        amigurumi: "毛糸で編んだぬいぐるみ",
        plush: "布・フリース・フェルトを縫って作ったぬいぐるみ",
        figure: "プラスチック・ソフビ・木でできたフィギュア、人形、おもちゃ",
        animal: "本物の生きた動物",
        other: null,
      }),
    },
  })
  .catch((error: unknown) => {
    // スマホ写真 (例: 3024x4032) をそのまま送ると "Invalid image dimensions." で 400 になる
    if (error instanceof BadRequestError && JSON.stringify(error.body).includes("dimensions")) {
      console.error(`画像サイズが大きすぎます。縮小してから再実行してください: sips -Z 1024 ${path} --out small.jpg`);
      process.exit(1);
    }
    throw error;
  });

const isAmigurumi = answers.amigurumi.noul > 0.5;
console.log(isAmigurumi ? "編みぐるみです" : "編みぐるみではありません", `(p=${answers.amigurumi.noul.toFixed(2)})`);
console.log("kind:", answers.kind.choice, answers.kind.probabilities);

if (isAmigurumi) {
  const located = await client.systemOne({
    state: photo,
    questions: { amigurumi: box("編みぐるみ（毛糸で編んだぬいぐるみ）") },
    model: "jev-preview",
  });
  const { top, bottom, left, right } = located.answers.amigurumi.box;
  console.log("amigurumi box (fractions):", { top, bottom, left, right }, "confidence:", located.answers.amigurumi.confidence);
}

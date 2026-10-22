// プロンプトの言語比較: 同じ画像に対して、日本語と英語の質問・判定基準で結果がどう変わるかを見る
// usage: op run -- node src/examples/prompt-language.ts path/to/photo.jpg
import { openAsBlob } from "node:fs";
import { choice, image, noul, TypeSafeClient } from "@typesafe-ai/sdk";

const path = process.argv[2];
if (!path) {
  console.error("usage: node src/examples/prompt-language.ts <photo.(jpg|png)>");
  process.exit(1);
}

const client = new TypeSafeClient({
  defaultHeaders: { "TypeSafe-Danger-Zone-Images": "true" },
});
const photo = image(await openAsBlob(path));

const prompts = {
  en: {
    amigurumi: noul("Is the main subject of this photo an amigurumi?", {
      true: "A small stuffed toy crocheted or knitted from yarn, with visible stitches or loops",
      false: "Anything else, including sewn fabric plushies, felt toys, figures, or real animals",
    }),
    kind: choice("What is the main subject of this photo?", {
      amigurumi: "A crocheted or knitted stuffed toy made of yarn",
      plush: "A stuffed toy sewn from fabric, fleece, or felt",
      figure: "A figure, doll, or toy made of plastic, vinyl, or wood",
      animal: "A real, living animal",
      other: null,
    }),
  },
  ja: {
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
};

for (const [lang, questions] of Object.entries(prompts)) {
  const { answers, usage } = await client.systemOne({ state: photo, questions });
  console.log(lang, {
    amigurumi: answers.amigurumi.noul.toFixed(2),
    kind: answers.kind.choice,
    probabilities: answers.kind.probabilities,
    usage,
  });
}

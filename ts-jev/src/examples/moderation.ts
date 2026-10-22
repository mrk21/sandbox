// 投稿モデレーション: 構造化 state + criteria 付き noul / choice で、しきい値ベースに自動判定する
import { choice, noul, TypeSafeClient } from "@typesafe-ai/sdk";

const client = new TypeSafeClient();

const posts = [
  { id: "p1", author: "user_102", body: "この店のラーメン最高でした！また行きます。" },
  { id: "p2", author: "user_877", body: "副業で月100万確実！詳しくはLINE追加 → line.example/xxxx" },
  { id: "p3", author: "user_331", body: "お前の住所特定したからな。覚悟しとけよ。" },
];

for (const post of posts) {
  const { answers } = await client.systemOne({
    state: { post },
    questions: {
      spam: noul("この投稿はスパムですか？", {
        true: "一方的な宣伝、詐欺、簡単に儲かるといった勧誘、外部の連絡先（LINE など）への誘導",
        false: "実際のユーザーによる普通の投稿",
      }),
      threat: noul("この投稿は誰かを脅迫したり嫌がらせしたりしていますか？"),
      action: choice("モデレーターはこの投稿をどう扱うべきですか？", {
        publish: "問題なく、そのまま公開してよい",
        review: "判断が難しく、人のモデレーターによる確認が必要",
        remove: "明らかにルール違反で、すぐに削除すべき",
      }),
    },
  });

  // noul は確率 (0〜1) なので、用途に合わせてしきい値を決める
  const flags = [answers.spam.noul > 0.8 && "spam", answers.threat.noul > 0.5 && "threat"].filter(Boolean);
  console.log(`${post.id}: ${answers.action.choice} (${answers.action.confidence.toFixed(2)})`, flags);
}

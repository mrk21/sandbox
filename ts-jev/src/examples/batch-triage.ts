// 大量データの一括分類: 並列数を制限しつつ問い合わせを振り分け、確信度が低いものだけ人に回す
import { choice, RateLimitError, score, TypeSafeClient } from "@typesafe-ai/sdk";

const client = new TypeSafeClient({ retry: { maxRetries: 4 } });

const inquiries = [
  "ログインしようとするとエラー500が出ます。",
  "請求書の宛名を会社名に変更したいです。",
  "解約したいのですが、違約金はかかりますか？",
  "APIのレート制限を上げてもらうことは可能ですか？",
  "先月から二重に引き落とされています。至急対応してください。",
  "御社のサービスを導入検討中です。見積もりをお願いできますか。",
];

const questions = {
  team: choice("この問い合わせはどのチームが対応すべきですか？", {
    support: "技術的な問題、不具合、エラー、API の使い方",
    billing: "請求書、支払い、返金、解約金",
    sales: "新規契約、見積もり、プランのアップグレード",
  }),
  priority: score("この問い合わせの緊急度はどのくらいですか？", ["低", "中", "高"]),
};

async function classify(text: string) {
  const { answers } = await client.systemOne({ state: { inquiry: text }, questions });
  return { text, team: answers.team.choice, confidence: answers.team.confidence, priority: answers.priority.score };
}

// 簡易的な並列数制限 (同時 3 リクエスト)
async function mapLimit<T, R>(items: T[], limit: number, fn: (item: T) => Promise<R>): Promise<R[]> {
  const results: R[] = new Array(items.length);
  let next = 0;
  const workers = Array.from({ length: limit }, async () => {
    while (next < items.length) {
      const i = next++;
      results[i] = await fn(items[i]!);
    }
  });
  await Promise.all(workers);
  return results;
}

try {
  const results = await mapLimit(inquiries, 3, classify);
  for (const r of results.sort((a, b) => b.priority - a.priority)) {
    const route = r.confidence < 0.7 ? "human-review" : r.team;
    console.log(`[${r.priority.toFixed(1)}] ${route.padEnd(12)} ${r.text}`);
  }
} catch (error) {
  if (error instanceof RateLimitError) console.error("rate limited; retry after", error.retryAfterMs, "ms");
  throw error;
}

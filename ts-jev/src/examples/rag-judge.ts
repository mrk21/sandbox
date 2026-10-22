// LLM-as-a-judge: RAG の回答を、根拠への忠実度・質問への関連度でスコアリングする
import { noul, score, TypeSafeClient } from "@typesafe-ai/sdk";

const client = new TypeSafeClient();

const sample = {
  question: "有給休暇は入社何ヶ月後から取得できますか？",
  context: [
    "就業規則 第20条: 入社日から6ヶ月間継続勤務し、全労働日の8割以上出勤した従業員に10日の年次有給休暇を付与する。",
    "就業規則 第21条: 有給休暇の申請は原則として3営業日前までに行うこと。",
  ],
  answer: "入社から3ヶ月後に10日間の有給休暇が付与されます。",
};

const { answers, usage } = await client.systemOne({
  state: sample,
  questions: {
    faithfulness: score("回答は参照資料（context）の内容に裏付けられていますか？", [
      "参照資料と矛盾している",
      "ほとんど裏付けがない、または一部が矛盾している",
      "一部は裏付けられている",
      "すべて参照資料に裏付けられている",
    ]),
    relevance: score("回答は質問に答えていますか？", ["質問と関係ない", "部分的に答えている", "質問に直接答えている"]),
    hallucination: noul("回答に、参照資料にない事実や参照資料と矛盾する事実が含まれていますか？"),
  },
});

// score は期待値 (小数) を返す。legend で各レベルの説明も取れる
console.log("faithfulness:", answers.faithfulness.score.toFixed(2), "/ 3", answers.faithfulness.probabilities);
console.log("relevance:", answers.relevance.score.toFixed(2), "/ 2");
console.log("hallucination:", answers.hallucination.noul.toFixed(2));
console.log("usage:", usage);

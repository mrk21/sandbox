import { choice, noul, score, TypeSafeClient } from "@typesafe-ai/sdk";

const client = new TypeSafeClient();

const { answers } = await client.systemOne({
  state: { document: "I was charged twice for invoice INV-2291. Please refund the duplicate ASAP." },
  questions: {
    category: choice("What is this ticket about?", {
      billing: null,
      technical: null,
      other: null,
    }),
    refund: noul("Is the customer asking for money back?"),
    urgency: score("How urgent is this ticket?", ["low", "medium", "high"]),
  },
});

console.log("category:", answers.category.choice, answers.category.probabilities);
console.log("refund:", answers.refund.noul);
console.log("urgency:", answers.urgency.score, answers.urgency.probabilities);

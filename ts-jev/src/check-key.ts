import { AuthenticationError, TypeSafeClient } from "@typesafe-ai/sdk";

const client = new TypeSafeClient();

try {
  const models = await client.models.list();
  console.log(models.map((model) => model.name));
} catch (error) {
  if (error instanceof AuthenticationError) {
    console.error(`TypeSafe rejected the key (${error.status}). Check TYPESAFE_API_KEY.`);
    process.exitCode = 1;
  } else {
    throw error;
  }
}

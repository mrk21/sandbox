import { useRouter } from "next/router";
import { useRef } from "react";
import AppLayout from "@/components/AppLayout";
import { confirmCognitoRegistration } from "@/libs/cognito";

const Verify: React.FC = () => {
  const router = useRouter();
  const refEmail = useRef<HTMLInputElement>(null);
  const refCode = useRef<HTMLInputElement>(null);

  const submitHandler = async () => {
    if (!refCode.current?.value) {
      alert("Code is Empty");
      return;
    }
    if (!refEmail.current?.value) {
      alert("Email is Empty");
      return;
    }
    try {
      await confirmCognitoRegistration({
        username: refEmail.current.value,
        code: refCode.current.value,
      });
      router.push("/session/signin");
    } catch (e) {
      alert(JSON.stringify(e));
    }
  };

  return (
    <AppLayout>
      <h2>User Verification</h2>
      <div>
        <div>
          <label>E-mail:</label>
          <input type="text" ref={refEmail} />
        </div>
        <div>
          <label>Code:</label>
          <input type="text" ref={refCode} />
        </div>
        <div>
          <button onClick={submitHandler}>Confirm</button>
        </div>
      </div>
    </AppLayout>
  );
};

export default Verify;

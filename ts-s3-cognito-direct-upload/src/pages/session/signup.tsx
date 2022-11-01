import { useRouter } from "next/router";
import { useRef } from "react";
import AppLayout from "@/components/AppLayout";
import { signUpCognito } from "@/libs/cognito";

const SignUp: React.FC = () => {
  const refEmail = useRef<HTMLInputElement>(null);
  const refPassword = useRef<HTMLInputElement>(null);
  const router = useRouter();

  const submitHandler = async () => {
    if (!refEmail.current?.value) {
      alert("E-mail is Empty");
      return;
    }
    if (!refPassword.current?.value) {
      alert("Password is Empty");
      return;
    }
    try {
      const result = await signUpCognito({
        username: refEmail.current.value,
        password: refPassword.current.value,
      });
      console.log(result);
      router.push("/session/verify");
    } catch (e) {
      alert(JSON.stringify(e));
    }
  };

  return (
    <AppLayout>
      <h2>Sign up</h2>
      <div>
        <div>
          <label>E-mail:</label>
          <input type="text" ref={refEmail} />
        </div>
        <div>
          <label>Password:</label>
          <input type="password" ref={refPassword} />
        </div>
        <div>
          <button onClick={submitHandler}>Login</button>
        </div>
      </div>
    </AppLayout>
  );
};

export default SignUp;

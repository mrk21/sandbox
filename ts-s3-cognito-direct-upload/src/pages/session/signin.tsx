import { useRouter } from "next/router";
import { useRef } from "react";
import AppLayout from "@/components/AppLayout";
import { useAppState } from "@/libs/app_state";
import { signInCognito } from "@/libs/cognito";

const SignIn: React.FC = () => {
  const [state, dispatch] = useAppState();
  const router = useRouter();

  const refEmail = useRef<HTMLInputElement>(null);
  const refPassword = useRef<HTMLInputElement>(null);

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
      await signInCognito({
        username: refEmail.current.value,
        password: refPassword.current.value,
        state,
        dispatch,
      });
      router.push("/");
    } catch (e) {
      alert(JSON.stringify(e));
    }
  };

  return (
    <AppLayout>
      <h2>Sign in</h2>
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

export default SignIn;

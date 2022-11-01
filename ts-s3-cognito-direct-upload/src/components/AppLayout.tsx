import Link from "next/link";
import { ReactNode } from "react";
import { useAppState } from "@/libs/app_state";
import { signOutCognito } from "@/libs/cognito";

type Props = {
  children: ReactNode;
};

const AppLayout: React.FC<Props> = ({ children }) => {
  const [state, dispatch] = useAppState();
  const isLoggedIn = typeof state.session !== "undefined";

  const signout = async () => {
    await signOutCognito(state, dispatch);
  };

  return (
    <div>
      <h1>S3 Cognite Direct Upload</h1>
      {isLoggedIn ? (
        <ul>
          <li>
            <button onClick={signout}>Sign out</button>
          </li>
        </ul>
      ) : (
        <ul>
          <li>
            <Link href="/session/signup">Sign up</Link>
          </li>
          <li>
            <Link href="/session/signin">Sign in</Link>
          </li>
        </ul>
      )}
      <div>{children}</div>
    </div>
  );
};

export default AppLayout;

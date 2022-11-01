//import "@/styles/globals.css";
import { AppProps } from "next/app";
import React, { ReactNode } from "react";
import { AppStateProvider } from "@/libs/app_state";
import { useCognitoIdentityCredentials } from "@/libs/cognito";

const WithCognitoIdentityCredentials: React.FC<{
  children: ReactNode;
}> = ({ children }) => {
  const [isLoading] = useCognitoIdentityCredentials();
  return isLoading ? <p>loading...</p> : <>{children}</>;
};

const App = ({ Component, pageProps }: AppProps) => {
  return (
    <AppStateProvider>
      <WithCognitoIdentityCredentials>
        <Component {...pageProps} />
      </WithCognitoIdentityCredentials>
    </AppStateProvider>
  );
};

export default App;

import { CognitoIdentityCredentials } from "@aws-sdk/credential-provider-cognito-identity";
import {
  fromCognitoIdentityPool,
  FromCognitoIdentityPoolParameters,
  CognitoIdentityCredentialProvider,
} from "@aws-sdk/credential-providers";
import * as AmazonCognitoIdentity from "amazon-cognito-identity-js";
import { Dispatch, ReactNode, useEffect, useState } from "react";
import {
  AWSRegion,
  CognitoClientId,
  CognitoIdentityPoolId,
  CognitoUserPoolId,
} from "@/libs/app_config";
import { AppAction, AppState, useAppState } from "@/libs/app_state";
import { makeTuple } from "@/libs/general_helper";

export function getCognitoUserPool() {
  const poolData = {
    UserPoolId: CognitoUserPoolId,
    ClientId: CognitoClientId,
  } as AmazonCognitoIdentity.ICognitoUserPoolData;
  const userPool = new AmazonCognitoIdentity.CognitoUserPool(poolData);
  return userPool;
}

export async function signUpCognito({
  username,
  password,
}: {
  username: string;
  password: string;
}) {
  const userPool = getCognitoUserPool();
  const attributes = [
    {
      Name: "email",
      Value: username,
    },
  ] as AmazonCognitoIdentity.CognitoUserAttribute[];

  return new Promise<AmazonCognitoIdentity.ISignUpResult>((resolve, reject) => {
    userPool.signUp(
      username,
      password,
      attributes,
      attributes,
      (error, result) => {
        if (error) {
          reject(error);
          return;
        }
        if (result) {
          resolve(result);
          return;
        }
        reject(new Error("missing result"));
      }
    );
  });
}

export async function confirmCognitoRegistration({
  username,
  code,
}: {
  username: string;
  code: string;
}) {
  const userPool = getCognitoUserPool();
  const cognitoUser = new AmazonCognitoIdentity.CognitoUser({
    Username: username,
    Pool: userPool,
  });
  return new Promise<void>((resolve, reject) => {
    cognitoUser.confirmRegistration(code, true, (error, _result) => {
      if (error) {
        reject(error);
        return;
      }
      resolve();
    });
  });
}

export async function signInCognito({
  username,
  password,
  state,
  dispatch,
}: {
  username: string;
  password: string;
  state: AppState;
  dispatch: Dispatch<AppAction>;
}) {
  const userPool = getCognitoUserPool();
  const cognitoUser = new AmazonCognitoIdentity.CognitoUser({
    Username: username,
    Pool: userPool,
  });
  const authenticationDetails = new AmazonCognitoIdentity.AuthenticationDetails(
    {
      Username: username,
      Password: password,
    }
  );
  return new Promise<void>((resolve, reject) => {
    cognitoUser.authenticateUser(authenticationDetails, {
      onSuccess: async (result) => {
        dispatch({ type: "Session.Unset" });
        dispatch({ type: "Credentials.Unset" });
        dispatch({ type: "CredentialProvider.Unset" });
        dispatch({ type: "Session.Set", value: result });
        await initCognitoIdentityCredentials(state, dispatch);
        resolve();
      },
      onFailure: reject,
    });
  });
}

export async function signOutCognito(
  state: AppState,
  dispatch: Dispatch<AppAction>
) {
  return new Promise<void>((resolve, _reject) => {
    const userPool = getCognitoUserPool();
    const cognitoUser = userPool.getCurrentUser();

    if (cognitoUser) {
      cognitoUser.signOut(async () => {
        dispatch({ type: "Session.Unset" });
        dispatch({ type: "Credentials.Unset" });
        dispatch({ type: "CredentialProvider.Unset" });
        await initCognitoIdentityCredentials(state, dispatch);
        resolve();
      });
    } else {
      resolve();
    }
  });
}

export async function getCognitoSession(
  cognitoUser: AmazonCognitoIdentity.CognitoUser
) {
  return new Promise<AmazonCognitoIdentity.CognitoUserSession>(
    (resolve, reject) => {
      cognitoUser.getSession(
        (
          error: Error | null,
          session: AmazonCognitoIdentity.CognitoUserSession | null
        ) => {
          if (error) {
            reject(error);
            return;
          }
          if (session) {
            resolve(session);
          }
          reject(new Error("invalid"));
        }
      );
    }
  );
}

/**
 * @see [サインイン後に ID プールを使用して AWS サービスへアクセスする - Amazon Cognito](https://docs.aws.amazon.com/ja_jp/cognito/latest/developerguide/amazon-cognito-integrating-user-pools-with-identity-pools.html)
 * @see [amplify-js/packages/amazon-cognito-identity-js](https://github.com/aws-amplify/amplify-js/tree/main/packages/amazon-cognito-identity-js)
 * @see [Amazon Cognito アイデンティティを使用してユーザー認証をする - AWS SDK for JavaScript](https://docs.aws.amazon.com/ja_jp/sdk-for-javascript/v3/developer-guide/loading-browser-credentials-cognito.html)
 */
export async function initCognitoIdentityCredentials(
  state: AppState,
  dispatch: Dispatch<AppAction>
) {
  const userPool = getCognitoUserPool();
  const region = AWSRegion;
  const options = {
    clientConfig: {
      region: AWSRegion,
    },
    identityPoolId: CognitoIdentityPoolId,
  } as FromCognitoIdentityPoolParameters;

  const cognitoUser = userPool.getCurrentUser();
  if (cognitoUser) {
    const session = await getCognitoSession(cognitoUser);
    dispatch({ type: "Session.Set", value: session });
    options.logins = {
      [`cognito-idp.${region}.amazonaws.com/${CognitoUserPoolId}`]: session
        .getIdToken()
        .getJwtToken(),
    };
  }

  const provider = fromCognitoIdentityPool(options);
  const providerWrapper: CognitoIdentityCredentialProvider = async () => {
    const credentials = await provider();
    dispatch({ type: "Credentials.Set", value: credentials });
    return credentials;
  };
  dispatch({ type: "CredentialProvider.Set", value: providerWrapper });
  await providerWrapper();
}

export function useCognitoIdentityCredentials() {
  const [state, dispatch] = useAppState();
  const [isLoading, setIsLoading] = useState(
    typeof state?.credentials === "undefined"
  );

  useEffect(() => {
    if (typeof state?.credentials === "undefined") {
      const data = async () => {
        await initCognitoIdentityCredentials(state, dispatch);
        setIsLoading(false);
      };
      data();
    }
  }, [state?.credentials]);

  return makeTuple(isLoading);
}

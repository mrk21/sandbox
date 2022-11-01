import {
  CognitoIdentityCredentials,
  CognitoIdentityCredentialProvider,
} from "@aws-sdk/credential-provider-cognito-identity";
import * as AmazonCognitoIdentity from "amazon-cognito-identity-js";
import { createContext, useReducer, ReactNode, useContext } from "react";
import { makeTuple } from "@/libs/general_helper";

export type AppState = {
  session: AmazonCognitoIdentity.CognitoUserSession | undefined;
  credentials: CognitoIdentityCredentials | undefined;
  provider: CognitoIdentityCredentialProvider | undefined;
};

export const getInitialAppState = (): AppState => ({
  session: undefined,
  credentials: undefined,
  provider: undefined,
});

export type AppAction =
  | { type: "CredentialProvider.Set"; value: CognitoIdentityCredentialProvider }
  | { type: "CredentialProvider.Unset" }
  | { type: "Credentials.Set"; value: CognitoIdentityCredentials }
  | { type: "Credentials.Unset" }
  | { type: "Session.Set"; value: AmazonCognitoIdentity.CognitoUserSession }
  | { type: "Session.Unset" };

export type AppStateContextType = {
  state: AppState;
  dispatch: React.Dispatch<AppAction>;
};

export const AppStateContext = createContext({} as AppStateContextType);

export const appReducer = (state: AppState, action: AppAction): AppState => {
  switch (action.type) {
    case "CredentialProvider.Set":
      return {
        ...state,
        provider: action.value,
      };
    case "CredentialProvider.Unset":
      return {
        ...state,
        provider: undefined,
      };
    case "Credentials.Set":
      return {
        ...state,
        credentials: action.value,
      };
    case "Credentials.Unset":
      return {
        ...state,
        credentials: undefined,
      };
    case "Session.Set":
      return {
        ...state,
        session: action.value,
      };
    case "Session.Unset":
      return {
        ...state,
        session: undefined,
      };
    default:
      return state;
  }
};

export const AppStateProvider: React.FC<{ children: ReactNode }> = ({
  children,
}) => {
  const [state, dispatch] = useReducer(appReducer, getInitialAppState());

  return (
    <AppStateContext.Provider value={{ state, dispatch }}>
      {children}
    </AppStateContext.Provider>
  );
};

export const useAppState = () => {
  const { state, dispatch } = useContext(AppStateContext);
  return makeTuple(state, dispatch);
};

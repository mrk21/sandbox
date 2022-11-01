import { _Object } from "@aws-sdk/client-s3";
import { useState } from "react";
import AppLayout from "@/components/AppLayout";
import FileSelector from "@/components/FileSelector";
import S3ObjectList from "@/components/S3ObjectList";
import { S3Bucket } from "@/libs/app_config";
import { useAppState } from "@/libs/app_state";
import { S3ClientWrapper } from "@/libs/s3";

const Home: React.FC = () => {
  const [state] = useAppState();
  const userPrefix = `cognito/test/${state.credentials?.identityId}/`;
  const [userUpdateKey, setUserUpdateKey] = useState(0);

  const onSelect = async (file: File) => {
    if (!state.credentials) return;
    const body = file;
    const identityId = state.credentials.identityId;
    const key = `cognito/test/${identityId}/${file.name}`;
    const s3 = new S3ClientWrapper({
      credentials: state.provider,
      bucket: S3Bucket,
    });
    try {
      await s3.uploadObject({ key, body });
      setUserUpdateKey(userUpdateKey + 1);
    } catch (e) {
      console.log(e);
    }
  };

  return (
    <AppLayout>
      <FileSelector onSelect={onSelect} />
      <div>
        <h2>public</h2>
        <S3ObjectList prefix={"public/"} />
      </div>
      <div>
        <h2>{userPrefix}</h2>
        <S3ObjectList prefix={userPrefix} updateKey={userUpdateKey} />
      </div>
    </AppLayout>
  );
};

export default Home;

import {
  S3Client,
  ListObjectsCommand,
  PutObjectCommand,
  S3ClientConfig,
  S3ServiceException,
  _Object,
  GetObjectCommand,
  GetObjectCommandInput,
  PutObjectCommandInput,
} from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { useEffect, useState } from "react";
import { AWSRegion, S3Bucket } from "@/libs/app_config";
import { useAppState } from "@/libs/app_state";
import { makeTuple } from "@/libs/general_helper";

export class S3ClientWrapper {
  bucket: string;
  s3: S3Client;

  constructor({
    credentials,
    bucket,
  }: {
    credentials: S3ClientConfig["credentials"];
    bucket: string;
  }) {
    this.bucket = bucket;
    this.s3 = new S3Client({ credentials, region: AWSRegion });
  }

  async listObjects({ prefix }: { prefix: string }) {
    return this.s3.send(
      new ListObjectsCommand({
        Bucket: this.bucket,
        Prefix: prefix,
        Delimiter: "/",
      })
    );
  }

  async uploadObject({
    key,
    body,
  }: {
    key: string;
    body: PutObjectCommandInput["Body"];
  }) {
    return this.s3.send(
      new PutObjectCommand({
        Bucket: this.bucket,
        Key: key,
        Body: body,
      })
    );
  }

  /**
   * @see [AWS SDK を使用して Amazon S3 の署名付き URL を作成する - Amazon Simple Storage Service](https://docs.aws.amazon.com/ja_jp/AmazonS3/latest/userguide/example_s3_Scenario_PresignedUrl_section.html)
   */
  async getSignedURL({
    object,
    expiresIn,
  }: {
    object: _Object;
    expiresIn: number;
  }) {
    const objectParams = {
      Bucket: this.bucket,
      Key: object.Key || "",
    } as GetObjectCommandInput;
    const url = await getSignedUrl(
      this.s3,
      new GetObjectCommand(objectParams),
      { expiresIn }
    );
    return url;
  }
}

export const useS3ListObjects = ({
  prefix,
  updateKey,
}: {
  prefix: string;
  updateKey?: any;
}) => {
  const [state] = useAppState();
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<S3ServiceException>();
  const [data, setData] = useState<_Object[]>();

  useEffect(() => {
    const data = async () => {
      if (typeof state.credentials === "undefined") return;
      const s3 = new S3ClientWrapper({
        credentials: state.credentials,
        bucket: S3Bucket,
      });
      try {
        const { Contents } = await s3.listObjects({ prefix });
        if (Contents) {
          setData(Contents);
        }
      } catch (e) {
        // @see [AWS SDK for JavaScript (v3) モジュールでのエラー処理 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/service-error-handling-modular-aws-sdk-js/)
        if (e instanceof S3ServiceException) {
          setError(e);
        } else {
          throw e;
        }
      } finally {
        setIsLoading(false);
      }
    };
    data();
  }, [state.credentials, updateKey]);

  return makeTuple(data, error, isLoading);
};

export const useS3ObjectSignedURL = ({ object }: { object: _Object }) => {
  const [state] = useAppState();
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<S3ServiceException>();
  const [data, setData] = useState<string>();

  useEffect(() => {
    const data = async () => {
      if (typeof state.credentials === "undefined") return;
      const s3 = new S3ClientWrapper({
        credentials: state.credentials,
        bucket: S3Bucket,
      });
      try {
        const url = await s3.getSignedURL({ object, expiresIn: 3600 });
        setData(url);
      } catch (e) {
        // @see [AWS SDK for JavaScript (v3) モジュールでのエラー処理 | Amazon Web Services ブログ](https://aws.amazon.com/jp/blogs/news/service-error-handling-modular-aws-sdk-js/)
        if (e instanceof S3ServiceException) {
          setError(e);
        } else {
          throw e;
        }
      } finally {
        setIsLoading(false);
      }
    };
    data();
  }, [state.credentials]);

  return makeTuple(data, error, isLoading);
};

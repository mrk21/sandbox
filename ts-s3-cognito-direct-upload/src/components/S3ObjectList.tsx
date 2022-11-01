import S3Object from "@/components/S3Object";
import { useS3ListObjects } from "@/libs/s3";

const S3ObjectList: React.FC<{ prefix: string; updateKey?: any }> = ({
  prefix,
  updateKey,
}) => {
  const [data, error, loading] = useS3ListObjects({ prefix, updateKey });
  if (loading) {
    return <p>loading...</p>;
  }
  if (error) {
    return <p>{error.message || "internal server error"}</p>;
  }
  if (data) {
    return (
      <div>
        {data
          .filter((v) => v.Key && !v.Key.match(/\/$/))
          .map((v) => {
            return (
              <div
                key={v.Key || "none"}
                style={{ display: "inline-block", margin: "10px" }}
              >
                <div>{v.Key || "no-title"}</div>
                <S3Object object={v} />
              </div>
            );
          })}
      </div>
    );
  }
  return <p>empty</p>;
};

export default S3ObjectList;

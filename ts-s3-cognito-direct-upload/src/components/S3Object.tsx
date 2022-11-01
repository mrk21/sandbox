import { _Object } from "@aws-sdk/client-s3";
import { getFileType } from "@/libs/file";
import { useS3ObjectSignedURL } from "@/libs/s3";

const S3Object: React.FC<{ object: _Object }> = ({ object }) => {
  const [data, error, loading] = useS3ObjectSignedURL({ object });
  if (loading) {
    return <p>loading...</p>;
  }
  if (error) {
    return <p>{error.message || "internal server error"}</p>;
  }
  if (data) {
    switch (getFileType(object.Key || "")) {
      case "image":
        return (
          <div>
            <img style={{ display: "block", width: "250px" }} src={data} />
            <a style={{ display: "block" }} href={data}>
              download
            </a>
          </div>
        );
      case "video":
        return (
          <div>
            <video
              style={{ display: "block" }}
              controls
              width="250"
              src={data}
            ></video>
            <a style={{ display: "block" }} href={data}>
              download
            </a>
          </div>
        );
      default:
        return (
          <div>
            <a href={data}>download</a>
          </div>
        );
    }
  }
  return <p>empty</p>;
};

export default S3Object;

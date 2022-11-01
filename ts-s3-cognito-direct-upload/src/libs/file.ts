export type FileType = "image" | "video" | "other";

export function getFileType(name: string): FileType {
  const v = name.toLowerCase();
  if (v.match(/\.(jpg|jpeg|png)$/)) {
    return "image";
  } else if (v.match(/\.(mov|mp4)$/)) {
    return "video";
  }
  return "other";
}

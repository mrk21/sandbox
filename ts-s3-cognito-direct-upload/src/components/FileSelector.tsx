import { DOMAttributes, useRef } from "react";

type Props = {
  onSelect: (file: File) => any;
};

export default function FileSelector({ onSelect }: Props) {
  const fileDOM = useRef<HTMLInputElement>(null);
  const onClick: DOMAttributes<HTMLButtonElement>["onClick"] = (e) => {
    if (!fileDOM.current) return;
    if (!fileDOM.current.files) return;
    const file = fileDOM.current.files[0];
    onSelect(file);
    fileDOM.current.value = "";
  };
  return (
    <div>
      <label>Upload File:</label>
      <input ref={fileDOM} type="file" />
      <button onClick={onClick} type="button">
        Upload
      </button>
    </div>
  );
}

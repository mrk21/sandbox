"use client";

import { unparse } from "papaparse";
import { ChangeEvent, useCallback, useEffect, useState } from "react";

function* times(n: number) {
  for (let i = 0; i < n; i++) {
    yield i;
  }
}

export default function Home() {
  const [filename, setFilename] = useState("data.csv");
  const [n, setN] = useState(10);
  const [name, setName] = useState("name :id:");

  const onChangeFilename = useCallback((e: ChangeEvent<HTMLInputElement>) => { setFilename(e.target.value) }, [setFilename]);
  const onChangeN = useCallback((e: ChangeEvent<HTMLInputElement>) => { setN(parseInt(e.target.value)) }, [setN]);
  const onChangeName = useCallback((e: ChangeEvent<HTMLTextAreaElement>) => { setName(e.target.value) }, [setName]);

  const [json, setJson] = useState('');
  const [csv, setCsv] = useState('');
  const [url, setURL] = useState('');

  useEffect(() => {
    const data = Array.from(times(n)).map((i) => ({
      id: i+1,
      name: name.replace(':id:', `${i+1}`),
      age: 20+i,
    }));
    const json = JSON.stringify(data, null, 2);
    const csv = unparse(data);
    const blob = new Blob([csv], {type: 'text/csv'});
    const url = URL.createObjectURL(blob);

    setJson(json);
    setCsv(csv);
    setURL(url);

    return () => {
      URL.revokeObjectURL(url);
    };
  }, [n, name]);

  return (
    <>
      <h1>CSV generation and downloading</h1>

      <div>
        <p>
          <label>
            <b>Filename:</b>
            <span>
              <input type="text" onChange={onChangeFilename} value={filename} />
            </span>
          </label>
        </p>

        <p>
          <label>
            <b>N:</b>
            <span>
              <input type="number" onChange={onChangeN} value={n} />
            </span>
          </label>
        </p>

        <p>
          <label>
            <b>name:</b>
            <span>
              <textarea rows={2} onChange={onChangeName} value={name}></textarea>
              <sub><code>:id:</code>is replaced ID</sub>
            </span>
          </label>
        </p>
      </div>


      <b>Data:</b>
      <pre className="code">{json}</pre>

      <b>CSV:</b>
      <pre className="code">{csv}</pre>
      <a download={filename} href={url}>Download</a>
    </>
  );
}

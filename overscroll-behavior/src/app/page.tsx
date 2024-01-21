'use client';
import { useCallback, useState } from "react";

function *times(n: number) {
  for (let i = 0; i < n; i++) {
    yield i;
  }
}

export default function Home() {
  const [isOpen, setIsOpen] = useState(false);
  const onClickOpenButton = useCallback(() => setIsOpen(true), [setIsOpen]);
  const onClickCloseButton = useCallback(() => setIsOpen(false), [setIsOpen]);

  return (
    <div className="content">
      <button className="open-button" type="button" onClick={onClickOpenButton}>open modal</button>
      { [...times(1000)].map((m,i) => 
        <p key={i}>Message {m}.</p>
      ) }

      <div className={`modal ${isOpen ? 'open' : ''}`}>
        <div className="modal-content">
          <div className="modal-header">
            <h2>Modal Header</h2>
          </div>
          <div className="modal-body">
            { [...times(10)].map((m,i) => 
              <p key={i}>Message {m}.</p>
            ) }
          </div>
          <div className="modal-footer">
            <ul className="modal-footer-menus">
              <li><button onClick={onClickCloseButton}>OK</button></li>
              <li><button onClick={onClickCloseButton}>Cancel</button></li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
}

import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'
import OptionSelector, { Option } from './OptionSelector'

function App() {
  const [option1, setOption1] = useState<Option>();
  const [option2, setOption2] = useState<Option>();

  return (
    <>
      <div>
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="main">
        <div>
          <ul>
            <li><strong>option1:</strong><span>{ option1 ? option1.label : '-' }</span></li>
            <li><strong>option2:</strong><span>{ option2 ? option2.label : '-' }</span></li>
          </ul>
        </div>
        <div>
          <OptionSelector title="option1" value={option1} onChange={setOption1} />
          <OptionSelector title="option2" value={option2} onChange={setOption2} />
        </div>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  )
}

export default App

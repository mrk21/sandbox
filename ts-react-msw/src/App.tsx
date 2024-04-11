import { useEffect, useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import './App.css'

type User = {
  id: string;
  name: string;
};

function App() {
  const [users, setUsers] = useState<User[]>();

  useEffect(() => {
    let ignore = false;
    const fetchData = async () => {
      const res = await fetch('/api/users');
      const body = await res.json() as User[];
      if (!ignore) setUsers(body);
    };
    fetchData();
    return () => { ignore = true; };
  }, []);

  const UserList = () => {
    if (typeof users === 'undefined') return (<div>loading...</div>);
    return (
      <ul>
        { users.map(user => (<li key={user.id}>{user.name}</li>)) }
      </ul>
    );
  };

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
      <div>
        <p>Users:</p>
        <UserList></UserList>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
}

export default App;

import { useState } from 'react';
import css from 'styled-jsx/css';
import Link from 'next/link';

export const Home = () => {
  const [ count, setCount ] = useState(0);
  const onClick = () => setCount(count + 1);

  return (
    <div className="home">
      <p className="home__title">Welcome to Next.js!</p>
      <button onClick={ onClick } className="home__button">increment value: { count }</button>
      <ul>
        <li>
          <Link href="/about">
            <a>about</a>
          </Link>
        </li>
        <li>
          <Link as="/detail/1" href="/detail?id=1">
            <a>detail</a>
          </Link>
        </li>
      </ul>
      <style jsx>{ styles }</style>
    </div>
  );
}

export const styles = css`
  .home__title {
    color: red;
    font-size: 24px;
  }
`;

export default Home;

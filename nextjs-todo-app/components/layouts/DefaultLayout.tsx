import { StatelessComponent } from 'react';
import css from 'styled-jsx/css';
import Link from 'next/link';

export const DefaultLayout: StatelessComponent = ({ children }) => {
  return (
    <article className="page">
      <header className="page__header">
        <h1 className="page__heading">Todo App</h1>
        <nav>
          <li>
            <Link href="/">
              <a>home</a>
            </Link>
          </li>
        </nav>
      </header>

      <div className="page__body">
        { children }
      </div>
    </article>
  );
}

export const styles = css`
  .page {}
  .page__header {}
  .page__heading {}
  .page__body {}
`;

export default DefaultLayout;

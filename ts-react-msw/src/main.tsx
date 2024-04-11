import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.tsx'
import './index.css'
import { HttpResponse, http } from 'msw'
import { setupWorker } from 'msw/browser'

async function sleep(ms: number) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function setup() {
  const worker = setupWorker(
    http.get('/api/users', async () => {
      await sleep(1000);
      return HttpResponse.json([
        { id: '1', name: 'John' },
        { id: '2', name: 'Doe' },
        { id: '3', name: 'Jane'},
      ]);
    }),
  );

  // @see listen() - Mock Service Worker](https://mswjs.io/docs/api/setup-server/listen#onunhandledrequest)
  await worker.start({
    onUnhandledRequest(request, print) {
      const url = new URL(request.url);
      if (!url.pathname.startsWith('/api')) return;
      print.warning();
    },
  });

  ReactDOM.createRoot(document.getElementById('root')!).render(
    <React.StrictMode>
      <App />
    </React.StrictMode>,
  );
}

setup();

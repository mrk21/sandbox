const express = require('express');
const next = require('next');

const dev = process.env.NODE_ENV !== 'production';
const app = next({ dev });
const handler = app.getRequestHandler();

app.prepare().then(() => {
  const server = express();

  server.get('/detail/:id', (req, res) => {
    const page = '/detail';
    const params = { id: req.params.id };
    app.render(req, res, page, params);
  });

  server.get('*', (req, res) => {
    return handler(req, res);
  });

  server.listen(3000, (err) => {
    if (err) throw err;
    console.log('> Ready on http://localhost:3000');
  });
});

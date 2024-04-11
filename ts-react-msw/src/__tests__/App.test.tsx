import { render, screen, waitFor } from '@testing-library/react'
import { HttpResponse, http } from 'msw';
import { setupServer } from 'msw/node';
import App from "../App";

const server = setupServer();
beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());

describe('<App />', () => {
  beforeEach(() => {
    server.use(
      http.get('/api/users', async () => {
        return HttpResponse.json([
          { id: '1', name: 'John' },
          { id: '2', name: 'Doe' },
          { id: '3', name: 'Jane'},
        ]);
      }),
    );
  });

  test('renders the App component', async () => {
    render(<App />);
    await waitFor(() => {
      expect(screen.getByRole('list').innerHTML).toBe('<li>John</li><li>Doe</li><li>Jane</li>');
    });
  });
});

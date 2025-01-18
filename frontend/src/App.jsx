import React from 'react';
import { Provider } from 'react-redux';
import { store } from './store/store';
import Board from './components/board/Board';

function App() {
  return (
    <Provider store={store}>
      <div className="min-h-screen bg-gray-100 flex items-center justify-center">
        <div className="p-8 bg-white rounded-lg shadow-lg">
          <h1 className="text-3xl font-bold mb-8 text-center">Casta Game</h1>
          <Board />
        </div>
      </div>
    </Provider>
  );
}

export default App;

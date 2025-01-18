import React from 'react';
import Board from './components/board/Board';

function App() {
  return (
    <div style={{ 
      padding: '20px',
      textAlign: 'center'
    }}>
      <h1 style={{
        fontSize: '2em',
        marginBottom: '20px'
      }}>Casta Game</h1>
      <Board />
    </div>
  );
}

export default App;

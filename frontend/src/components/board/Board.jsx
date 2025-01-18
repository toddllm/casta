import React, { useState } from 'react';
import Square from './Square';

const createInitialBoard = () => {
  const board = Array(8).fill(null).map(() => Array(8).fill(null));
  
  // Place Rooks (R)
  board[0][0] = { type: 'R', color: 'black' };
  board[0][7] = { type: 'R', color: 'black' };
  board[7][0] = { type: 'R', color: 'white' };
  board[7][7] = { type: 'R', color: 'white' };
  
  // Place Dragons (D)
  board[0][1] = { type: 'D', color: 'black' };
  board[0][6] = { type: 'D', color: 'black' };
  board[7][1] = { type: 'D', color: 'white' };
  board[7][6] = { type: 'D', color: 'white' };
  
  // Place Casta pieces (C)
  board[0][3] = { type: 'C', color: 'black' };
  board[7][3] = { type: 'C', color: 'white' };

  return board;
};

const Board = () => {
  const [board, setBoard] = useState(createInitialBoard());
  const [selectedSquare, setSelectedSquare] = useState(null);
  
  const handleSquareClick = (row, col) => {
    if (selectedSquare) {
      // If a square was already selected, try to move the piece
      const [selectedRow, selectedCol] = selectedSquare;
      
      if (selectedRow === row && selectedCol === col) {
        // Clicking the same square deselects it
        setSelectedSquare(null);
      } else {
        // Move piece (for now, just swap positions)
        const newBoard = [...board.map(row => [...row])];
        newBoard[row][col] = board[selectedRow][selectedCol];
        newBoard[selectedRow][selectedCol] = null;
        setBoard(newBoard);
        setSelectedSquare(null);
      }
    } else if (board[row][col]) {
      // If clicking a piece, select it
      setSelectedSquare([row, col]);
    }
  };

  const squares = [];
  for (let row = 0; row < 8; row++) {
    for (let col = 0; col < 8; col++) {
      const isLight = (row + col) % 2 === 0;
      const piece = board[row][col];
      const isSelected = selectedSquare && 
                        selectedSquare[0] === row && 
                        selectedSquare[1] === col;
      
      squares.push(
        <Square
          key={`${row}-${col}`}
          isLight={isLight}
          piece={piece}
          isSelected={isSelected}
          onClick={() => handleSquareClick(row, col)}
        />
      );
    }
  }

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: 'repeat(8, 60px)',
      gap: '0px',
      border: '2px solid #666',
      padding: '4px',
      backgroundColor: '#666',
      maxWidth: 'fit-content',
      margin: '20px auto'
    }}>
      {squares}
    </div>
  );
};

export default Board;
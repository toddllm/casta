// frontend/src/components/board/Board.jsx
import React, { useEffect } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { selectPiece, movePiece, initializeBoard } from '../../store/gameSlice';

const Board = () => {
  const dispatch = useDispatch();
  const board = useSelector(state => state.game.board);
  const selectedPiece = useSelector(state => state.game.selectedPiece);

  useEffect(() => {
    // Initialize the board when component mounts
    dispatch(initializeBoard());
  }, [dispatch]);

  const handleSquareClick = (x, y) => {
    if (selectedPiece) {
      dispatch(movePiece({ from: selectedPiece, to: { x, y } }));
    } else if (board[y][x]) {
      dispatch(selectPiece({ x, y }));
    }
  };

  return (
    <div className="grid grid-cols-8 gap-0 w-96 h-96 border-2 border-gray-800">
      {board.map((row, y) => 
        row.map((piece, x) => (
          <div
            key={`${x}-${y}`}
            onClick={() => handleSquareClick(x, y)}
            className={`
              w-full h-full
              ${(x + y) % 2 === 0 ? 'bg-gray-200' : 'bg-gray-600'}
              ${selectedPiece?.x === x && selectedPiece?.y === y ? 'ring-2 ring-blue-500' : ''}
              flex items-center justify-center
            `}
          >
            {piece && (
              <div className={`
                w-8 h-8 rounded-full 
                ${piece.color === 'white' ? 'bg-white' : 'bg-black'}
                border-2 border-gray-800
              `}>
                {piece.type}
              </div>
            )}
          </div>
        ))
      )}
    </div>
  );
};

export default Board;
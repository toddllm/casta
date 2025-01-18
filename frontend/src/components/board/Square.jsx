import React from 'react';
import { useSelector } from 'react-redux';

const Square = ({ x, y, piece, onClick }) => {
  const isBlack = (x + y) % 2 === 1;
  const selectedPiece = useSelector(state => state.game.selectedPiece);
  const isSelected = selectedPiece?.x === x && selectedPiece?.y === y;

  return (
    <div
      onClick={onClick}
      className={`
        w-12 h-12 flex items-center justify-center
        ${isBlack ? 'bg-gray-600' : 'bg-gray-200'}
        ${isSelected ? 'ring-2 ring-blue-500' : ''}
        cursor-pointer
      `}
    >
      {piece && (
        <div className="w-8 h-8 rounded-full bg-red-500">
          {/* Temporary piece representation */}
        </div>
      )}
    </div>
  );
};

export default Square;

import React from 'react';

const Square = ({ isLight, piece, isSelected, onClick }) => {
  const backgroundColor = isLight ? '#f0d9b5' : '#b58863';
  
  // Piece display styles
  const getPieceStyle = (piece) => {
    return {
      width: '45px',
      height: '45px',
      borderRadius: '50%',
      backgroundColor: piece.color,
      border: '2px solid #333',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      color: piece.color === 'white' ? '#333' : '#fff',
      fontSize: '24px',
      fontWeight: 'bold',
      userSelect: 'none'
    };
  };

  return (
    <div 
      onClick={onClick}
      style={{
        backgroundColor,
        width: '60px',
        height: '60px',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        cursor: 'pointer',
        border: isSelected ? '2px solid #3498db' : '1px solid #666',
        boxSizing: 'border-box',
        position: 'relative'
      }}
    >
      {piece && (
        <div style={getPieceStyle(piece)}>
          {piece.type}
        </div>
      )}
    </div>
  );
};

export default Square;

// frontend/src/store/gameSlice.js
import { createSlice } from '@reduxjs/toolkit';

const createInitialBoard = () => {
  const board = Array(8).fill(null).map(() => Array(8).fill(null));
  
  // Initialize pieces for testing
  // Add some test pieces
  board[0][0] = { type: 'R', color: 'black' };
  board[0][7] = { type: 'R', color: 'black' };
  board[7][0] = { type: 'R', color: 'white' };
  board[7][7] = { type: 'R', color: 'white' };
  
  // Add some center pieces
  board[3][3] = { type: 'C', color: 'white' }; // Casta piece
  board[3][4] = { type: 'D', color: 'black' }; // Dragon
  
  return board;
};

const initialState = {
  board: Array(8).fill(null).map(() => Array(8).fill(null)),
  selectedPiece: null,
  currentPlayer: 'white',
  gameStatus: 'waiting',
  validMoves: [],
};

export const gameSlice = createSlice({
  name: 'game',
  initialState,
  reducers: {
    initializeBoard: (state) => {
      state.board = createInitialBoard();
      state.gameStatus = 'active';
    },
    selectPiece: (state, action) => {
      state.selectedPiece = action.payload;
    },
    movePiece: (state, action) => {
      const { from, to } = action.payload;
      if (from && to) {
        state.board[to.y][to.x] = state.board[from.y][from.x];
        state.board[from.y][from.x] = null;
        state.selectedPiece = null;
        state.currentPlayer = state.currentPlayer === 'white' ? 'black' : 'white';
      }
    },
    setValidMoves: (state, action) => {
      state.validMoves = action.payload;
    },
    setGameStatus: (state, action) => {
      state.gameStatus = action.payload;
    },
  },
});

export const { 
  initializeBoard, 
  selectPiece, 
  movePiece, 
  setValidMoves, 
  setGameStatus 
} = gameSlice.actions;

export default gameSlice.reducer;
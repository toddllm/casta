#!/bin/bash

# Exit on error
set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    exit 1
}

# Update package.json files with new dependencies
update_frontend_dependencies() {
    log "Updating frontend dependencies..."
    
    cd frontend
    npm install @reduxjs/toolkit react-redux socket.io-client --save
    cd ..
}

# Create Redux store setup
create_redux_setup() {
    log "Creating Redux store setup..."
    
    mkdir -p frontend/src/store
    
    # Create store.js
    cat > frontend/src/store/store.js << 'EOF'
import { configureStore } from '@reduxjs/toolkit';
import gameReducer from './gameSlice';

export const store = configureStore({
  reducer: {
    game: gameReducer,
  },
});
EOF

    # Create gameSlice.js
    cat > frontend/src/store/gameSlice.js << 'EOF'
import { createSlice } from '@reduxjs/toolkit';

const initialState = {
  board: Array(8).fill(null).map(() => Array(8).fill(null)),
  selectedPiece: null,
  currentPlayer: 'white',
  gameStatus: 'waiting', // waiting, active, finished
  validMoves: [],
};

export const gameSlice = createSlice({
  name: 'game',
  initialState,
  reducers: {
    selectPiece: (state, action) => {
      state.selectedPiece = action.payload;
    },
    movePiece: (state, action) => {
      const { from, to } = action.payload;
      state.board[to.y][to.x] = state.board[from.y][from.x];
      state.board[from.y][from.x] = null;
      state.selectedPiece = null;
      state.currentPlayer = state.currentPlayer === 'white' ? 'black' : 'white';
    },
    setValidMoves: (state, action) => {
      state.validMoves = action.payload;
    },
    setGameStatus: (state, action) => {
      state.gameStatus = action.payload;
    },
  },
});

export const { selectPiece, movePiece, setValidMoves, setGameStatus } = gameSlice.actions;
export default gameSlice.reducer;
EOF
}

# Create basic components
create_components() {
    log "Creating basic components..."
    
    mkdir -p frontend/src/components/{board,pieces}
    
    # Create Board component
    cat > frontend/src/components/board/Board.jsx << 'EOF'
import React from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { selectPiece, movePiece } from '../../store/gameSlice';
import Square from './Square';

const Board = () => {
  const board = useSelector(state => state.game.board);
  const dispatch = useDispatch();

  const handleSquareClick = (x, y) => {
    const selectedPiece = useSelector(state => state.game.selectedPiece);
    
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
          <Square
            key={`${x}-${y}`}
            x={x}
            y={y}
            piece={piece}
            onClick={() => handleSquareClick(x, y)}
          />
        ))
      )}
    </div>
  );
};

export default Board;
EOF

    # Create Square component
    cat > frontend/src/components/board/Square.jsx << 'EOF'
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
EOF

    # Update App.jsx
    cat > frontend/src/App.jsx << 'EOF'
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
EOF
}

# Create backend game logic
create_backend_logic() {
    log "Creating backend game logic..."
    
    mkdir -p backend/src/{game,routes}
    
    # Create game controller
    cat > backend/src/game/GameController.js << 'EOF'
class GameController {
  constructor() {
    this.games = new Map();
  }

  createGame(gameId) {
    const game = {
      board: Array(8).fill(null).map(() => Array(8).fill(null)),
      currentPlayer: 'white',
      status: 'waiting',
    };
    this.games.set(gameId, game);
    return game;
  }

  getGame(gameId) {
    return this.games.get(gameId);
  }

  makeMove(gameId, from, to) {
    const game = this.games.get(gameId);
    if (!game) return null;

    // Basic move validation would go here
    const piece = game.board[from.y][from.x];
    game.board[from.y][from.x] = null;
    game.board[to.y][to.x] = piece;
    game.currentPlayer = game.currentPlayer === 'white' ? 'black' : 'white';

    return game;
  }
}

export default new GameController();
EOF

    # Update index.js with socket handling
    cat > backend/src/index.js << 'EOF'
import express from 'express';
import cors from 'cors';
import { createServer } from 'http';
import { Server } from 'socket.io';
import dotenv from 'dotenv';
import GameController from './game/GameController.js';

dotenv.config();

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: process.env.NODE_ENV === 'development' 
      ? 'http://localhost:5173'
      : 'http://localhost:3000',
    methods: ['GET', 'POST']
  }
});

app.use(cors());
app.use(express.json());

io.on('connection', (socket) => {
  console.log('Client connected:', socket.id);

  socket.on('join_game', (gameId) => {
    socket.join(gameId);
    let game = GameController.getGame(gameId);
    if (!game) {
      game = GameController.createGame(gameId);
    }
    io.to(gameId).emit('game_state', game);
  });

  socket.on('make_move', ({ gameId, from, to }) => {
    const updatedGame = GameController.makeMove(gameId, from, to);
    if (updatedGame) {
      io.to(gameId).emit('game_state', updatedGame);
    }
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected:', socket.id);
  });
});

const PORT = process.env.PORT || 4000;
httpServer.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
EOF
}

# Main setup function
main() {
    log "Starting Phase 1 setup..."
    
    update_frontend_dependencies
    create_redux_setup
    create_components
    create_backend_logic
    
    log "Phase 1 setup completed successfully!"
    log "Next steps:"
    log "1. Run: docker-compose down"
    log "2. Run: docker-compose up --build"
    log "3. Visit: http://localhost:5173"
}

# Run main function
main "$@"

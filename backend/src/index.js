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

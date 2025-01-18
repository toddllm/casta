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

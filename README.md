# Casta Game

A strategic board game implementation with React frontend and Node.js backend.

## Prerequisites

- Node.js (v20.10.0 or later)
- npm (included with Node.js)
- Git

## Getting Started

### Clone the Repository

```bash
git clone git@github.com:toddllm/casta.git
cd casta
```

### Frontend Setup

```bash
cd frontend
npm install
npm run dev
```

The frontend will be available at `http://localhost:5173`

### Backend Setup

In a new terminal:

```bash
cd backend
npm install
npm run dev
```

The backend will be running on `http://localhost:4000`

## Development

### Project Structure

```
casta/
├── frontend/               # React frontend
│   ├── src/
│   │   ├── components/    # React components
│   │   │   └── board/    # Game board components
│   │   └── main.jsx      # Entry point
│   └── vite.config.js
├── backend/               # Node.js backend
│   └── src/
│       ├── game/         # Game logic
│       └── index.js      # Server entry point
└── docker/               # Docker configuration
```

### Current Features

- 8x8 game board with alternating colors
- Initial piece placement:
  - Rooks (R) in corners
  - Dragons (D) next to Rooks
  - Casta pieces (C) in middle positions
- Piece selection and basic movement
- Visual feedback for selected pieces

### Running with Docker

If you prefer using Docker:

```bash
docker-compose up --build
```

This will start both frontend and backend services.

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Submit a pull request

## License

[Add your license information here]
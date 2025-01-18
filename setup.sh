#!/bin/bash

# Exit on error
set -e

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Default values
ENV=${ENV:-"development"}
NODE_VERSION="20.10.0"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%dT%H:%M:%S%z')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

# Create necessary directories
create_directory_structure() {
    log "Creating directory structure..."
    
    mkdir -p {frontend,backend,database,docker}
    mkdir -p frontend/{src,public,tests}
    mkdir -p backend/{src,tests,config}
    mkdir -p backend/src/{controllers,models,routes,services,utils,middleware}
    mkdir -p database/{init,migrations}
    mkdir -p frontend/src/{components,contexts,hooks,services,styles,utils}
    mkdir -p frontend/src/components/{board,pieces,ui}
    mkdir -p docker/{development,production}
}

# Generate package.json files
generate_package_files() {
    log "Generating package.json files..."
    
    # Frontend package.json
    cat > frontend/package.json << EOF
{
  "name": "casta-frontend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "serve": "vite preview",
    "test": "vitest"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.39.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.21.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.45",
    "@types/react-dom": "^18.2.17",
    "@vitejs/plugin-react": "^4.2.1",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.32",
    "tailwindcss": "^3.3.6",
    "typescript": "^5.3.3",
    "vite": "^5.0.10",
    "vitest": "^1.0.4"
  }
}
EOF

    # Backend package.json
    cat > backend/package.json << EOF
{
  "name": "casta-backend",
  "version": "0.1.0",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "nodemon src/index.js",
    "start": "node src/index.js",
    "test": "jest"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.39.0",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1",
    "express": "^4.18.2",
    "socket.io": "^4.7.2"
  },
  "devDependencies": {
    "jest": "^29.7.0",
    "nodemon": "^3.0.2"
  }
}
EOF
}

# Generate configuration files
generate_config_files() {
    log "Generating configuration files..."
    
    # Create .env files if they don't exist
    if [ ! -f .env ]; then
        cat > .env << EOF
ENV=development
PORT=3000
VITE_SUPABASE_URL=http://localhost:54321
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
EOF
    fi
    
    # Create docker-compose.yml
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  frontend:
    build:
      context: ./frontend
      dockerfile: ../docker/development/frontend.Dockerfile
    ports:
      - "3000:3000"
    volumes:
      - ./frontend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - VITE_SUPABASE_URL=http://localhost:54321
      - VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0
    depends_on:
      - backend

  backend:
    build:
      context: ./backend
      dockerfile: ../docker/development/backend.Dockerfile
    ports:
      - "4000:4000"
    volumes:
      - ./backend:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - SUPABASE_URL=http://localhost:54321
      - SUPABASE_SERVICE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImV4cCI6MTk4MzgxMjk5Nn0.EGIM96RAZx35lJzdJsyH-qQwv8Hdp7fsn3W0YpN81IU
EOF

    # Create development Dockerfiles
    cat > docker/development/frontend.Dockerfile << EOF
FROM node:${NODE_VERSION}-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm", "run", "dev"]
EOF

    cat > docker/development/backend.Dockerfile << EOF
FROM node:${NODE_VERSION}-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 4000

CMD ["npm", "run", "dev"]
EOF
}

# Initialize git repository
init_git() {
    log "Initializing git repository..."
    
    if [ ! -d .git ]; then
        git init
        
        # Create .gitignore
        cat > .gitignore << EOF
# Dependencies
node_modules/
.pnp/
.pnp.js

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Build output
dist/
build/
out/

# Logs
logs/
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Editor directories and files
.idea/
.vscode/
*.swp
*.swo
*.swn
*.bak

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db
EOF

        git add .
        git commit -m "Initial commit"
    else
        warn "Git repository already initialized"
    fi
}

# Main setup function
main() {
    log "Starting setup for Casta game..."
    
    create_directory_structure
    generate_package_files
    generate_config_files
    init_git
    
    log "Setup completed successfully!"
    log "To start the development environment, run: docker-compose up"
}

# Run main function
main "$@"
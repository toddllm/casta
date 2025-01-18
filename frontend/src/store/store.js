import { configureStore } from '@reduxjs/toolkit';
import gameReducer from './gameSlice';

console.log('Configuring Redux store...');

// Add a middleware for debugging
const debugMiddleware = store => next => action => {
  console.log('Dispatching action:', action);
  const result = next(action);
  console.log('New state:', store.getState());
  return result;
};

let store;

try {
  console.log('Creating store with game reducer...');
  store = configureStore({
    reducer: {
      game: gameReducer,
    },
    middleware: (getDefaultMiddleware) => 
      getDefaultMiddleware().concat(debugMiddleware),
  });
  console.log('Store created successfully');
  console.log('Initial state:', store.getState());
} catch (error) {
  console.error('Error creating Redux store:', error);
  throw error;
}

export { store };

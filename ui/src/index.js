import React from 'react'
import { createRoot } from 'react-dom/client';
import './index.css'
import App from './App'

import { MetaMaskProvider } from "metamask-react";

const container = document.getElementById('root');
const root = createRoot(container); 

root.render(
  <React.StrictMode>
    <MetaMaskProvider>
      <App />
    </MetaMaskProvider>
  </React.StrictMode>
  );
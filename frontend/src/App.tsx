import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Dashboard from './pages/Dashboard';
import HostManagement from './pages/HostManagement';
import NetworkConfig from './pages/NetworkConfig';

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/hosts" element={<HostManagement />} />
        <Route path="/network" element={<NetworkConfig />} />
      </Routes>
    </Router>
  );
}

export default App;

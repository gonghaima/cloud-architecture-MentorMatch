import React, { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import './Dashboard.css';

const Dashboard = () => {
  const [user, setUser] = useState(null);
  const location = useLocation();

  useEffect(() => {
    // Get user data from location state
    const userData = location.state?.user;
    if (userData) {
      setUser(userData);
    }
  }, [location.state]);

  return (
    <div className="dashboard">
      {user && (
        <header className="dashboard-header">
          <h1>Welcome, {user.username}</h1>
          <p>Email: {user.email}</p>
          <p>Role: {user.role}</p>
        </header>
      )}
      <div className="dashboard-content">
        <h2>Dashboard</h2>
        <p>Welcome to the MentorMatch Dashboard!</p>
        {/* Add more dashboard content here */}
      </div>
    </div>
  );
};

export default Dashboard;
import React, { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import { baseUrl } from '../config';
import './Dashboard.css';

const Dashboard = () => {
    const [user, setUser] = useState(null);
    const [users, setUsers] = useState([]);
    const location = useLocation();
    const navigate = useNavigate();

    useEffect(() => {
        // Get user data from location state
        const userData = location.state?.user;
        if (userData) {
            setUser(userData);
        }

        const fetchUsers = async () => {
            try {
                const response = await fetch(`${baseUrl}/users-search`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({}),
                });

                const data = await response.json();
                setUsers(data);
            } catch (error) {
                console.error('Error fetching users:', error);
            }
        };

        fetchUsers();
    }, [location.state]);

    const handleLogout = () => {
        navigate('/signin');
    };

    const handleAnalytics = () => {
        navigate('/analytics', { state: { user } });
    };

    return (
        <div className="dashboard">
            {user && (
                <header className="dashboard-header">
                    <div className="user-info">
                        <h1>Welcome, {user.username}</h1>
                        <p>Email: {user.email}</p>
                        <p>Role: {user.role}</p>
                    </div>
                    <div className="header-buttons">
                        <button className="analytics-button" onClick={handleAnalytics}>
                            Analytics
                        </button>
                        <button className="logout-button" onClick={handleLogout}>
                            Logout
                        </button>
                    </div>
                </header>
            )}
            <div className="dashboard-content">
                <h2 className='dashboard-content-heading'>Best Mentor Matched</h2>
                <div className="user-cards">
                    {users.map((user) => (
                        <div key={user.user} className="user-card">
                            <img src={user.profilePic} alt={`${user.username}'s profile`} />
                            <h3>{user.username}</h3>
                            <p>Email: {user.email}</p>
                            <p>Role: {user.role}</p>
                            {/* <p>Offering: {user.offering.join(', ')}</p>
                            <p>Studying: {user.studying.join(', ')}</p> */}
                            <p>Address: {user.address}</p>
                            <p>Postcode: {user.postcode}</p>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default Dashboard;
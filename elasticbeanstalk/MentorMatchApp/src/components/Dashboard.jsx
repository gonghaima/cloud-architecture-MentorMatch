import React, {useState} from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import { useEffect } from 'react';

const Dashboard = () => {
    const [user, setUser] = useState(null);

    useEffect(() => {
        // Get user data from location state
        const userData = location.state?.user;
        if (userData) {
            setUser(userData);
            // fetchSubscriptions(userData.id);
        }
    }, [location.state]);

    return (
        <div>
            <h1>{user} Dashboard</h1>
            <p>Welcome to the MentorMatch Dashboard!</p>
        </div>
    );
};

export default Dashboard;
import React, { useState, useEffect } from 'react';
import { Line, Pie } from 'react-chartjs-2';
import { useLocation, useNavigate } from 'react-router-dom';
import { Chart as ChartJS, CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, ArcElement } from 'chart.js';
import './Analytics.css';

ChartJS.register(CategoryScale, LinearScale, PointElement, LineElement, Title, Tooltip, Legend, ArcElement);

const Analytics = () => {
    const [user, setUser] = useState(null);
    const location = useLocation();

    useEffect(() => {
        // Get user data from location state
        const userData = location.state?.user;
        if (userData) {
            setUser(userData);
        }
    }, [location.state]);

    const navigate = useNavigate();

    // Mocked data for the charts
    const lineChartData = {
        labels: ['January', 'February', 'March', 'April', 'May', 'June', 'July'],
        datasets: [
            {
                label: 'Students',
                data: [65, 59, 80, 81, 56, 55, 40],
                fill: false,
                backgroundColor: 'rgba(75,192,192,0.4)',
                borderColor: 'rgba(75,192,192,1)',
            },
            {
                label: 'Mentors',
                data: [28, 48, 40, 19, 86, 27, 90],
                fill: false,
                backgroundColor: 'rgba(153,102,255,0.4)',
                borderColor: 'rgba(153,102,255,1)',
            },
        ],
    };

    const pieChartData = {
        labels: ['Students', 'Mentors'],
        datasets: [
            {
                data: [300, 50],
                backgroundColor: ['#FF6384', '#36A2EB'],
                hoverBackgroundColor: ['#FF6384', '#36A2EB'],
            },
        ],
    };

    const handleLogout = () => {
        navigate('/signin');
    };

    const handleDashboard = () => {
        navigate('/dashboard', { state: { user } });
    };

    return (
        <div className="analytics">
            <header className="analytics-header">
                <h1>Analytics Dashboard</h1>
                <div className="header-buttons">
                    <button className="dashboard-button" onClick={handleDashboard}>
                        Dashboard
                    </button>
                    <button className="logout-button" onClick={handleLogout}>
                        Logout
                    </button>
                </div>
            </header>
            <div className="charts">
                <div className="chart-container">
                    <h2>Student and Mentor Growth Over Time</h2>
                    <Line data={lineChartData} />
                </div>
                <div className="chart-container">
                    <h2>Student vs Mentor Distribution</h2>
                    <Pie data={pieChartData} />
                </div>
            </div>
        </div>
    );
};

export default Analytics;
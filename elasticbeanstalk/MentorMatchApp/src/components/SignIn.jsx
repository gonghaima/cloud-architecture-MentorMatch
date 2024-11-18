import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { baseUrl } from '../config';
import './Auth.css';

const SignIn = () => {
  const navigate = useNavigate();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  const handleSignIn = async (e) => {
    e.preventDefault();

    try {
      const response = await fetch(`${baseUrl}/users-search`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ email }),
      });

      const data = await response.json();
      if (!data) {
        throw new Error('Empty response body');
      }

      console.log(data);
      if (data.length > 0) {
        const user = data[0];
        if (user.password === password) {
          navigate('/dashboard', { state: { user } });
        } else {
          console.error('Invalid password');
        }
      } else {
        console.error('Email not found');
      }
    } catch (error) {
      console.error('Error during sign-in:', error);
    }
  };

  return (
    <div className="form-cont">
      <div className="top-buttons">
        <button
          className="to-signup"
          onClick={() => navigate('/signup')}
        >
          Sign Up
        </button>
        <button
          className="to-signin top-active-button"
        >
          Sign In
        </button>
      </div>
      <div className="form form-signin">
        <form onSubmit={handleSignIn}>
          <label>E-MAIL</label>
          <input
            type="email"
            placeholder="Your e-mail"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
          <label>PASSWORD</label>
          <input
            type="password"
            placeholder="Your password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
          />
          <input type="submit" className="form-btn" value="Sign In" />
          <br />
          <br />
          <Link to="/signup" className="lined-link to-signup-link">
            Create new account
          </Link>
        </form>
      </div>
    </div>
  );
};

export default SignIn;
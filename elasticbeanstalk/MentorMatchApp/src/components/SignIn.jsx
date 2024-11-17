import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './Auth.css';

const SignIn = () => {
  const navigate = useNavigate();

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
        <form>
          <label>E-MAIL</label>
          <input type="email" placeholder="Your e-mail" />
          <label>PASSWORD</label>
          <input type="password" placeholder="Your password" />
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
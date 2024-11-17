import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import './Auth.css';

const SignUp = () => {
    const navigate = useNavigate();

    return (
        <div className="form-cont">
            <div className="top-buttons">
                <button
                    className="to-signup top-active-button"
                >
                    Sign Up
                </button>
                <button
                    className="to-signin"
                    onClick={() => navigate('/signin')}
                >
                    Sign In
                </button>
            </div>
            <div className="form form-signup">
                <form>
                    <label>FULL NAME</label>
                    <input type="text" placeholder="Your full name" />
                    <label>E-MAIL</label>
                    <input type="email" placeholder="Your e-mail" />
                    <label>PASSWORD</label>
                    <input type="password" placeholder="Your password" />
                    <p className="terms">
                        <input type="checkbox" />
                        I agree all statements in{' '}
                        <a href="#" className="lined-link">
                            terms of service
                        </a>
                    </p>
                    <input type="submit" className="form-btn" value="Sign Up" />
                    <br />
                    <br />
                    <Link to="/signin" className="lined-link to-signin-link">
                        I'm already a member
                    </Link>
                </form>
            </div>
        </div>
    );
};

export default SignUp;
import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { CSSTransition } from 'react-transition-group';
import './Auth.css';

const SignUp = () => {
    const nodeRef = React.useRef(null)
    const nodeRef1 = React.useRef(null)
    const [showSignIn, setShowSignIn] = useState(false);

    return (
        <div className="form-cont">
            <div className="top-buttons">
                <button
                    className={`to-signup ${!showSignIn ? 'top-active-button' : ''}`}
                    onClick={() => setShowSignIn(false)}
                >
                    Sign Up
                </button>
                <button
                    className={`to-signin ${showSignIn ? 'top-active-button' : ''}`}
                    onClick={() => setShowSignIn(true)}
                >
                    Sign In
                </button>
            </div>
            <CSSTransition
                in={showSignIn}
                nodeRef={nodeRef}
                timeout={500}
                classNames="form"
                unmountOnExit
            >
                <div className="form form-signup" ref={nodeRef}>
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
            </CSSTransition>
            <CSSTransition
                in={!showSignIn}
                nodeRef={nodeRef1}
                timeout={500}
                classNames="form"
                unmountOnExit
            >
                <div className="form form-signup" ref={nodeRef1}>
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
            </CSSTransition>
        </div>
    );
};

export default SignUp;
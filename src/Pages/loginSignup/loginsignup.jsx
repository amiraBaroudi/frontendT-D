import React, { useState } from "react";
import './loginsignup.css';
import { RiAccountCircleLine, RiLockPasswordFill } from "react-icons/ri";
import axios from "axios";

const Loginsignup = () => {
    const [action, setAction] = useState("Sign Up"); // التحكم بالحالة (تسجيل الدخول أو التسجيل)
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const [accept, setAccept] = useState(false);

    // تغيير الحالة بين تسجيل الدخول والتسجيل
    const toggleAction = () => {
        const newAction = action === "Sign Up" ? "Login" : "Sign Up";
        setAction(newAction);
        setAccept(false);
        setName("");
        setPassword("");
    };

    const handleSubmit = (e) => {
        e.preventDefault();

        if (name === "" || password.length < 8) {
            setAccept(true);
            return;
        }

        setAccept(false);
        const newData = { name, password };

        if (action === "Sign Up") {
            axios
                .post("http://localhost:8000/api/users/create", newData)
                .then((res) => {
                    console.log(res.data);
                    console.log("User created successfully");
                })
                .catch((error) => {
                    console.error("There was an error creating the user!", error);
                });
        } else if (action === "Login") {
            axios
                .post("http://localhost:8000/api/login",{
                username:name,
                password:password,
                })
                .then((res) => {
                    console.log(res.data);
                    console.log("User logged in successfully");
                })
                .catch((error) => {
                    console.error("There was an error logging in!", error);
                });
        }
    };

    return (
        <div className="container2">
            <div className="header">
                <div className="text">{action}</div>
                <div className="underline"></div>
            </div>
            <form onSubmit={handleSubmit}>
                <div className="inputs">
                    <div className="input" style={{ padding: '20px' }}>
                        <RiAccountCircleLine className="icon" />
                        <input
                            type="text"
                            placeholder="UserName"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                        />
                        {name === "" && accept && <p className="erMassage">UserName is Required</p>}
                    </div>
                    <div className="input">
                        <RiLockPasswordFill className="icon" />
                        <input
                            type="password"
                            placeholder="Password"
                            value={password}
                            onChange={(e) => setPassword(e.target.value)}
                        />
                        {password.length < 8 && accept && <p className="erMassage">Password must be more than 8 characters</p>}
                    </div>
                </div>

                <div className="submit-container">
                    {/* زر لتبديل الحالة بين تسجيل الدخول والتسجيل */}
                    <button
                        type="button"
                        className="submit"
                        onClick={toggleAction}
                    >
                        {action === "Sign Up" ? "Switch to Login" : "Switch to Sign Up"}
                    </button>
                    {/* زر لتقديم النموذج */}
                    <button
                        type="submit"
                        className="submit"
                    >
                        {action}
                    </button>
                </div>
            </form>
        </div>
    );
};

export default Loginsignup;

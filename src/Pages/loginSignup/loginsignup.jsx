import React, { useState } from "react";
import './loginsignup.css';
import { RiAccountCircleLine, RiLockPasswordFill } from "react-icons/ri";
import axios from "axios";
import { Button, notification } from 'antd';
import { MdOutlineMailOutline } from "react-icons/md";
import { FaPhoneAlt } from "react-icons/fa";
const Loginsignup = () => {
    const [action, setAction] = useState("Sign Up"); // التحكم بالحالة (تسجيل الدخول أو التسجيل)
    const [name, setName] = useState("");
    const [password, setPassword] = useState("");
    const [accept, setAccept] = useState(false);
    const [api, contextHolder] = notification.useNotification();
    const [email, setEmail] = useState("");
    const [phone, setPhone] = useState('');
    // تغيير الحالة بين تسجيل الدخول وconst openNotification = () => {
        const openNotification = () => {
            api.open({
              message: 'Notification Title',
              description:
                "login sucessfuly",
              className: 'custom-class',
              style: {
                width: 400,
              },
            });
          };
    
    const toggleAction = () => {
        const newAction = action === "Sign Up" ? "Login" : "Sign Up";
        setAction(newAction);
        setAccept(false);
        setName("");
        setPassword("");
    };

    const Submit = (e) => {
        console.log('kdkdk')
        e.preventDefault();

        if (email === "" || password.length < 8) {
            setAccept(true);
            return;
        }

        setAccept(false);
        const newData = { name, password,email, phone_number:phone};

        if (action === "Sign Up") {
            axios
                .post("http://127.0.0.1:8000/api/register", newData)
                .then((res) => {
                    console.log(res.data);
                    console.log("User created successfully");
                    openNotification();
                })
                .catch((error) => {
                    console.error("There was an error creating the user!", error);
                });
        } else if (action === "Login") {
            axios
                .post("http://localhost:8000/api/login",{
                email,
                password:password,
                })
                .then((res) => {
                    console.log(res.data);
                    console.log("User logged in successfully");
                    openNotification();
                      window.location='/dashboard'
                    localStorage.setItem("token",JSON.stringify(res.data.token))
                }
            )
                .catch((error) => {
                openNotification();
                 window.location='/'
                });
        }
    };

    return (
        <div className="container2">
             {contextHolder}
            <div className="header">
                <div className="text">{action}</div>
                <div className="underline"></div>
            </div>
            <form onSubmit={Submit}>
        <div className="inputs">
            <div className="input">
            <MdOutlineMailOutline className="icon"/><input type="email" placeholder="Email" required value={email} onChange={(e) => setEmail(e.target.value)}/>
             
                {email === "" && accept && <p className="erMassage">email is Required</p>}
            </div>
            {action==="Login" ? (<div></div>) : (<div className="input">
                <FaPhoneAlt className="icon"/> <input
                type="text"
                placeholder="PhoneNumber"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
              />
                </div>)}   
            {action==="Login" ? (<div></div>) : (
                <div className="input">
                <RiAccountCircleLine className="icon"/><input type="text" placeholder="UserName" value={name} onChange={(e) => setName(e.target.value)}/>
            </div>)}
            <div className="input">
                <RiLockPasswordFill className="icon"/><input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)}/>
                {password.length < 8 && accept && <p className="erMassage">password must be more than 8 characters</p>}
            </div>
           
        </div>

        {action==="Sign Up"?<div></div>:<div className="forgot-password">Lost Password? <span>Click Here!</span></div>}

        <div className="submit-container">
            <button className={action === "Login" ? "submit gray" : "submit" } onClick={()=>{setAction("Sign Up")}}>Sign Up</button>
            <button className={action === "Sign Up" ? "submit gray" : "submit" } onClick={()=>{setAction("Login")}}>Login</button>
        </div>
        </form>  
        </div>
    );
};

export default Loginsignup;

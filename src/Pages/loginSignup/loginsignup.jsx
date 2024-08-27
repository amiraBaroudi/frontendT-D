import React, { useState } from "react"
import './loginsignup.css'
import { RiAccountCircleLine , RiLockPasswordFill } from "react-icons/ri";
import { FaPhoneAlt } from "react-icons/fa";
import { MdOutlineMailOutline } from "react-icons/md";

const Loginsignup = () => {
const [action,setAction] = useState("Login");
const [name,setName] = useState("");
const [email,setEmail] = useState("");
const [password,setPassword] = useState("");
const [passwordR,setPasswordR] = useState("Login");
const [accept, setAccept] = useState(false);

function Submit(e){
    e.preventDefault();
    setAccept(true);
}
    return(
    <div className="container2">
            <div className="header">
                <div className="text">{action}</div>
                <div className="underline"></div>
            </div>
            <form onSubmit={Submit}>
        <div className="inputs">
            <div className="input" style={{padding:'20px'}}>
                <RiAccountCircleLine className="icon"/><input type="text" placeholder="UserName" value={name} onChange={(e) => setName(e.target.value)}/>
                {name === "" && accept && <p className="erMassage">UserName is Required</p>}
            </div>
            {action==="Login" ? (<div></div>) : (<div className="input">
                <FaPhoneAlt className="icon"/><input type="text" placeholder="PhoneNumber" />
                </div>)}   
            {action==="Login" ? (<div></div>) : (<div className="input">
                <MdOutlineMailOutline className="icon"/><input type="email" placeholder="Email" required value={email} onChange={(e) => setEmail(e.target.value)}/>
            </div>)}
            <div className="input">
                <RiLockPasswordFill className="icon"/><input type="password" placeholder="Password" value={password} onChange={(e) => setPassword(e.target.value)}/>
                {password.length < 8 && accept && <p className="erMassage">password must be more than 8 characters</p>}
            </div>
            {action==="Login" ? (<div></div>) : (<div className="input">
            <RiLockPasswordFill className="icon"/><input type="password" placeholder="RePassword" value={passwordR} onChange={(e) => setPasswordR(e.target.value)}/>
            {passwordR !== password && accept && <p className="erMassage"> password dose not match</p>}
            </div>)}
        </div>

        <div className="submit-container">
            <button className={action === "Login" ? "submit gray" : "submit" } onClick={()=>{setAction("Sign Up")}}>Sign Up</button>
            <button className={action === "Sign Up" ? "submit gray" : "submit" } onClick={()=>{setAction("Login")}}>Login</button>
        </div>
        </form>   
    </div>
    );
};


export default Loginsignup
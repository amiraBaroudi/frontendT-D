import { Link } from "react-router-dom";
import "../../styles/header.css";

function AppHeader() {
  return (
    <div className="AppHeader">
      <LogOut />
    </div>
  );
}

function LogOut() {
  
  return (
    <div className="header__top__right d-flex align-items-center justify-content-end gap-3">
      <Link to="/SignUp" className=" d-flex align-items-center gap-1">
        <i class="ri-login-circle-line"></i> Login
      </Link>
    </div>
  );
}

export default AppHeader;

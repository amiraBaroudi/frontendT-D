import "./App.css";
import Loginsignup from "./Pages/loginSignup/loginsignup";
import FullOrderDetails from "./Pages/FullOrderDetails";
import StaffManage from "./Pages/StaffManage";
import ActiveOrders from "./Pages/ActiveOrders";
import Dashboard from "./Pages/Dashboard";
import DriversManage from "./Pages/DriversManage";
import UsersManage from "./Pages/ManageUser";

import { Routes, Route, Navigate } from "react-router-dom";
import Home from "./Pages/Home";
import About from "./Pages/About";
import CarListing from "./Pages/CarListing";
import CarDetails from "./Pages/CarDetails";
import NotFound from "./Pages/NotFound";
import Contact from "./Pages/Contact";

import OrderHistory from "./Pages/DriverOrderHistory";
import PindingOrderHistory from "./Pages/DriverPindingOr";
import DriverDashboard from "./Pages/DriverDashboard"

const Routers = () => {
  return (
    <Routes>
      <Route path="/" element={<Navigate to="/home" />} />
      <Route path="/home" element={<Home />} />
      <Route path="/about" element={<About />} />
      <Route path="/cars" element={<CarListing />} />
      <Route path="/cars/:slug" element={<CarDetails />} />
      <Route path="/contact" element={<Contact />} />
      <Route path="*" element={<NotFound />} />

      <Route path="OrderHistory" element={<OrderHistory />} />
      <Route path="PindingOrderHistory" element={<PindingOrderHistory />} />
      <Route path="DriverDashboard" element={<DriverDashboard />} />

      <Route path="/Dashboard" element={<Dashboard />}></Route>
      <Route path="/UserManagement" element={<DriversManage />}></Route>
      <Route path="/OrdersSection" element={<FullOrderDetails />}></Route>
      <Route path="/ActiveOrders" element={<ActiveOrders />}></Route>
      <Route path="/DriversManage" element={<DriversManage />}></Route>
      <Route path="/UsersManage" element={<UsersManage />}></Route>
      <Route path="/StaffManage" element={<StaffManage />}></Route>
      <Route path="/FullOrderDetails" element={<FullOrderDetails />}></Route>
      <Route path="/SignUp" element={<Loginsignup />}></Route>
    </Routes>
  );
};

export default Routers;

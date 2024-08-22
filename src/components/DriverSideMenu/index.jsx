import React from "react";
import { Navigation } from "react-minimal-side-navigation";
import "react-minimal-side-navigation/lib/ReactMinimalSideNavigation.css";
import { useNavigate } from "react-router-dom";

const SideMenu = () => {
  const navigate = useNavigate();
  return (
      <Navigation
        activeItemId="/management/members"
        onSelect={({ itemId }) => {
          navigate(itemId);
        }}
        items={[
          {
            title: "Driver Dashboard",
            itemId: "/DriverDashboard",
          },
          {
            title: "Pending Order",
            itemId: "/PendingOrder",
          },
          {
            title: "Order History",
            itemId: "/OrderHistory",
          },
        ]}
      />
  );
}
export default SideMenu;

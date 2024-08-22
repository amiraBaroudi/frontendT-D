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
            title: "Dashboard",
            itemId: "/Dashboard",
          },
          {
            title: "User Management",
            itemId: "/UserManagement",
          },
          {
            title: "Orders Section",
            itemId: "/OrdersSection",
          },
        ]}
      />
  );
}
export default SideMenu;

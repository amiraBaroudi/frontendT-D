import React from "react";
import { Navigation } from "react-minimal-side-navigation";
import "react-minimal-side-navigation/lib/ReactMinimalSideNavigation.css";
import { useNavigate } from "react-router-dom";

function SideMenu() {
  const navigate = useNavigate();

  return (
    <div>
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
            subNav: [
              {
                title: "Drivers",
                itemId: "/DriversManage",
              },
              {
                title: "Client",
                itemId: "/UsersManage",
              },
              {
                title: "Staff",
                itemId: "/StaffManage",
              },
            ],
          },
          {
            title: "Orders Section",
            itemId: "/OrdersSection",

            subNav: [
              {
                title: "Full Order Details",
                itemId: "/FullOrderDetails",
              },
              {
                title: "Active Order Details",
                itemId: "/ActiveOrders",
              },
            ],
          },
        ]}
      />
    </div>
  );
}
export default SideMenu;

import { IoMenu } from "react-icons/io5";
import { Button, Dropdown, Menu } from "antd";
import { useState, navigate } from "react";

function AppHeader() {
  return (
    <div className="AppHeader">
      <LogOut />
    </div>
  );
}

function LogOut() {
  const [visible, setVisible] = useState(false);
  const handleMenuClick = ({ key }) => {
    if (key === "/") {
      navigate("/");
    }
  };
  const menu = (
    <Menu onClick={handleMenuClick}>
      <Menu.Item key="/">Logout</Menu.Item>
    </Menu>
  );
  return (
    <Dropdown
      visible={visible}
      onVisibleChange={(visible) => setVisible(visible)}
      overlay={menu}
      trigger={["click"]}
    >
      <Button type="secondary" shape="circle" icon={<IoMenu />} />
    </Dropdown>
  );
}

export default AppHeader;

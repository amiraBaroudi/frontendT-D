import { Space, Typography, Table } from "antd";
import LayoutWrapper from "../../components/layout";
import axios from "axios";
import { useState, useEffect } from "react";

function ActiveOrders() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}> Users </Typography.Title>
      <Space>
        <RecentOrder />
      </Space>
    </LayoutWrapper>
  );
}

function RecentOrder() {
  const [User, setUser] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:8000/api/users")
      .then((res) => {
        console.log(res.data);
        setUser(res.data.data);
        console.log("User get successfuly");
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  return (
    <Table
      className="table"
      columns={[
        {
          title: "User ID",
          dataIndex: "Id",
        },
        {
          title: "User Name",
          dataIndex: "Text",
        },
        {
          title: "Phone Number",
          dataIndex: "Number",
        },
        {
          title: "Email",
          dataIndex: "Email",
        },
        {
          title: "Password",
          dataIndex: "password",
        },
        {
          title: "Role",
          dataIndex: "boolean",
        },
      ]}
      dataSource={User}
    ></Table>
  );
}
export default ActiveOrders;

import { Space, Typography, Table, Button, Popconfirm } from "antd";
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
        console.log("User get successfully");
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const handleDelete = (userId) => {
    axios
      .delete("http://localhost:8000/api/users/{user}")
      .then(() => {
        setUser(User.filter(user => user.Id !== userId));
        console.log("User deleted successfully");
      })
      .catch((error) => {
        console.log(error);
      });
  };

  const columns = [
    {
      title: "User ID",
      dataIndex: "user_id",
      key: "Id",
    },
    {
      title: "User Name",
      dataIndex: "name",
      key: "Text",
    },
    {
      title: "Phone Number",
      dataIndex: "Number",
      key: "Number",
    },
    {
      title: "Email",
      dataIndex: "Email",
      key: "Email",
    },
    {
      title: "Password",
      dataIndex: "password",
      key: "password",
      render: (text) => <div style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{text}</div>
    },
    {
      title: "Role",
      dataIndex: "boolean",
      key: "boolean",
    },
    {
      title: "Actions",
      key: "actions",
      render: (_, record) => (
        <Space size="middle">
          <Popconfirm
            title="Are you sure you want to delete this user?"
            onConfirm={() => handleDelete(record.Id)}
            okText="Yes"
            cancelText="No"
          >
            <Button danger>Delete</Button>
          </Popconfirm>
        </Space>
      ),
    },
  ];
  return (
    <Table
      className="table"
      columns={columns}
      dataSource={User}
      rowKey="Id" // Add rowKey to ensure unique rows
    />
  );
}

export default ActiveOrders;

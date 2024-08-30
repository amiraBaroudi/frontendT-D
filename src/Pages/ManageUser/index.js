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
  const [users, setUsers] = useState([]);

  useEffect(() => {
    axios
      .get("http://localhost:8000/api/users")
      .then((res) => {
        console.log(res.data);
        setUsers(res.data.data);
        console.log("Users fetched successfully");
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const handleDelete = (userId) => {
    axios
      .delete(`http://localhost:8000/api/users/${userId}`)
      .then(() => {
        setUsers(users.filter(user => user.user_id !== userId));
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
      key: "user_id",
    },
    {
      title: "User Name",
      dataIndex: "name",
      key: "name",
    },
    {
      title: "Phone Number",
      dataIndex: "phone_number", // تأكد من تطابق الحقل مع البيانات الفعلية
      key: "phone_number",
    },
    {
      title: "Email",
      dataIndex: "email", // تأكد من تطابق الحقل مع البيانات الفعلية
      key: "email",
    },
    {
      title: "Password",
      dataIndex: "password",
      key: "password",
      render: (text) => <div style={{ whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis' }}>{text}</div>
    },
    {
      title: "Role",
      dataIndex: "role", // تأكد من تطابق الحقل مع البيانات الفعلية
      key: "role",
    },
    {
      title: "Actions",
      key: "actions",
      render: (_, record) => (
        <Space size="middle">
          <Popconfirm
            title="Are you sure you want to delete this user?"
            onConfirm={() => handleDelete(record.user_id)} // تأكد من تطابق الحقل مع البيانات الفعلية
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
      dataSource={users} // تأكد من تطابق الحقل مع البيانات الفعلية
      rowKey="user_id" // تأكد من تطابق الحقل مع البيانات الفعلية
    />
  );
}

export default ActiveOrders;

import { Space, Typography, Table, Button } from "antd";
import LayoutWrapper from "../../components/layout";
import { useEffect, useState } from "react";
import axios from "axios";

function FullOrderDetails() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}>All Order Details</Typography.Title>
      <Space>
        <AllOrderTable />
      </Space>
    </LayoutWrapper>
  );
}

function AllOrderTable() {
  const [data, setData] = useState([]);
useEffect(() => {/*get*/
  axios
    .get("http://localhost:8000/api/orders")
    .then((res) => {
      setData(res.data.data);
      console.log(res.data.data)
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
          title: "Customer ID",
          dataIndex: "user_id",
        },
        {
          title: "Email",
          dataIndex: "person_firstname",
        },
        {
          title: "Date & Time Pickup",
          dataIndex: "pickup_time",
        },
        {
          title: "email",
          dataIndex: "person_email",
        },
        {
          title: "Date",
          dataIndex: "pickup_date",
        },
        {
          title: "Statuse",
          dataIndex: "status",
        },
        
      ]}
      dataSource={data}
    ></Table>
  );
}

export default FullOrderDetails;

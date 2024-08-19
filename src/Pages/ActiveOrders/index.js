import { Space, Typography, Table } from "antd";
import LayoutWrapper from "../../components/layout";

function Active() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}> Active Orders </Typography.Title>
      <Space>
        <InfoTable />
      </Space>
    </LayoutWrapper>
  );
}

function InfoTable() {
  return (
    <Table
      style={{
        width: 700,
        background: (132, 247, 234, 0.555),
      }}
      columns={[
        {
          title: "Order ID",
          dataIndex: "number",
        },
        {
          title: "Customer ID",
          dataIndex: "number",
        },
        {
          title: "Email",
          dataIndex: "email",
        },
        {
          title: "Pickup Address",
          dataIndex: "address",
        },
        {
          title: "Delivery Address",
          dataIndex: "address",
        },
        {
          title: "Pickup Date",
          dataIndex: "date",
        },
        {
          title: "Pickup Date",
          dataIndex: "date",
        },
        {
          title: "Status",
          dataIndex: "text",
        },
        {
          title: "Action",
          dataIndex: "buttom",
        },
      ]}
    ></Table>
  );
}
export default Active;

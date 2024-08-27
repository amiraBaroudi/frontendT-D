import { Space, Typography, Table } from "antd";
import LayoutWrapper from "../../components/layout";

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
    ></Table>
  );
}
export default ActiveOrders;

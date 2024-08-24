import { Typography, Table } from "antd";
import DriverLayout from "../components/Driverlayout";

const OrderHistory = () => {
    return (
        <DriverLayout>
      <Typography.Title level={4}> Order History </Typography.Title>     
    <Table
      className="table"
      columns={[
        {
          title: "User ID",
          dataIndex: "Id",
        },
        {
          title: "User Name",
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
    </DriverLayout>
  );
}
export default OrderHistory;

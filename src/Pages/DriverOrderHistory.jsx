import { Typography, Table } from "antd";
import DriverLayout from "../../components/DriverLayout";

const ActiveOrders = () => {
    return (
        <DriverLayout>
      <Typography.Title level={4}> Users </Typography.Title>     
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
export default ActiveOrders;

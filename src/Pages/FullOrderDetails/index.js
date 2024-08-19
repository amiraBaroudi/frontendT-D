import { Space, Typography, Table, Button } from "antd";
import LayoutWrapper from "../../components/layout";

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
  return (
    <Table
      className="table"
      columns={[
        {
          title: "Customer ID",
          dataIndex: "driverId",
        },
        {
          title: "Email",
          dataIndex: "driverName",
        },
        {
          title: "Date & Time Pickup",
          dataIndex: "Time",
        },
        {
          title: "Price",
          dataIndex: "price",
        },
        {
          title: "Order Date",
          dataIndex: "",
        },
        {
          title: "Statuse",
          dataIndex: "boolean",
        },
        {
          title: "Action",
          dataIndex: "Button",
          render: () => (
            <Button type="primary" size="small">
              Edit
            </Button>
          ),
        },
      ]}
    ></Table>
  );
}

export default FullOrderDetails;

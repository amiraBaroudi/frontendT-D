import { Card, Space, Statistic, Typography } from "antd";
import { MdEventBusy, MdDriveEta, MdRequestPage } from "react-icons/md";
import { IoPersonOutline } from "react-icons/io5";
import { GoNumber } from "react-icons/go";
import LayoutWrapper from "../../components/layout";

function Dashboard() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}>Statistics</Typography.Title>
      <Space direction="horizontal">
        <StatisticsCard
          style={{
            display: "flex",
            cursor: "pointer",
            borderRadius: "30%",
          }}
          icon={
            <GoNumber
              style={{
                color: "rgb(42, 211, 217)",
                backgroundColor: "rgba(132, 247, 234, 0.555)",
                borderRadius: 20,
                fontSize: 32,
              }}
            />
          }
          title={"Number of client"}
          value={123}
        />
        <StatisticsCard
          icon={
            <MdRequestPage
              style={{
                color: "rgb(42, 211, 217)",
                backgroundColor: "rgba(132, 247, 234, 0.555)",
                borderRadius: 20,
                fontSize: 32,
              }}
            />
          }
          title={"Total number of requests"}
          value={123}
        />
        <StatisticsCard
          icon={
            <MdDriveEta
              style={{
                color: "rgb(42, 211, 217)",
                backgroundColor: "rgba(132, 247, 234, 0.555)",
                borderRadius: 20,
                fontSize: 32,
              }}
            />
          }
          title={"Number of active orders now"}
          value={123}
        />
        <StatisticsCard
          icon={
            <IoPersonOutline
              style={{
                color: "rgb(42, 211, 217)",
                backgroundColor: "rgba(132, 247, 234, 0.555)",
                borderRadius: 20,
                fontSize: 32,
              }}
            />
          }
          title={"Total number of drivers"}
          value={123}
        />
        <StatisticsCard
          icon={
            <MdEventBusy
              style={{
                color: "rgb(42, 211, 217)",
                backgroundColor: "rgba(132, 247, 234, 0.555)",
                borderRadius: 20,
                fontSize: 32,
              }}
            />
          }
          title={"Number of busy drivers"}
          value={123}
        />
      </Space>
    </LayoutWrapper>
  );
}

function StatisticsCard({ title, value, icon }) {
  return (
    <div className="App">
      <Card
        style={{
          width: 150,
          height: 200,
          textAlign: "center",
          fontSize: 25,
          display: "flex",
          justifyContent: "space-around",
          alignItems: "center",
        }}
      >
        <Space direction="horizontal">
          {icon}
          <Statistic title={title} value={value} />
        </Space>
      </Card>
    </div>
  );
}

export default Dashboard;

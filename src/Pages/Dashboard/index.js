import { Card, Space, Statistic, Typography } from "antd";
import { MdEventBusy, MdDriveEta, MdRequestPage } from "react-icons/md";
import { IoPersonOutline } from "react-icons/io5";
import { GoNumber } from "react-icons/go";
import LayoutWrapper from "../../components/layout";
import axios from "axios";
import { useState, useEffect } from "react";

function Dashboard() {
  const [statistics, setStatistics] = useState({
    numberOfClients: 0,
    totalRequests: 0,
    activeOrders: 0,
    totalDrivers: 0,
    busyDrivers: 0,
  });

  useEffect(() => {
    axios
      .get("http://localhost:8000/api/statistics")
      .then((res) => {
        if (res.data && res.data.data && res.data.data.length > 0) {
          const stats = res.data.data[0]; // الحصول على أول كائن من المصفوفة
          setStatistics(stats); // تعيين الكائن إلى الحالة
        }
        console.log("Statistics retrieved successfully");
        console.log("Statistics retrieved successfully", res.data.data);
      })
      .catch((error) => {
        console.error("Error fetching statistics", error);
      });
  }, []);

  return (
    <LayoutWrapper>
      <Typography.Title level={4}>Statistics</Typography.Title>
      <Space direction="horizontal" wrap>
        <StatisticsCard
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
          title="Number of clients"
          value={statistics.numberOfClients}
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
          title="Total number of requests"
          value={statistics.totalRequests}
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
          title="Number of active orders now"
          value={statistics.activeOrders}
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
          title="Total number of drivers"
          value={statistics.totalDrivers}
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
          title="Number of busy drivers"
          value={statistics.busyDrivers}
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

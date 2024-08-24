import React from "react";
import { Flex, Layout } from "antd";
import DriverHeader from "../DriverHeader";
import DriverSideMenu from "../DriverSideMenu";

const { Header, Sider, Content } = Layout;

const headerStyle = {
  background:
    "linear-gradient(90deg, rgba(0, 163, 184, 0.555) 0%, rgba(42, 211, 217, 0.555) 50%, rgba(132, 247, 234, 0.555) 100%)",
  height: "80px",
  display: "flex",
  justifyContent: "space-between",
  alignItems: "center",
  padding: " 4px 20px 4px 12px",
  borderBottom: "1px solid rgba(0, 0, 0, 0.15)",
};
const contentStyle = {
  display: "flex",
  flexDirection: "column",
  paddingLeft: "12px",
  justifyContent: "flex-start",
  alignItems: "center",
  height: "100vh",
  flex: 1,
  
};
const siderStyle = {
  width: "250px",
  padding: "5px",
  borderRight: "1px solid rgba(0, 0, 0, 0.15)",
  background:
    "linear-gradient(90deg, rgba(0, 163, 184, 0.555) 0%, rgba(42, 211, 217, 0.555) 50%, rgba(132, 247, 234, 0.555) 100%)",
};

const layoutStyle = {
  background: "transparent",
  overflow: "hidden",
  width: "calc(100% )",
  maxWidth: "calc(100%)",
};

function LayoutWrapper({ children }) {
  return (
    <Flex gap='middle' wrap height='100vh'>
      <Layout style={layoutStyle}>
        <Header style={headerStyle}>
          <DriverHeader />
        </Header>
        <Layout>
          <Sider width='20%' style={siderStyle}>
            <DriverSideMenu />
          </Sider>
          <Content style={contentStyle}>{children}</Content>
        </Layout>
      </Layout>
    </Flex>
  );
}

export default LayoutWrapper;

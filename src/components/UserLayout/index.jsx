import React from "react";
import { Flex, Layout } from "antd";
import UserHeader from "../UserHeader/index.jsx";
import UserFooter from "../UserFooter/index.jsx";
const { Footer, Content } = Layout;


const UserLayout = ({ children }) => {
  const footerstyle={
    padding:0
  }
  return (
    <Flex >
    <Layout>
      
        <UserHeader />
      
      <Layout>
      <Content>{children}</Content>
      </Layout>
      
    
      <Footer style={footerstyle}>
        <UserFooter />
      </Footer>
      </Layout>
    </Flex>
  );
};

export default UserLayout;

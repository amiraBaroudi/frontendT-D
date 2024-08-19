import React from "react";
import { Container, Row } from "reactstrap";
import Helmet from "../components/UserHelmet/index";
import CommonSection from "../components/UI/CommonSection";
import BlogList from "../components/UI/BlogList";
import UserLayout from "../components/UserLayout"

const Blog = () => {
  return (
  <UserLayout>  
    <Helmet title="Blogs">
      <CommonSection title="Blogs" />
      <section>
        <Container>
          <Row>
            <BlogList />
            <BlogList />
          </Row>
        </Container>
      </section>
    </Helmet>
  </UserLayout>   
  );
};

export default Blog;

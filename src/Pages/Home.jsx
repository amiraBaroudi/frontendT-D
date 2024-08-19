import React from "react";
import HeroSlider from "../components/UI/HeroSlider";
import Helmet from "../components/UserHelmet/index";
import { Container, Row, Col } from "reactstrap";
import AboutSection from "../components/UI/AboutSection";
import ServicesList from "../components/UI/ServicesList";
import carData from "../assets/data/carData";
import CarItem from "../components/UI/CarItem";
import BecomeDriverSection from "../components/UI/BecomeDriverSection";
import Testimonial from "../components/UI/Testimonial";
import UserLayout from "../components/UserLayout"

const Home = () => {
  return (
    <UserLayout>
    <Helmet title="Home">
      {/* ============= hero section =========== */}
      <section className="hero-section">
        <HeroSlider />

        
      </section>
      {/* =========== about section ================ */}
      <AboutSection />
      {/* ========== services section ============ */}
      <section>
        <Container>
          <Row>
            <Col lg="12" className="mb-5 text-center">
              <h6 className="section__subtitle">See our</h6>
              <h2 className="section__title">Popular Services</h2>
            </Col>

            <ServicesList />
          </Row>
        </Container>
      </section>
      <br /><br /><br />
      {/* =========== Our Trucks section ============= */}
      <section>
        <Container>
          <Row>
            <Col lg="12" className="text-center">
              <h6 className="section__subtitle">Come with</h6>
              <h2 className="section__title">Our Trucks</h2>
            </Col>

            {carData.slice(0, 3).map((item) => (
              <CarItem item={item} key={item.id} />
            ))}
          </Row>
        </Container>
      </section>
      {/* =========== become a driver section ============ */}
    
      <BecomeDriverSection />
          
      {/* =========== testimonial section =========== */}
      <section>
        <Container>
          <Row>
            <Col lg="12" className="mb-4 text-center">
              <h6 className="section__subtitle">Our clients says</h6>
              <h2 className="section__title">Testimonials</h2>
            </Col>
            <Testimonial />
          </Row>
        </Container>
      </section>

    </Helmet>
    </UserLayout>
  );
};

export default Home;

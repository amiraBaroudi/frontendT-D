import React from "react";
import { Row } from "reactstrap";
import Helmet from "../components/UserHelmet/index.jsx";
import CommonSection from "../components/UI/CommonSection";
import CarItem from "../components/UI/CarItem";
import carData from "../assets/data/carData";
import UserLayout from "../components/UserLayout"

const CarListing = () => {
  return (
    <UserLayout>
    <Helmet title="Cars">
      <CommonSection title="Car Listing" />

      <section >
      
          <Row>
           {carData.map((item) => (
              <CarItem item={item} key={item.id} />
            ))}
          </Row>
        
      </section>
    </Helmet>
    </UserLayout>
  );
};

export default CarListing;

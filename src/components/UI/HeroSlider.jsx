import React from "react";
import { Container } from "reactstrap";
import { Link } from "react-router-dom";

import "../../styles/hero-slider.css";

const HeroSlider = () => {
  
  return (
  <>

      <div className="slider__item slider__item-02 mt0">
        <Container>
          <div className="slider__content ">
            <h1 className="text-light mb-4">Reserve Now With Us</h1>

            <button className="btn reserve__btn mt-4">
              <Link to="/cars">Reserve Now</Link>
            </button>
          </div>
        </Container>
      </div>
     
      </>
  );
};

export default HeroSlider;

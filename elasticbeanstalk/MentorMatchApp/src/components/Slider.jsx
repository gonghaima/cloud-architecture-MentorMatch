import React from 'react';
import Slider from 'react-slick';
import './Slider.css';

const SliderComponent = () => {
  const settings = {
    dots: true,
    arrows: false,
    autoplay: true,
    autoplaySpeed: 2000,
    slide: false,
    infinite: true,
    useTransform: false,
  };

  return (
    <div className="slider-cont">
      <Slider {...settings} className="signup-slider">
        <div className="img-txt">
          <div className="img-layer"></div>
          <h1>More than a million students have given a score of 5 stars to their tutor</h1>
          <img src="https://static.pexels.com/photos/33972/pexels-photo.jpg" alt="Slide 1" />
        </div>
        <div className="img-txt">
          <div className="img-layer"></div>
          <h1>The Perfect Match</h1>
          <img src="https://static.pexels.com/photos/257897/pexels-photo-257897.jpeg" alt="Slide 2" />
        </div>
        <div className="img-txt">
          <div className="img-layer"></div>
          <h1>Join US Now!</h1>
          <img src="https://static.pexels.com/photos/317383/pexels-photo-317383.jpeg" alt="Slide 3" />
        </div>
      </Slider>
    </div>
  );
};

export default SliderComponent;
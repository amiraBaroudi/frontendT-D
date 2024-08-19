import React from "react";

const Helmet = (props) => {
  document.title = "Rent Car Service - " + props.title;
  return <div className="w-10">{props.children}</div>;
};

export default Helmet;

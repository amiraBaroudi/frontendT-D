import React, { useState } from "react";
import "../../styles/booking-form.css";
import { Form, FormGroup } from "reactstrap";

const BookingForm = () => {
  const [FirstName,setFristName]=useState('')
  const [LastName,setLastName]=useState('')
  const [EmailName,setEmailName]=useState('')
  const [PhoneNum,setPhoneNum]=useState('')
  const [PickupAddress,setPickupAddress]=useState('')
  const [DropoffAddress,setDropoffAddress]=useState('')
  const []=useState('')
  const []=useState('')
  const []=useState('')
  const []=useState('')
  const submitHandler = (event) => {
  
    event.preventDefault();
  };
  
  return (
    <Form onSubmit={submitHandler}>
      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <input type="text" placeholder="First Name" value={FirstName} onChange={(e)=>setFristName(e.target.value)}/>
      </FormGroup>
      <FormGroup className="booking__form d-inline-block ms-1 mb-4">
        <input type="text" placeholder="Last Name" value={LastName} onChange={(e)=>setLastName(e.target.value)}/>
      </FormGroup>

      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <input type="email" placeholder="Email" value={EmailName} onChange={(e)=>setEmailName(e.target.value)}/>
      </FormGroup>
      <FormGroup className="booking__form d-inline-block ms-1 mb-4">
        <input type="number" placeholder="Phone Number"  value={PhoneNum} onChange={(e)=>setPhoneNum(e.target.value)}/>
      </FormGroup>

      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <input type="text" placeholder="Pickup Address"  value={PickupAddress} onChange={(e)=>setPickupAddress(e.target.value)}/>
      </FormGroup>
      <FormGroup className="booking__form d-inline-block ms-1 mb-4">
        <input type="text" placeholder="Dropoff Address"  value={DropoffAddress} onChange={(e)=>setDropoffAddress(e.target.value)}/>
      </FormGroup>

      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <select name="" id="">
          <option value="1 person">Big</option>
          <option value="2 person">Medium</option>
          <option value="3 person">Small</option>
        </select>
      </FormGroup>
      <FormGroup className="booking__form d-inline-block ms-1 mb-4">
        <select name="" id="">
          <option value="1 luggage">Soft</option>
          <option value="2 luggage">Solid</option>
        </select>
      </FormGroup>

      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <select name="" id="">
          <option value="1 person">Breakable</option>
          <option value="2 person">Un Breakable</option>
        </select>
      </FormGroup>
      <FormGroup className="booking__form d-inline-block me-4 mb-4">
        <input type="date" placeholder="Journey Date" />
      </FormGroup>

      <FormGroup className="booking__form d-inline-block ms-1 mb-4">
        <input
          type="time"
          placeholder="Journey Time"
          className="time__picker"
        />
      </FormGroup>

      <FormGroup>
        <textarea
          rows={5}
          type="textarea"
          className="textarea"
          placeholder="Write a note"
        ></textarea>
      </FormGroup>
      <div className="payment text-end mt-5">
        <button type="submit">Reserve Now</button>
      </div>
    </Form>
  );
};

export default BookingForm;

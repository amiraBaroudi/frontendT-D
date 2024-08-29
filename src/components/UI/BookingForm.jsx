import React, { useState } from "react";
import "../../styles/booking-form.css";
import { Form, FormGroup, Modal, ModalHeader, ModalBody, ModalFooter, Input, Button } from "reactstrap";

const BookingForm = () => {
  const [FirstName, setFirstName] = useState('');
  const [LastName, setLastName] = useState('');
  const [EmailName, setEmailName] = useState('');
  const [PhoneNum, setPhoneNum] = useState('');
  const [PickupAddress, setPickupAddress] = useState('');
  const [DropoffAddress, setDropoffAddress] = useState('');
  const [Date, setDate] = useState('');
  const [Time, setTime] = useState('');
  const [Not, setNot] = useState('');

  const [modalOpen, setModalOpen] = useState(false);
  const [itemName, setItemName] = useState('');
  const [itemSize, setItemSize] = useState('');
  const [itemMaterial, setItemMaterial] = useState('');
  const [items, setItems] = useState([]);

  const toggleModal = () => setModalOpen(!modalOpen);

  const handleItemSubmit = () => {
    if (itemName && itemSize && itemMaterial) {
      const newItem = { name: itemName, size: itemSize, material: itemMaterial };
      setItems([...items, newItem]);
      setItemName('');
      setItemSize('');
      setItemMaterial('');
    } else {
      alert("Please fill in all fields");
    }
  };

  const handleAddMoreItems = () => {
    setModalOpen(true);
  };

  const handleRemoveItem = (index) => {
    const updatedItems = items.filter((_, i) => i !== index);
    setItems(updatedItems);
  };

  const submitHandler = (event) => {  
    event.preventDefault();
    // Handle form submission logic here
    console.log("Form submitted with items:", items);
  };

  return (
    <>
      <Form onSubmit={submitHandler}>
        <FormGroup className="booking__form d-inline-block me-4 mb-4">
          <input type="text" placeholder="First Name" value={FirstName} onChange={(e) => setFirstName(e.target.value)} />
        </FormGroup>
        <FormGroup className="booking__form d-inline-block ms-1 mb-4">
          <input type="text" placeholder="Last Name" value={LastName} onChange={(e) => setLastName(e.target.value)} />
        </FormGroup>

        <FormGroup className="booking__form d-inline-block me-4 mb-4">
          <input type="email" placeholder="Email" value={EmailName} onChange={(e) => setEmailName(e.target.value)} />
        </FormGroup>
        <FormGroup className="booking__form d-inline-block ms-1 mb-4">
          <input type="number" placeholder="Phone Number" value={PhoneNum} onChange={(e) => setPhoneNum(e.target.value)} />
        </FormGroup>

        <FormGroup className="booking__form d-inline-block me-4 mb-4">
          <input type="text" placeholder="Pickup Address" value={PickupAddress} onChange={(e) => setPickupAddress(e.target.value)} />
        </FormGroup>
        <FormGroup className="booking__form d-inline-block ms-1 mb-4">
          <input type="text" placeholder="Dropoff Address" value={DropoffAddress} onChange={(e) => setDropoffAddress(e.target.value)} />
        </FormGroup>

        <FormGroup className="booking__form d-inline-block me-4 mb-4">
          <input type="date" placeholder="Journey Date" value={Date} onChange={(e) => setDate(e.target.value)} />
        </FormGroup>

        <FormGroup className="booking__form d-inline-block ms-1 mb-4">
          <input
            type="time"
            placeholder="Journey Time"
            className="time__picker"
            value={Time}
            onChange={(e) => setTime(e.target.value)}
          />
        </FormGroup>

        <FormGroup>
          <textarea
            rows={5}
            type="textarea"
            className="textarea"
            placeholder="Write a note"
            value={Not}
            onChange={(e) => setNot(e.target.value)}
          ></textarea>
        </FormGroup>

        <div className="payment text-end mt-5">
          <Button color="primary" onClick={handleAddMoreItems}>Add Items</Button>
          <Button color="primary" type="submit">Reserve Now</Button>
        </div>
      </Form>

      {/* Modal for item details */}
      <Modal isOpen={modalOpen} toggle={toggleModal}>
        <ModalHeader toggle={toggleModal}>Item Details</ModalHeader>
        <ModalBody>
          <FormGroup>
            <Input
              type="text"
              placeholder="Item Name"
              value={itemName}
              onChange={(e) => setItemName(e.target.value)}
            />
          </FormGroup>
          <FormGroup>
            <Input
              type="select"
              value={itemSize}
              onChange={(e) => setItemSize(e.target.value)}
            >
              <option value="">Select Size</option>
              <option value="Small">Small</option>
              <option value="Medium">Medium</option>
              <option value="Large">Large</option>
            </Input>
          </FormGroup>
          <FormGroup>
            <Input
              type="select"
              value={itemMaterial}
              onChange={(e) => setItemMaterial(e.target.value)}
            >
              <option value="">Select Material</option>
              <option value="Fragile">Fragile</option>
              <option value="Non-Fragile">Non-Fragile</option>
            </Input>
          </FormGroup>
        </ModalBody>
        <ModalFooter>
          <Button color="primary" onClick={handleItemSubmit}>Add Item</Button>
          <Button color="secondary" onClick={toggleModal}>Cancel</Button>
        </ModalFooter>
      </Modal>

      {/* List of items */}
      <div className="item-list mt-4">
        <h5>Items Added:</h5>
        <ul>
          {items.map((item, index) => (
            <li key={index}>
              {item.name} - {item.size} - {item.material}
              <Button color="danger" size="sm" onClick={() => handleRemoveItem(index)} className="ms-2">Remove</Button>
            </li>
          ))}
        </ul>
      </div>
    </>
  );
};

export default BookingForm;

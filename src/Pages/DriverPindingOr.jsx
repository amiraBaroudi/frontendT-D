import React, { useState, useEffect } from "react";
import { Typography, Table, Button, Space, Modal, Spin } from "antd";
import DriverLayout from "../components/DriverLayout";
import axios from "axios";

const PendingOrderHistory = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    // Fetch the list of orders when the component mounts
    axios
      .get("http://localhost:8000/api/orders")
      .then((response) => {
        console.log("Fetched orders:", response.data.data); // تصحيح البيانات
        setOrders(response.data.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching orders:", error);
        setLoading(false);
      });
  }, []);

  const handleConfirmOrder = (orderId) => {
    // Handle order confirmation
    console.log(orderId)
    axios
      .patch(`http://localhost:8000/api/orders/${orderId}/complete`)
      .then((response) => {
        // Update the order list after confirmation
      //  setOrders(orders.map(order => order.id === orderId ? { ...order, status: 'Confirmed' } : order));
        setIsModalOpen(false);
      })
      .catch((error) => {
        console.error("Error confirming order:", error);
        setIsModalOpen(false);
      });
  };

  const columns = [
    {
      title: "order id",
      dataIndex:"order_id",
      key: "person_firstname",
    },
    {
      title: "first name",
      dataIndex: "person_firstname",
      key: "person_firstname",
    },
    {
      title: "last name",
      dataIndex: "person_lastname",
      key: "person_firstname",
    },
    
    {
      title: "Order Date",
      dataIndex: "pickup_date",
      key: "orderDate",
    },
    {
      title: "Status",
      dataIndex: "status",
      key: "status",
    },
    {
      title: "Action",
      key: "action",
      render: (_, record) => (
        <Space size="middle">
          <Button onClick={() => handleViewDetails(record)}>View Details</Button>
          <Button type="primary" onClick={() => {
            setSelectedOrder(record);
            setIsModalOpen(true);
          }}>Confirm Order</Button>
        </Space>
      ),
    },
  ];

  const handleViewDetails = (order) => {
    console.log(selectedOrder)
    // Open a modal to view order details
    setSelectedOrder(order);
    setIsModalOpen(true);
  };

  return (
    <DriverLayout>
      <Typography.Title level={4}>Pending Order History</Typography.Title>

      {loading ? (
        <Spin size="large" />
      ) : (
        <Table
          columns={columns}
          dataSource={orders}
          rowKey="id"
        />
      )}

      <Modal
        title={`Order Details - ${selectedOrder?.order_id}`}
        visible={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        footer={null}
      >
        
        {selectedOrder ? (
          <div>
            <p><strong>Order ID:</strong> {selectedOrder.order_id}</p>
            <p><strong>Customer Name:</strong> {selectedOrder.person_firstname}</p>
            <p><strong>Order Date:</strong> {selectedOrder.pickup_date}</p>
            <p><strong>Status:</strong> {selectedOrder.status}</p>
            <Button type="primary" onClick={() => handleConfirmOrder(selectedOrder.order_id)}>Confirm Order{selectedOrder.id}</Button>
          </div>
        ) : (
          <p>No details available</p>
        )}
      </Modal>
    </DriverLayout>
  );
};

export default PendingOrderHistory;

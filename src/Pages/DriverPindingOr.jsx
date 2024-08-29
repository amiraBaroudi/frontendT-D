import React, { useState, useEffect } from "react";
import { Typography, Table, Button, Space, Modal, Spin } from "antd";
import DriverLayout from "../components/DriverLayout";
import axios from "axios";

const PindingOrderHistory = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    // Fetch the list of orders when the component mounts
    axios
      .get("http://localhost:8000/api/orders")
      .then((response) => {
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
    axios
      .post(`http://localhost:8000/api/orders/${orderId}/confirm`)
      .then((response) => {
        // Update the order list after confirmation
        setOrders(orders.map(order => order.id === orderId ? { ...order, status: 'Confirmed' } : order));
        setIsModalOpen(false);
      })
      .catch((error) => {
        console.error("Error confirming order:", error);
        setIsModalOpen(false);
      });
  };

  const columns = [
    {
      title: "Order ID",
      dataIndex: "id",
      key: "id",
    },
    {
      title: "Customer Name",
      dataIndex: "customerName",
      key: "customerName",
    },
    {
      title: "Order Date",
      dataIndex: "orderDate",
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
    // Open a modal to view order details
    setSelectedOrder(order);
    setIsModalOpen(true);
  };

  return (
    <DriverLayout>
      <Typography.Title level={4}>Pinding Order History</Typography.Title>

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
        title={`Order Details - ${selectedOrder?.id}`}
        visible={isModalOpen}
        onCancel={() => setIsModalOpen(false)}
        footer={null}
      >
        {selectedOrder ? (
          <div>
            <p><strong>Order ID:</strong> {selectedOrder.id}</p>
            <p><strong>Customer Name:</strong> {selectedOrder.customerName}</p>
            <p><strong>Order Date:</strong> {selectedOrder.orderDate}</p>
            <p><strong>Status:</strong> {selectedOrder.status}</p>
            <Button type="primary" onClick={() => handleConfirmOrder(selectedOrder.id)}>Confirm Order</Button>
          </div>
        ) : (
          <p>No details available</p>
        )}
      </Modal>
    </DriverLayout>
  );
};

export default PindingOrderHistory;

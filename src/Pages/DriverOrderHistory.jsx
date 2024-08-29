import React, { useState, useEffect } from "react";
import { Typography, Table, Button, Space, Spin, Modal } from "antd";
import DriverLayout from "../components/DriverLayout";
import axios from "axios";

const OrderHistory = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedOrder, setSelectedOrder] = useState(null);
  const [isModalOpen, setIsModalOpen] = useState(false);

  useEffect(() => {
    // Fetch the list of past orders when the component mounts
    axios
      .get("http://localhost:8000/api/orders/past")
      .then((response) => {
        setOrders(response.data.data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching past orders:", error);
        setLoading(false);
      });
  }, []);

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
        </Space>
      ),
    },
  ];

  const handleViewDetails = (order) => {
    // Set the selected order and open the modal to view details
    setSelectedOrder(order);
    setIsModalOpen(true);
  };

  return (
    <DriverLayout>
      <Typography.Title level={4}>Order History</Typography.Title>
      
      {loading ? (
        <Spin size="large" />
      ) : (
        <Table
          columns={columns}
          dataSource={orders}
          rowKey="id"
          pagination={{ pageSize: 5 }}
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
            <p><strong>Details:</strong> {selectedOrder.details}</p>
          </div>
        ) : (
          <p>No details available</p>
        )}
      </Modal>
    </DriverLayout>
  );
};

export default OrderHistory;

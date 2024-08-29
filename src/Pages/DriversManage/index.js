import { Space, Typography, Table, Modal, Input, Spin, Button } from "antd";
import { EyeInvisibleOutlined, EyeTwoTone } from "@ant-design/icons";
import { useState, useEffect } from "react";
import LayoutWrapper from "../../components/layout";
import "./index.css";
import axios from "axios";

function DriverManage() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}>Drivers</Typography.Title>
      <Space>
        <DriverInputs />
      </Space>
    </LayoutWrapper>
  );
}

function DriverInputs() {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [drivers, setDrivers] = useState([]);
  const [editingDriver, setEditingDriver] = useState(null);
  const [loading, setLoading] = useState(false);
  const [password, setPassword] = useState("");
  const [avilability, setSelectedAvilability] = useState(1);
  const [inputData, setInputData] = useState({});

  useEffect(() => {
    axios
      .get("http://localhost:8000/api/drivers")
      .then((res) => {
        setDrivers(res.data.data);
        console.log("drivers get successfully");
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const handleOk = () => {
    const newData = { ...inputData, password, availability: avilability };
    setLoading(true);

    if (editingDriver) {
      // Edit existing driver
      axios
        .put(`http://localhost:8000/api/drivers/${editingDriver.driver_id}`, newData)
        .then((res) => {
          console.log(res.data);
          setLoading(false);
          setIsModalOpen(false);
          setEditingDriver(null);
          refreshDrivers(); // Refresh the list after editing
        })
        .catch((error) => {
          console.log(error);
          setLoading(false);
        });
    } else {
      // Create new driver
      axios
        .post("http://localhost:8000/api/drivers", newData)
        .then((res) => {
          console.log(res.data);
          setLoading(false);
          setIsModalOpen(false);
          refreshDrivers(); // Refresh the list after adding
        })
        .catch((error) => {
          console.log(error);
          setLoading(false);
        });
    }
  };

  const handleCancel = () => {
    setIsModalOpen(false);
    setEditingDriver(null);
    setInputData({});
    setPassword("");
    setSelectedAvilability(1);
  };

  const handleEdit = (driver) => {
    setEditingDriver(driver);
    setInputData(driver);
    setPassword(driver.password || "");
    setSelectedAvilability(driver.availability || 1);
    setIsModalOpen(true);
  };

  const handleDelete = (driverId) => {
    setLoading(true);
    axios
      .delete(`http://localhost:8000/api/drivers/${driverId}`)
      .then(() => {
        console.log("Driver deleted successfully");
        setLoading(false);
        refreshDrivers(); // Refresh the list after deletion
      })
      .catch((error) => {
        console.log(error);
        setLoading(false);
      });
  };

  const refreshDrivers = () => {
    axios
      .get("http://localhost:8000/api/drivers")
      .then((res) => {
        setDrivers(res.data.data);
        console.log("drivers refreshed successfully");
      })
      .catch((error) => {
        console.log(error);
      });
  };

  const handleLinkClick = () => {
    setIsModalOpen(true);
    setEditingDriver(null); // Reset editing state
  };

  return (
    <>
      <Modal
        title={editingDriver ? "Edit Driver" : "Create New Driver"}
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
      >
        <Spin spinning={loading}>
          <form>
            <Input
              className="input"
              type="text"
              placeholder="username"
              value={inputData.username || ""}
              onChange={(e) => setInputData({ ...inputData, username: e.target.value })}
            />
            <Input.Password
              className="input password-field"
              placeholder="Password"
              value={password}
              iconRender={(visible) => (visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />)}
              onChange={(e) => setPassword(e.target.value)}
            />
            <Input
              className="input"
              type="text"
              placeholder="license Number"
              value={inputData.license_number || ""}
              onChange={(e) => setInputData({ ...inputData, license_number: e.target.value })}
            />
            <Input
              className="input"
              type="text"
              placeholder="Vehicle Type"
              value={inputData.vehicle_type || ""}
              onChange={(e) => setInputData({ ...inputData, vehicle_type: e.target.value })}
            />
            <select className="input" value={avilability} onChange={(e) => setSelectedAvilability(e.target.value)}>
              <option value={0}>Available</option>
              <option value={1}>Unavailable</option>
            </select>
          </form>
        </Spin>
      </Modal>

      <div style={{ display: "flex", alignItems: "center", flexDirection: "column", justifyContent: "center" }}>
        <button className="bb" onClick={handleLinkClick}>
          Create
        </button>

        <Table
          className="table"
          columns={[
            {
              title: "Driver ID",
              dataIndex: "driver_id",
              key: "driver_id",
            },
            {
              title: "User Name",
              dataIndex: "username",
              key: "username",
            },
            {
              title: "Password",
              dataIndex: "password",
              key: "password",
            },
            {
              title: "License Number",
              dataIndex: "license_number",
              key: "license_number",
            },
            {
              title: "Vehicle Type",
              dataIndex: "vehicle_type",
              key: "vehicle_type",
            },
            {
              title: "Availability",
              dataIndex: "availability",
              key: "availability",
            },
            {
              title: "Actions",
              key: "actions",
              render: (_, record) => (
                <Space size="middle">
                  <Button onClick={() => handleEdit(record)}>Edit</Button>
                  <Button onClick={() => handleDelete(record.driver_id)} type="primary" danger>
                    Delete
                  </Button>
                </Space>
              ),
            },
          ]}
          dataSource={drivers}
        />
      </div>
    </>
  );
}

export default DriverManage;

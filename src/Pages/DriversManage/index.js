import { Space, Typography, Table, Modal, Input } from "antd";
import { EyeInvisibleOutlined, EyeTwoTone } from "@ant-design/icons";
import { useState, useEffect } from "react";
import LayoutWrapper from "../../components/layout";
import "./index.css";
import axios from "axios";
import { Spin } from "antd";

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
  useEffect(() => {
    axios
      .get("http://localhost:8000/api/drivers")
      .then((res) => {
        console.log(res.data);
        setDrivers(res.data.data);
        console.log("drivers get successfuly");
      })
      .catch((error) => {
        console.log(error);
      });
  }, []);

  const [loading, setLoading] = useState(false);
  const handleOk = () => {
    const newData = { ...inputData, password, availability: avilability };

    setLoading(true);
    axios
      .post("http://localhost:8000/api/drivers", newData)
      .then((res) => {
        console.log(res.data);
        console.log("drivers added successfuly");
        setLoading(false);
        setIsModalOpen(false);
      })
      .catch((error) => {
        console.log(error);
      });
  };
  const handleCancel = () => {
    setIsModalOpen(false);
  };

  const [action, setAction] = useState("false");

  const handleLinkClick = () => {
    console.log("handleLinkClick called");
    setAction(!action);
    setIsModalOpen(true);
    console.log("action:", action);
  };

  const [password, setPassword] = useState("");
  const [avilability, setSelectedAvilability] = useState(1);
  const [tableData, setTableData] = useState([]);
  const handleAvilability = (event) => {
    setSelectedAvilability(event.target.value);
  };

  const [inputData, setInputData] = useState({});
  const handleSubmit = (e) => {
    e.preventDefault();
    const newData = { ...inputData, password, availability: avilability };
    setTableData([...tableData, newData]);
    setInputData({});
    setPassword("");
    setSelectedAvilability("");
    setIsModalOpen(true);
  };
  return (
    <>
      <Modal
        title="Create New Driver"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
      >
        <Spin spinning={loading}>
          <form onSubmit={handleSubmit}>
            <Input
              className="input"
              type="text"
              placeholder="username"
              value={inputData.username}
              variant="filled"
              onChange={(e) =>
                setInputData({ ...inputData, username: e.target.value })
              }
            />

            <Input.Password
              className="input"
              type="password"
              placeholder="Password"
              value={password}
              variant="filled"
              iconRender={(visible) =>
                visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />
              }
              onChange={(e) => setPassword(e.target.value)}
            />

            <Input
              className="input"
              type="text"
              placeholder="license Number"
              value={inputData.license_number}
              variant="filled"
              onChange={(e) =>
                setInputData({
                  ...inputData,
                  license_number: e.target.value,
                })
              }
            />

            <Input
              className="input"
              type="text"
              placeholder="Vehicle Type"
              value={inputData.vehicle_type}
              variant="filled"
              onChange={(e) =>
                setInputData({
                  ...inputData,
                  vehicle_type: e.target.value,
                })
              }
            />

            <select
              className="input"
              value={avilability}
              onChange={(e) => handleAvilability(e)}
            >
              <option value={0}>Avilable</option>
              <option value={1}>Un Avilable</option>
            </select>
          </form>
        </Spin>
      </Modal>

      <div
        style={{
          display: "flex",
          alignItems: "center",
          flexDirection: "column",
          justifyContent: "center",
        }}
      >
        <button className="bb" type="submit" onClick={handleLinkClick}>
          Create
        </button>

        <Table
          className="table"
          columns={[
            {
              title: "Driver ID",
              dataIndex: "driver_id",
            },
            {
              title: "User Name",
              dataIndex: "username",
            },
            {
              title: "Password",
              dataIndex: "password",
            },
            {
              title: "License Number",
              dataIndex: "license_number",
            },
            {
              title: "Vehicle Type",
              dataIndex: "vehicle_type",
            },
            {
              title: "Avilability",
              dataIndex: "availability",
            },
          ]}
          dataSource={drivers}
        ></Table>
      </div>
    </>
  );
}

export default DriverManage;

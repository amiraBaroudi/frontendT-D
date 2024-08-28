import { Space, Typography, Table, Modal, Input } from "antd";
import { EyeInvisibleOutlined, EyeTwoTone } from "@ant-design/icons";
import { useState } from "react";
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

  const handleOk = () => {
    const newData = { ...inputData, password, role: avilability };
    axios
      .post("http://127.0.0.1:8000/api/drivers", newData)
      .then((res) => {
        console.log(res.data);
        console.log("drivers added successfuly");
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
  const [avilability, setSelectedAvilability] = useState("");
  const [tableData, setTableData] = useState([]);
  const [vehicle_type, setvehicle_type] = useState([]);
  const handleAvilability = (event) => {
    setSelectedAvilability(event.target.value);
  };
  
  const [inputData, setInputData] = useState({});
  const handleSubmit = (e) => {
    e.preventDefault();
    const newData = { ...inputData, password, role: avilability };
    setTableData([...tableData, newData]);
    setInputData({});
    setPassword("");
    setSelectedAvilability("");
  };
  return (
    <>
      <Modal
        title="Create New Driver"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
      >
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
            type="number"
            placeholder="License Number"
            value={inputData.license_number}
            variant="filled"
            onChange={(e) =>
              setInputData({
                ...inputData,
                license_number: e.target.value,
              })
            }
          />
          <select
            className="input"
            value={avilability}
            onChange={(e) => handleAvilability(e)}
          >
            <option value="avilable">Avilable</option>
            <option value="unAvilable">Un Avilable</option>
          </select>

          <select
            className="input"
            value={vehicle_type}
            onChange={(e) => setvehicle_type(e)}
          >
            <option value="Large">Large</option>
            <option value="medium">medium</option>
            <option value="Small">Small</option>
          </select>
        </form>
      </Modal>

      <div style={{display:'flex',alignItems:'center',flexDirection:'column',justifyContent:'center'}}>
        <button className="bb" type="submit" onClick={handleLinkClick}>
          Create
        </button>

        <Table
          className="table"
          columns={[
            {
              title: "Driver ID",
              dataIndex: "driverId",
            },
            {
              title: "User Name",
              dataIndex: "driverName",
            },
            {
              title: "Password",
              dataIndex: "password",
            },
            {
              title: "License Number",
              dataIndex: "number",
            },
            {
              title: "Vehicle Type",
              dataIndex: "boolean",
            },
            {
              title: "Avilability",
              dataIndex: "boolean",
            },
          ]}
        ></Table>
      </div>
    </>
  );
}

export default DriverManage;

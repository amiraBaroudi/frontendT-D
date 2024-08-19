import { Space, Typography, Table, Modal, Input } from "antd";
import { EyeInvisibleOutlined, EyeTwoTone } from "@ant-design/icons";
import { useState } from "react";
import LayoutWrapper from "../../components/layout";
import "./index.css";
function StaffManage() {
  return (
    <LayoutWrapper>
      <Typography.Title level={4}>Staff</Typography.Title>
      <Space>
        <StaffInputs />
      </Space>
    </LayoutWrapper>
  );
}

function StaffInputs() {
  const [isModalOpen, setIsModalOpen] = useState(false);

  const handleOk = () => {
    setIsModalOpen(false);
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
  const [selectedAvilability, setSelectedAvilability] = useState("");
  const [tableData, setTableData] = useState([]);
  const handleAvilability = (event) => {
    setSelectedAvilability(event.target.value);
  };
  const [inputData, setInputData] = useState({});
  const handleSubmit = (e) => {
    e.preventDefault();
    const newData = { ...inputData, password, role: selectedAvilability };
    setTableData([...tableData, newData]);
    setInputData({});
    setPassword("");
    setSelectedAvilability("");
  };
  return (
    <>
      <Modal
        title="Create New Staff"
        open={isModalOpen}
        onOk={handleOk}
        onCancel={handleCancel}
      >
        <form onSubmit={handleSubmit}>
          <Input
            className="input"
            type="number"
            placeholder="Staff ID"
            value={inputData.driverId}
            variant="filled"
            onChange={(e) =>
              setInputData({ ...inputData, driverId: e.target.value })
            }
          />

          <Input
            className="input"
            type="text"
            placeholder="UserName"
            value={inputData.driverName}
            variant="filled"
            onChange={(e) =>
              setInputData({ ...inputData, driverName: e.target.value })
            }
          />

          <Input.Password
            className="input"
            type="password"
            placeholder="Password"
            value={password}
            iconRender={(visible) =>
              visible ? <EyeTwoTone /> : <EyeInvisibleOutlined />
            }
            variant="filled"
            onChange={(e) => setPassword(e.target.value)}
          />

          <select
            className="input"
            value={selectedAvilability}
            onChange={(e) => handleAvilability(e)}
          >
            <option value="unAvilable">Admin</option>
            <option value="unAvilable">Staff</option>
          </select>
        </form>
      </Modal>

      <div className="handleClick">
        <button className="bb" type="submit" onClick={handleLinkClick}>
          Create
        </button>

        <Table
          className="table"
          columns={[
            {
              title: "User ID",
              dataIndex: "driverId",
            },
            {
              title: "UserName",
              dataIndex: "driverName",
            },
            {
              title: "Password",
              dataIndex: "password",
            },
            {
              title: "Role",
              dataIndex: "boolean",
            },
          ]}
        ></Table>
      </div>
    </>
  );
}

export default StaffManage;

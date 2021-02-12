import React, { useState } from "react";
import ReactDOM from 'react-dom';
import { Table, Button, Modal, InputNumber, Select } from "antd";

export function TranchesTable({ stakeFunds }) {

  const [isModalVisible, setIsModalVisible] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const [stakeAmount, setStakeAmount] = useState(0);
  const [stakeToken, setStakeToken] = useState("DAI");
  const { Option } = Select;

  const showModal = () => {
    setIsModalVisible(true);
  };

  const handleSubmit = () => {
    if (stakeAmount > 0) {
      stakeFunds(stakeAmount)
    }
    setIsModalVisible(false);
  };

  const handleCancel = () => {
    setIsModalVisible(false);
  };

  function handleNumberChange(value) {
    setStakeAmount(value);
    console.log(`new amount to stake: ${value}`);
  };

  function handleTokenChange(value) {
    setStakeToken(value);
    console.log(`new Token to stake: ${value}`);
  };

  const dataSource = [
    {
      key: '1',
      strategy: 'Aave V2',
      yield: `${7.46}%`,
      lockup: '3 days',
      poolSize: '245.8',
      stake: <Button type="primary" ghost onClick={showModal}>Stake</Button>,
    },
  ];

  const columns = [
    {
      title: 'Strategy',
      dataIndex: 'strategy',
      key: 'strategy',
    },
    {
      title: 'Yield',
      dataIndex: 'yield',
      key: 'yield',
    },
    {
      title: 'Lockup',
      dataIndex: 'lockup',
      key: 'lockup',
    },
    {
      title: 'Pool Size ($M)',
      dataIndex: 'poolSize',
      key: 'poolSize',
    },
    {
      title: '',
      dataIndex: 'stake',
      key: 'stake',
    },
  ];

  return (
    <div>
      <Table dataSource={dataSource} columns={columns} pagination={false} />
      <Modal
        title="Amount to Stake"
        visible={isModalVisible}
        onOk={handleSubmit}
        onCancel={handleCancel}
        footer={[
          <Button key="back" onClick={handleCancel}>
            Return
          </Button>,
          <Button key="stake" type="primary" loading={isLoading} onClick={handleSubmit}>
            Stake
          </Button>,
        ]}
      >
        <InputNumber min={0} defaultValue={0} onChange={handleNumberChange} />
        <Select defaultValue="DAI" style={{ width: 120 }} onChange={handleTokenChange}>
          <Option value="DAI">DAI</Option>
          <Option value="ETH">ETH</Option>
        </Select>
      </Modal>
    </div>
  );
}

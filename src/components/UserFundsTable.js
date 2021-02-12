import React, { useState } from "react";
import { Table, Button } from "antd";


export function UserFundsTable({ userStakeValue }) {

  const [unlockStarted, setUnlockStarted] = useState(false);

  const startUnlockProcess = () => {
    setUnlockStarted(true);
  };

  const dataSource = [
    {
      key: '1',
      strategy: 'Aave V2',
      currentYield: `${7.46}%`,
      pastYield: `${7.13}%`,
      balance: `$${userStakeValue}.0`,
      startUnlock: <>
        {!unlockStarted&&<Button type="primary" ghost onClick={startUnlockProcess} >Start Unlock</Button>}
        {unlockStarted&&<Button type="primary" ghost disabled >72 hours remaining</Button>}
      </>,
    },
  ];

  const columns = [
    {
      title: 'Strategy',
      dataIndex: 'strategy',
      key: 'strategy',
    },
    {
      title: 'Current Yield',
      dataIndex: 'currentYield',
      key: 'currentYield',
    },
    {
      title: 'Past Yield',
      dataIndex: 'pastYield',
      key: 'pastYield',
    },
    {
      title: 'Balance',
      dataIndex: 'balance',
      key: 'balance',
    },
    {
      title: '',
      dataIndex: 'startUnlock',
      key: 'startUnlock',
    },
  ];

  return (
    <div>
      <Table style={{ marginBottom: 25 }} dataSource={dataSource} columns={columns} pagination={false} />
    </div>
  );
}

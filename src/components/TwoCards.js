import React, { useState } from "react";
import { Card, Row, InputNumber, Select, Button, Space } from "antd";
import 'antd/dist/antd.css';
import './index.css';
import 'antd/lib/style/themes/default.less';
import swivel from '../img/logo.png';
import notional from '../img/notional.png';
import yieldImg from '../img/yield.png';

export function TwoCards({
  approveStakeFunds,
  stakeFunds,
  approveWithdrawStake,
  withdrawStake,
  cancelWithdraw,
  claimFunds,
  userStake,
  earningsPerMonth,
  totalStakedFunds,
  totalAPY,
  timeLock,
  timeLeftForUnlock,
  fundsForUnlock,
  getBest,
  bestYield,
  maturity,
  estAPY,
  estReturn,
})
{
  // console.log(`timeLeftForUnlock in TwoCards is ${timeLeftForUnlock}`)

  const { Option } = Select;
  const initialUnlockState = () => {
    if (timeLeftForUnlock > 0) {
      // 1 means it is during the waiting period
      return "1"
      // needs to be less than zero, otherwise will get called when it shouldn't
    } else if (timeLeftForUnlock < 0) {
      // 2 means funds are available to be withdrawn
      return "2"
    } else {
      // 0 means withdraw period has not begun
      return "0"
    }
  }

  const [stakeAmount, setStakeAmount] = useState(0);
  const [stakeToken, setStakeToken] = useState("DAI");
  const [unlockState, setUnlockState] = useState(initialUnlockState);

  function handleNumberChange(value) {
    setStakeAmount(value);
    console.log(`new amount to stake: ${value}`);
  };

  function handleTokenChange(value) {
    setStakeToken(value);
    console.log(`new Token to stake: ${value}`);
  };
  const getBestYield = async () => {
      console.log('getBestYield',(stakeAmount.toString()));
      await getBest(stakeAmount.toString());
      //console.log('After',getBest.toString());
  };

  // const approveDai = async () => {
  //     console.log('approveDai');
  //     await approveDai();
  //     //console.log('After',getBest.toString());
  // };

  const handleStake = async () => {
    if (stakeAmount > 0) {
      const approvalStatus = await approveStakeFunds();
      if (approvalStatus === "success") {
        await stakeFunds(stakeAmount.toString());
      }
    }
  };

  const startUnlockProcess = async () => {
    const approvalStatus = await approveWithdrawStake();
    if (approvalStatus === "success") {
      const withdrawStatus = await withdrawStake();
      if (withdrawStatus === "success") {
        setUnlockState("1")
      } else {
        setUnlockState("0")
      }
    } else {
      setUnlockState("0")
    }
  };

  const cancelUnlockProcess = async () => {
    const cancelStatus = await cancelWithdraw();
    if (cancelStatus === "success") {
      setUnlockState("0");
    }
  };

  const claimFundsProcess = async () => {
    const claimFundsStatus = await claimFunds();
    if (claimFundsStatus === "success") {
      setUnlockState("0");
    }
  }

  function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }

  return (
    <div>
        <Row>

          <Card
            className="leftCard"
            style={{ backgroundColor: '#e2e8f0',  borderRadius: 30}}
            bordered={true}
          >
            <h4 style={{textAlign:'center'}}>Expected Return</h4>
            <p style={{textAlign:'left', margin:40}}>
              <b>Suggested Maturity</b>
              <span style={{float:'right'}}>
                {maturity}
              </span>
            </p>
            <p style={{textAlign:'left', margin:40}}>
              <b>Estimated APY</b>
              <span style={{float:'right'}}>
                {(estAPY*100).toFixed(2)}%
              </span>
            </p>
            <p style={{textAlign:'left', margin:40}}>
              <b>Estimated Dai Received at Maturity</b>
              <span style={{float:'right'}}>
              ${numberWithCommas(parseFloat(estReturn).toFixed(2))}
              </span>
            </p>
            <h5 style={{textAlign:'left', margin:40}}>
              <b>Best Fixed Rate</b>


            </h5>
            <div style={{ display: 'flex', justifyContent: 'center'}}>
                            <img src={bestYield} width = "175px"></img>
            </div>
          </Card>
          <Card
            className="rightCard"
            style={{ backgroundColor: '#e2e8f0', borderRadius: 30 }}
            bordered={true}
          >
            <h4 style={{textAlign:'center'}}>Lending Protocols</h4>
            <p style={{textAlign:'center', margin:55}}>
              <b><a href="https://notional.finance/" target="_blank"><img src={notional} width = "175px"></img></a></b>
            </p>
            <p style={{textAlign:'center', margin:40}}>
              <b><a href="https://yield.is/" target="_blank"><img src={yieldImg} width = "125px"></img></a></b>
            </p>
            <p style={{textAlign:'center', margin:40}}>
              <b><a href="https://swivel.finance/" target="_blank"><img src={swivel} width = "150px"></img></a></b>
            </p>
            <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 25}}>
              <InputNumber style={{ height: 32 }} min={0} defaultValue={0} onChange={handleNumberChange} />
            </div>
            <div style={{ display: 'flex', justifyContent: 'center'}}>
              <Button
                type="primary"
                style={{
                  display: 'flex',
                  justifyContent: 'center',
                  backgroundColor: '#edf2f7',
                  borderColor: '#99CCFF',
                  color: 'black'
                }}
                onClick={getBestYield}
              >
                Lending Amount
              </Button>
            </div>
          </Card>
        </Row>
    </div>
  );
}

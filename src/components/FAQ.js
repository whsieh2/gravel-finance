import React from "react";
import 'antd/dist/antd.css';
import { Collapse } from 'antd';

const { Panel } = Collapse;

export function FAQ() {

  const jTwit = "https://twitter.com/jack__sanford";
  const eTwit = "https://twitter.com/Evert0x";
  const mMLink = "https://hack.ethglobal.co/showcase/audits-r-dead-%E2%98%A0%EF%B8%8F-recOGX63mU1zXmaEI";
  const kovanETH = "https://faucet.kovan.network/";
  const kovanAaveDai = "https://testnet.aave.com/faucet";

  const q1 = "How does it work?"
  const a1 = "Audits R Dead is an insurance platform designed to provide protocols with affordable, high-quality coverage against smart contract hacks. Anyone can stake in our insurance pool and we aim to offer the highest risk-adjusted return in DeFi. This is made possible by our expert smart contract security team, who reviews and prices insurance for every protocol we cover and has “skin-in-the-game” alongside our stakers. "

  const q2 = "How is it different from other insurance protocols?";
  const a2 = "We think existing insurance is unpopular for two major reasons: 1) Poor user experience and 2) high prices. 1) Nobody likes buying insurance which is why we don’t make you do it. We cover protocols wholesale so users don’t need to worry about it. 2) Existing protocols outsource pricing by either making users decide which protocols are safe or by relying on old audits. We have a team of expert smart contract security analysts who price our insurance and have “skin in the game” alongside our stakers.";

  const q3 = "Why are audits dead?";
  const a3 = "A major reason many protocols pay for expensive audits is to prevent user funds from being stolen. Over the last few months, it has become increasingly clear that audits are not a perfect solution for preventing hacks. We don’t think there is a perfect solution to preventing hacks. Instead, we think the risk of loss should be shifted from unsuspecting users to investors who are looking for a favorable risk-adjusted return. That’s why we built this protocol. ";

  const q4 = "How does staking work?";
  const a4 = "Stakers put their funds in our pool and receive a yield based on protocol insurance fees and current lending protocol rates. These funds cover the risk of smart contract hacks among our partner protocols and can be slashed in the event of a hack. There is currently a 3-day “unlocking” period to withdraw funds from the pool. ";

  const q5 = "How can I get insurance as a protocol?";
  const a5 = "We are currently in a closed beta with a select number of protocols. Please email us at auditsrdead@gmail.com to join the waitlist.";

  const q6 = "How do I start using it on Kovan?";
  const a6 =
  <>
    <p>Get Kovan ETH <a href={kovanETH} target="_blank" rel="noopener noreferrer">here</a>.</p>
    <p>Get Kovan Aave Dai <a href={kovanAaveDai} target="_blank" rel="noopener noreferrer">here</a>.</p>
  </>

  const q7 = "Where can I see the contracts this protocol interacts with?";
  const a7 =
  <>
    <div><b>Contract addresses</b></div>
    <div>Insurance Pool</div>
    <p>0x6E36a59b4b4dBD1d47ca2A6D22A1A45d26765601</p>
    <div>Stake Token</div>
    <p>0x2610C11aB6f7DCa1d8915f328c6995E0c16f5d94</p>
    <div>Strategy Manager</div>
    <p>0x93540d68b2447F924E51caE24c3EAa3AB5516e32</p>
    <div>AaveV2 Strategy (+ swap to AAVE)</div>
    <p>0x5852A4a9687dAFFCd5464a2790d3F4d5E5001A69</p>
    <div>Aave Governance Strategy (+ swap to DAI)</div>
    <p>0xBb8974C5F93ED2935E4E0d9abC95551310c48F62</p>
    <div>Mock Aave token</div>
    <p>0x85821C543d5773cA19b91F5b37e39FeC308C6FA7</p>
    <div>Mock Aave governance</div>
    <p>0x8967a5f5eEcCF3b60Dd299502f8BEbD217268956</p>
    <div>Mock Chainlink oracle</div>
    <p>0xb3Ef934755f162e2Aa1c7Aae4CD6167aE2694d25</p>
    <div></div>
    <div><b>Protocols</b></div>
    <div>Maker</div>
    <p>0x2698812145d22d42d61c043b9933d0771afdf0fad79a42fc985105d0f27141b0</p>
    <div>Yearn</div>
    <p>0xd88eb2629f4cc00a052d4e86cd29a0be2b39e7b0c2fe1c459f7e4c1aa3d4df3b</p>
    <div>PieDAO</div>
    <p>0xc94af803b7bf4f45b7e9822e53806f6d873074abc6cedbfccfa727bf00c623e6</p>
  </>

  return (
    <>
      <h1 style={{textAlign:'center', marginTop: 30 }}><b>FAQ</b></h1>
      <Collapse defaultActiveKey={['1']} ghost>
        <Panel header=<b>{q1}</b> key="1" style={{fontSize: 16}}>
          <p>{a1}</p>
        </Panel>
        <Panel header=<b>{q2}</b> key="2" style={{fontSize: 16}}>
          <p>{a2}</p>
        </Panel>
        <Panel header=<b>{q3}</b> key="3" style={{fontSize: 16}}>
          <p>{a3}</p>
        </Panel>
        <Panel header=<b>{q4}</b> key="4" style={{fontSize: 16}}>
          <p>{a4}</p>
        </Panel>
        <Panel header=<b>{q5}</b> key="5" style={{fontSize: 16}}>
          <p>{a5}</p>
        </Panel>
        <Panel header=<b>{q6}</b> key="6" style={{fontSize: 16}}>
          <p>{a6}</p>
        </Panel>
        <Panel header=<b>{q7}</b> key="7" style={{fontSize: 16}}>
          <p>{a7}</p>
        </Panel>
      </Collapse>
      <p style={{textAlign:'center', fontSize: 12, marginTop: 100 }}>
        Created by <a href={jTwit} target="_blank" rel="noopener noreferrer">Jack</a> and <a href={eTwit} target="_blank" rel="noopener noreferrer">Evert</a> for the <a href={mMLink} target="_blank" rel="noopener noreferrer">ETHGlobal MarketMake</a> hackathon.
      </p>
      <p style={{textAlign:'center', fontSize: 12, marginTop: -10}}>
        Reach us at auditsrdead@gmail.com.
      </p>
  </>
  );
}

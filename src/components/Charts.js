import React, { PureComponent } from 'react';
import {
  PieChart, Pie, Cell, ResponsiveContainer,
} from 'recharts';
import { Loading } from "./Loading";
const { utils } = require("ethers");

const images = {
    Aave: "/AaveLogo.png",
    Compound: "/CompoundLogo.png",
    Maker: "/MakerLogo.jpg",
    PieDAO: "/PieDAOLogo.png",
    'Aave V2': "/AaveLogo.png",
    'Aave Gov': "/AaveLogo.png",
    Yearn: "/YearnLogo.png",
  }

const COVERED_COLORS = ['#0088FE', '#00C49F', '#cb1a8f'];
const POOL_COLORS = ['#2ebac6', '#b6509e'];


const RADIAN = Math.PI / 180;
const renderCustomizedLabel = ({
  cx, cy, midAngle, innerRadius, outerRadius, name, value, index,
}) => {
  const outsideRadius = innerRadius + (outerRadius - innerRadius) * 1.1;
  const outsideX = cx + outsideRadius * Math.cos(-midAngle * RADIAN);
  // adjust based on text length
  const adjOutsideX = outsideX > cx ? outsideX - 0 : outsideX - 85;
  const outsideY = cy + outsideRadius * Math.sin(-midAngle * RADIAN);
  // adjust based on text length
  const adjOutsideY = outsideY > cy ? outsideY -20 : outsideY - 20;
  const insideRadius = innerRadius + (outerRadius - innerRadius) * 0.5;
  const insideX = cx + insideRadius * Math.cos(-midAngle * RADIAN);
  const insideY = cy + insideRadius * Math.sin(-midAngle * RADIAN);

  return (
    <>
      <foreignObject x={adjOutsideX} y={adjOutsideY} width={500} height={500}>
        <div display="flex" alignitems="center" flexdirection="row">
          <div xmlns="http://www.w3.org/1999/xhtml" style={{fontSize:"1.25vw"}}>
            <img xmlns="http://www.w3.org/1999/xhtml" src={images[name]} width="22px" height="22px" alt="logo" />
            {` ${name}`}
          </div>
        </div>
      </foreignObject>

      <text
        x={insideX}
        y={insideY}
        fill="black"
        textAnchor={insideX > cx ? 'start' : 'end'}
        dominantBaseline="central"
        fontSize="1.25vw"
      >
        {`$${value}M`}
      </text>
    </>
  );
};

export default class Charts extends PureComponent {
  constructor(props) {
    super(props);

    const yearnCoveredFunds = this.props.protCoveredFundsObj[utils.hashMessage("protocol.yearn")];
    const makerCoveredFunds = this.props.protCoveredFundsObj[utils.hashMessage("protocol.maker")];
    const pieDAOCoveredFunds = this.props.protCoveredFundsObj[utils.hashMessage("protocol.piedao")];

    this.protocolData = [
      { name: 'Yearn', value: yearnCoveredFunds/1000000 },
      { name: 'Maker', value: makerCoveredFunds/1000000 },
      { name: 'PieDAO', value: pieDAOCoveredFunds/1000000 },
    ];

    this.poolData = [
      { name: 'Aave V2', value: parseFloat((this.props.daiAaveStrategyFunds/1000000).toFixed(0)) },
      { name: 'Aave Gov', value: parseFloat(((this.props.totalStakedFunds-this.props.daiAaveStrategyFunds)/1000000).toFixed(0)) },
    ];
  }
  render() {

    if (!this.props.totalStakedFunds || !this.props.totalCoveredFunds) {
      return <Loading />;
    }

    return (
    <>
      <h2 style={{ marginLeft: '15%', float: 'left', fontSize: '2vw' }}>Covered Protocols</h2>
      <h2 style={{ marginRight: '18.5%', float: 'right', fontSize: '2vw' }}>Pool Strategies</h2>
      <ResponsiveContainer width='99%' aspect={2.5}>
        <PieChart style={{ marginBottom: "10px" }}>
          <Pie
            data={this.protocolData}
            cx="25%"
            cy="50%"
            labelLine={false}
            label={renderCustomizedLabel}
            outerRadius="67%"
            fill="#8884d8"
            dataKey="value"
          >
            {
              this.protocolData.map((entry, index) => <Cell key={`cell-${index}`} fill={COVERED_COLORS[index % COVERED_COLORS.length]} />)
            }
          </Pie>





          <Pie
            data={this.poolData}
            cx="75%"
            cy="50%"
            labelLine={false}
            label={renderCustomizedLabel}
            outerRadius="67%"
            fill="#8884d8"
            dataKey="value"
          >
            {
              this.poolData.map((entry, index) => <Cell key={`cell-${index}`} fill={POOL_COLORS[index % POOL_COLORS.length]} />)
            }
          </Pie>
        </PieChart>
      </ResponsiveContainer>
      <h2 style={{ marginLeft: '16%', float: 'left', fontSize: '1.5vw' }}>Total Covered: ${(this.props.totalCoveredFunds/1000000).toFixed(0).toString()}M</h2>
      <h2 style={{ marginRight: '17.5%', float: 'right', fontSize: '1.5vw' }}>Total Locked: ${(this.props.totalStakedFunds/1000000).toFixed(0).toString()}M</h2>
    </>
    );
  }
}

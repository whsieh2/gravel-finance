//By: William Hsieh

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;
import './Hash.sol';
import './Sig.sol';

abstract contract Notional {
    function getCurrentCashTofCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);
    function getfCashToCurrentCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);

        // Defines the fields for each market in each maturity.
    struct Market {
        // Total amount of fCash available for purchase in the market.
        uint128 totalfCash;
        // Total amount of liquidity tokens (representing a claim on liquidity) in the market.
        uint128 totalLiquidity;
        // Total amount of cash available for purchase in the market.
        uint128 totalCurrentCash;
        // These factors are set when the market is instantiated by a liquidity provider via the global
        // settings and then held constant for the duration of the maturity. We cannot change them without
        // really messing up the market rates.
        uint16 rateScalar;
        uint32 rateAnchor;
        // This is the implied rate that we use to smooth the anchor rate between trades.
        uint32 lastImpliedRate;
    }
    function getMarket(uint32 maturity) external virtual returns (Market memory);
    function takefCash(uint32 maturity, uint128 fCashAmount, uint32 maxTime, uint128 minImpliedRate) external virtual returns (uint128);
}


abstract contract Yield {
    function buyFYDaiPreview(uint128 fyDaiOut) external virtual returns(uint128);
    function getFYDaiReserves() external virtual returns(uint128);
    function sellDaiPreview(uint128 daiIn) external virtual returns(uint128);
    function sellDai(address from, address to, uint128 daiIn) external virtual returns(uint128);
    uint128 public maturity;

}

abstract contract Erc20 {
	function approve(address, uint) virtual external returns (bool);
	function transfer(address, uint) virtual external returns (bool);
	function balanceOf(address _owner) virtual external returns (uint256 balance);
	function transferFrom(address sender, address recipient, uint256 amount) virtual public returns (bool);
}

abstract contract Erc1155 {
    function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _value, bytes calldata _data) virtual external;
    function setApprovalForAll(address _operator, bool _approved) virtual external;
}

abstract contract Swivel{
    function batchFillFloating( Hash.Order[] calldata o, uint256[] calldata a, bytes32 k, Sig.Components[] calldata c) virtual external;
    function fillFixed( Hash.Order calldata o, uint256 a, bytes32 k, Sig.Components calldata c) virtual external;
    function fillFloating( Hash.Order calldata o, uint256 a, bytes32 k, Sig.Components calldata c) virtual external;


}

contract Gravel {
    //Contract address goes into the () below. Main next
    // Notional notional = Notional(0x307885bb78D490cF9198D678F8B2D1058D741F93);

    //Test net addr.
    //Constructor for contract
    constructor(){


    }

    uint128 public yield21Mar31Return;
    uint128 public yield21Jun30Return;

    uint256 public yield21Mar31AnnualizedYield;
    uint256 public yield21Jun30AnnualizedYield;

    uint128 public yield21Mar31Maturity;
    uint128 public yield21Jun30Maturity;

    uint256 public yieldBestYield;
    uint256 public yieldJunBestYield;
    uint256 public yieldMarBestYield;

    uint256 public swivelBestYield;
    uint256 public swivelReturn;
    uint32 public bestYield;

    uint256 public yield21Jun30Yield;
    uint256 public yield21Mar31Yield;

    //If True, earlier maturity is the higher yield, else the latter.
    bool public yieldMarSelect;
    //If True, yield is best; else notional
    bool public yieldIsBest;

    bool bestSelect;
    enum best{
        NOAPR,
        NOJUL,
        YIMAR,
        YIJUN
    }
    uint128 public  returnme;
    uint128 public shouldbe;
    /// @notice Given the amount of fCash put into a market, how much yield at the current block.
    /// @param daiIn: the amount of Dai to lend out to the Yield protocol
    /// @return the enum-like value that represents the best APY rate lending protocol.
    // Step 1. Establish Yield's Yield/Second
    // Step 2. Yield/Second * Notional remaining maturity
    // Step 3. Multiply times principal and normalize value
    // Step 4. getCurrentCashTofCash(value)
    // Step 5. if return < principal, Yield > notional
    //NA:2.55%, NJ:10%, YM:7.5%. YJ:6.50%
    function getBest(uint128 daiIn,Hash.Order[] calldata o, uint256[] calldata orderVolume, bytes32 agreementKey, Sig.Components[] calldata c) public returns(uint32){
        bestYield = 0;

        Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
        _erc20.transferFrom(msg.sender, address(this), daiIn);

        yieldMarBestYield = yieldMar(daiIn);
        yieldJunBestYield = yieldJun(daiIn);

        //get best Yield's yield
        (yieldMarSelect, yieldBestYield) = (yieldMarBestYield>yieldJunBestYield ? (true, yieldMarBestYield):(false, yieldJunBestYield));

        swivelBestYield = SwivelYield(o, orderVolume, agreementKey, c);

        bestSelect = (yieldBestYield>swivelBestYield? true:false);


        if(bestSelect){
            if (yieldMarSelect)
            {
                bestYield = 3;
                _erc20.approve(0x08cc239a994A10118CfdeEa9B849C9c674C093d3,daiIn);
                Yield yield = Yield(0x08cc239a994A10118CfdeEa9B849C9c674C093d3);
                yield.sellDai(address(this),msg.sender, daiIn);

            }
            else
            {
                bestYield = 4;
                _erc20.approve(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA,daiIn);
                Yield yield = Yield(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA);
                yield.sellDai(address(this),msg.sender, daiIn);
            }
        }
        else{
            bestYield = 1;
            SwivelFinanceBatch(o, orderVolume, agreementKey, c);
        }

        return bestYield;
    }

    /// @notice Given the amount of Dai put into a market, what is the expected APY for Yield protocol
    /// @param daiIn: amount of Dai to lend on the Yield protocol with a maturity set to March.
    /// @return the APY for Yield protocol with a maturity set to March
    function yieldMar(uint128 daiIn) public returns(uint256){
        Yield yield = Yield(0x08cc239a994A10118CfdeEa9B849C9c674C093d3);

        yield21Mar31Maturity = yield.maturity();
        yield21Mar31Return = yield.sellDaiPreview(daiIn);

        uint256 returnDifference  =  yield21Mar31Return - daiIn;
        yield21Mar31Yield = ((returnDifference*1e26)/daiIn)/1e15;

        uint256 yieldTimeDiff = yield21Mar31Maturity - block.timestamp;

        uint256 yieldAnnualizedTimeDiff = (31536000*1e26/yieldTimeDiff)/1e15;

        yield21Mar31AnnualizedYield = (yieldAnnualizedTimeDiff*yield21Mar31Yield/1e9);//*1e26)/1e26;

        // True value is yield21Mar31AnnualizedYield/1e13
        return yield21Mar31AnnualizedYield;
    }

    /// @notice Given the amount of Dai put into a market, what is the expected APY for Yield protocol
    /// @param daiIn: amount of Dai to lend on the Yield protocol with a maturity set to March.
    /// @return the APY for Yield protocol with a maturity set to June, with 1e13 decimal precision
    function yieldJun(uint128 daiIn) public returns(uint256){
        Yield yield = Yield(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA);

        yield21Jun30Maturity = yield.maturity();
        yield21Jun30Return = yield.sellDaiPreview(daiIn);

        uint256 returnDifference  =  yield21Jun30Return - daiIn;

        yield21Jun30Yield = ((returnDifference*1e26)/daiIn)/1e15;

        uint256 yieldTimeDiff = yield21Jun30Maturity - block.timestamp;

        uint256 yieldAnnualizedTimeDiff = (31536000*1e26/yieldTimeDiff)/1e15;

        yield21Jun30AnnualizedYield = (yieldAnnualizedTimeDiff*yield21Jun30Yield/1e9);//*1e26)/1e26;


        return yield21Jun30AnnualizedYield;

    }
    function sellDaiTest(uint128 daiIn) public returns(uint128){

        Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);

        _erc20.approve(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA, daiIn);

        _erc20.transferFrom(msg.sender, address(this), daiIn);


        Yield yield = Yield(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA);
        returnme = yield.sellDai(address(this),msg.sender, daiIn);

        return returnme;
    }


    //Hash.Order[] calldata o, uint256[] calldata a, bytes32 k, Sig.Components[] calldata c
    function SwivelFinanceBatch(Hash.Order[] calldata o, uint256[] calldata orderVolume, bytes32 agreementKey, Sig.Components[] calldata c) public returns(uint128){

        uint256 daiInSum = 0;
        //Swivel.sol contract address
        Swivel swivel = Swivel(0x33E17F512a509D592a484BfD34B1B6feD5815658);

        Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);

        for (uint256 i =0; i< orderVolume.length; i++){
            daiInSum += orderVolume[i];
        }

        _erc20.approve(0x33E17F512a509D592a484BfD34B1B6feD5815658, daiInSum);


        //a = daiIn
        swivel.batchFillFloating(o, orderVolume, agreementKey, c);

        return 0;

    }
    //Hash.Order calldata o, uint256 a, bytes32 k, Sig.Components[] calldata c
    function SwivelFinanceSingle(Hash.Order calldata o, uint256 orderVolume, bytes32 agreementKey, Sig.Components calldata c) public returns(uint128){

    //Swivel.sol contract address
    Swivel swivel = Swivel(0x33E17F512a509D592a484BfD34B1B6feD5815658);

    Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);


    _erc20.transferFrom(msg.sender, address(this), orderVolume);

     _erc20.approve(0x33E17F512a509D592a484BfD34B1B6feD5815658, orderVolume);


    //a = daiIn
    swivel.fillFloating(o, orderVolume, agreementKey, c);

    return 0;

    }
    function SwivelYield(Hash.Order[] calldata o, uint256[] calldata orderVolume, bytes32 agreementKey, Sig.Components[] calldata c) public returns(uint256){
        //Swivel.sol contract address
        //wivel swivel = Swivel(0x33E17F512a509D592a484BfD34B1B6feD5815658);
        uint256 effective_rate = 0;

        for (uint256 i = 0; i <o.length; i++)
        {

            //rate = ((o[i].interest*1e26)/o[i].principal)/1e21;
            //annualized_rate = (rate*31536000*1e26/(o[i].duration))/1e15;
            uint256 rate;
            {
                rate = ((o[i].interest*1e26)/o[i].principal)/1e21;
            }
            uint256 annualized_rate;
            {
                annualized_rate = (rate*31536000*1e26/(o[i].duration))/1e15;
            }
            effective_rate += annualized_rate;

        }
        effective_rate = effective_rate/10;
        return effective_rate;
    }

}

//By: William Hsieh

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


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

contract Gravel {
    //Contract address goes into the () below. Main next
    // Notional notional = Notional(0x307885bb78D490cF9198D678F8B2D1058D741F93);

    //Test net addr.
    //Constructor for contract
    constructor(){


    }

    uint128 public currentCashtofCashApril;
    uint128 public currentCashtofCashJuly;

    uint128 public yield21Mar31Return;
    uint128 public yield21Jun30Return;

    uint256 public yield21Mar31AnnualizedYield;
    uint256 public yield21Jun30AnnualizedYield;

    uint128 public yield21Mar31Maturity;
    uint128 public yield21Jun30Maturity;

    uint256 public yieldBestYield;
    uint256 public yieldJunBestYield;
    uint256 public yieldMarBestYield;

    uint32 public notionalBestYield;

    uint32 public bestYield;

    uint32 public notionalAprilBestYield;
    uint32 public notionalJulyBestYield;

    uint256 public yield21Jun30Yield;
    uint256 public yield21Mar31Yield;

    //If True, earlier maturity is the higher yield, else the latter.
    bool public notionalAprSelect;
    bool public yieldMarSelect;
    //If True, yield is best; else notional
    bool public yieldIsBest;

    uint256 public normalizedCashApr;
    uint256 public normalizedCashJul;

    uint256 public fCashApr;
    uint256 public fCashJul;

    uint256 public AprImpliedRate;
    uint256 public JulImpliedRate;

    uint256 public AnnualAprImpliedRate;
    uint256 public AnnualJulImpliedRate;

    uint256 public NotExpectedAprReturn;
    uint256 public NotExpectedJulReturn;
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
    function getBest(uint128 daiIn) public returns(uint32){
        bestYield = 0;

        daiIn = daiIn*1e18;


        Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);
        _erc20.transferFrom(msg.sender, address(this), daiIn);

        uint256 timeDiffApr =  1617408000 - block.timestamp;
        uint256 timeDiffJul =  1625184000 - block.timestamp;

        //Notional Maturity with best APY
        uint256 bestNotional;

        Notional notional = Notional(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9);

        yieldMarBestYield = yieldMar(daiIn);
        yieldJunBestYield = yieldJun(daiIn);

        //get best Yield's yield
        (yieldMarSelect, yieldBestYield) = (yieldMarBestYield>yieldJunBestYield ? (true, yieldMarBestYield):(false, yieldJunBestYield));

        //Notional Principle*(Notional Remaining Maturity) * (Yield's Yield/Second)
        normalizedCashApr = ((daiIn*timeDiffApr)*(yieldBestYield/1e11)*1e26/31536000)/1e26;
        normalizedCashJul = ((daiIn*timeDiffJul)*(yieldBestYield/1e11)*1e26/31536000)/1e26;

        //Step 4. getCurrentCashTofCash(value)

        currentCashtofCashApril = notional.getCurrentCashTofCash(1617408000, uint128(normalizedCashApr));
        currentCashtofCashJuly = notional.getCurrentCashTofCash(1625184000, uint128(normalizedCashJul));

        fCashApr = notional.getCurrentCashTofCash(1617408000, uint128(daiIn));
        fCashJul = notional.getCurrentCashTofCash(1625184000, uint128(daiIn));

        AprImpliedRate= notional.getMarket(1617408000).lastImpliedRate;
        JulImpliedRate= notional.getMarket(1625184000).lastImpliedRate;

        AnnualAprImpliedRate = AprImpliedRate*(31536000*1e26/timeDiffApr)/1e26;
        AnnualJulImpliedRate = JulImpliedRate*(31536000*1e26/timeDiffJul)/1e26;

        NotExpectedAprReturn = (AprImpliedRate*daiIn);
        NotExpectedJulReturn = (JulImpliedRate*daiIn);

        (notionalAprSelect, bestNotional) = (currentCashtofCashApril>currentCashtofCashJuly? (true, currentCashtofCashApril):( false, currentCashtofCashJuly));
        // NOAPR, = 1
        // NOJUL, = 2
        // YIMAR, = 3
        // YIJUN  = 4


        //	function approve(address, uint) virtual external returns (bool);
        if (notionalAprSelect)
        {
            if(bestNotional<normalizedCashApr)
            {
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
            //takefCash(uint32 maturity, uint128 fCashAmount, uint32 maxTime, uint128 minImpliedRate)
            else
            {
                bestYield = 1;
                _erc20.approve(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9, daiIn);
                notional.takefCash(1617408000, daiIn, uint32(block.timestamp), uint128(AprImpliedRate));

            }

        }
        else
        {
            if(bestNotional<normalizedCashJul)
            {
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
            else
            {
                bestYield = 2;
                _erc20.approve(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9, daiIn);
                notional.takefCash(1625184000, daiIn, uint32(block.timestamp), uint128(AprImpliedRate));
            }
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
        daiIn = daiIn*1e18;

        Erc20 _erc20 = Erc20(0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa);

        _erc20.transferFrom(msg.sender, address(this), daiIn);

        _erc20.approve(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA, daiIn);

        Yield yield = Yield(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA);
        returnme = yield.sellDai(address(this),msg.sender, daiIn);

        return returnme;
    }

}

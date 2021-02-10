//By: William Hsieh

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


abstract contract Notional {
    function getMarketRates() external virtual returns (uint32[] memory);
    function getCurrentCashTofCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);
    function getfCashToCurrentCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);

    function getActiveMaturities() external virtual returns (uint32[] memory);


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
}


abstract contract Yield {
    function buyFYDaiPreview(uint128 fyDaiOut) external virtual returns(uint128);
    function getFYDaiReserves() external virtual returns(uint128);
    function sellDaiPreview(uint128 daiIn) external virtual returns(uint128);
    uint128 public maturity;

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

    uint256 public bestYield;

    uint32 public notionalAprilBestYield;
    uint32 public notionalJulyBestYield;

    uint256 public yield21Jun30Yield;
    uint256 public yield21Mar31Yield;

    //If True, earlier maturity is the higher yield, else the latter.
    bool public notionalAprSelect;
    bool public yieldMarSelect;
    //If True, yield is best; else notional
    bool public yieldIsBest;

    //100000000000000000
    // Step 1. Establish Yield's Yield/Second
    // Step 2. Yield/Second * Notional remaining maturity
    // Step 3. Multiply times principal and normalize value
    // Step 4. getCurrentCashTofCash(value)
    // Step 5. if return < principal, Yield > notional
    //NA:2.55%, NJ:10%, YM:7.5%. YJ:6.50%
    function GetBest(uint128 daiIn, uint128 amount) public returns(uint256){

        uint256 normalizedCashApr;
        uint256 normalizedCashJul;

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
        normalizedCashApr = ((amount*timeDiffApr)*yieldBestYield*1e26/31536000)/1e9;
        normalizedCashJul = ((amount*timeDiffJul)*yieldBestYield*1e26/31536000)/1e9;

        //Best
        //Need to use each individual maturity normalized amt for each getCurrentCashtofCash
        //normalizedBestYield = (normalizedCashAprYield>normalizedCashJulYield ? normalizedCashAprYield:normalizedCashJulYield);
        //Step 4. getCurrentCashTofCash(value)

        currentCashtofCashApril = notional.getCurrentCashTofCash(1617408000, uint128(normalizedCashApr));
        currentCashtofCashJuly = notional.getCurrentCashTofCash(1625184000, uint128(normalizedCashJul));

        (notionalAprSelect, bestNotional) = (currentCashtofCashApril>currentCashtofCashJuly? (true, currentCashtofCashApril):( false, currentCashtofCashJuly));

        if (notionalAprSelect)
        {
            if(bestNotional<currentCashtofCashApril)
            {
                yieldIsBest = true;

            }
            else
            {
                yieldIsBest = false;
            }

        }
        else
        {
            if(bestNotional>currentCashtofCashJuly)
            {
                yieldIsBest = true;

            }
            else
            {
                yieldIsBest = false;
            }

        }
        //TODO: Figure out which APY to return. Yield APY available. Notional APY is not.
        //bestYield = (bestNotional>amount?:bestNotional/amount:yieldBestYield);
        //notionalBestYield

        //bestYield = (yieldBestYield>notionalBestYield? yieldBestYield:notionalBestYield);

        return bestYield;
    }

    //PoC Function
    // Expected: 7.64%
    // Actual: 7.411%
    // Actual: 35057658552965739912496
    /// @notice
    /// @return
    // Maths:
    //  ((31536000)/(1617235199-1612664008))*
    //  ((101074285681244585-100000000000000000)/100000000000000000)
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

    //PoC Function
    // Expected: 6.64%
    // Actual: 6.52%
    // Actual: 34122264113541816985302
    /// @notice
    /// @return
    function yieldJun(uint128 daiIn) public returns(uint256){
        Yield yield = Yield(0xe10dEe848fD3Cf7eAC7Da5c59a5060d99Efd93BA);

        //1625097599
        yield21Jun30Maturity = yield.maturity();
        //102572958812182081
        yield21Jun30Return = yield.sellDaiPreview(daiIn);

        uint256 returnDifference  =  yield21Jun30Return - daiIn;

        yield21Jun30Yield = ((returnDifference*1e26)/daiIn)/1e15;

        uint256 yieldTimeDiff = yield21Jun30Maturity - block.timestamp;

        uint256 yieldAnnualizedTimeDiff = (31536000*1e26/yieldTimeDiff)/1e15;

        yield21Jun30AnnualizedYield = (yieldAnnualizedTimeDiff*yield21Jun30Yield/1e9);//*1e26)/1e26;


        return yield21Jun30AnnualizedYield;

    }

}

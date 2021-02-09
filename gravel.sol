//By: William Hsieh



pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


abstract contract Notional {
    function getMarketRates() external virtual returns (uint32[] memory);
    function getCurrentCashTofCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);
    function getfCashToCurrentCash(uint32 maturity, uint128 fCashAmount) external virtual returns (uint128);

}


abstract contract Yield {
    function buyFYDaiPreview(uint128 fyDaiOut) external virtual returns(uint128);
    function getFYDaiReserves() external virtual returns(uint128);

}


contract Gravel {
    //Contract address goes into the () below. Main next
    // Notional notional = Notional(0x307885bb78D490cF9198D678F8B2D1058D741F93);

    //Test net addr.
    //Constructor for contract
    constructor(){


    }
    uint public tests;
    //uint32[] public  hi;
    uint32 public bye;
    uint32 public bye0;
    uint32 public bye1;
    uint32[] public daiRates;
    uint32[] public usdcRates;

    uint128 public BigBoyReturn;

    uint128 public currentCashtofCash;
    uint128 public fCashtoCurrentCash;

    uint256 public annualizedYield;
    uint256 public yield;
    uint256 public timeDiff;
    uint256 public annualizedtimeDiff;

    // Dai Cash Market: 0x3433B2771523d2B57Ae1BC59810F235d6C0093e9
    // USDC Cash Market:0xe0a91bfbe35e62e63914184ea3a4cc1b287ba56a

    //[0] = 3 months
    //[1] = 6 months
    function DaiMarketRate() public returns (uint32[] memory){
        Notional notional = Notional(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9);

        daiRates = notional.getMarketRates();
        return daiRates;
    }
    //ie
    // 1011949107 = 6.325%
    // 1015149694 = 6.722%

    function USDCMarketRate() public returns (uint32[] memory){
        Notional notional = Notional(0xE0A91bfbE35E62E63914184ea3A4CC1B287bA56A);

        usdcRates = notional.getMarketRates();
        return usdcRates;
    }

    function getCurrentCashTofCash(uint32 maturity, uint128 fCashAmount) public returns (uint256){

        Notional notional = Notional(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9);
        currentCashtofCash = notional.getCurrentCashTofCash(maturity, fCashAmount);

        //uint256
        yield = ((fCashAmount*1e26)/currentCashtofCash)/1e15;

        //exp = 1.013068
        //uint256
        timeDiff = maturity - block.timestamp;
        //1625184000 - 1611541798 = 13642202
        annualizedtimeDiff = (31536000*1e26/timeDiff)/1e15;
        yield = yield - 1e11;
        annualizedYield = (annualizedtimeDiff*yield*1e26)/1e26;
        //annualizedYield = (((31536000*(yield- 1e9))*1e26)/timeDiff)/1e26;
        // 1625184000
        // 50000
        //0.03021
        return annualizedYield;
    }
    function getfCashToCurrentCash(uint32 maturity, uint128 fCashAmount) public returns (uint256){
        Notional notional = Notional(0x3433B2771523d2B57Ae1BC59810F235d6C0093e9);
        fCashtoCurrentCash = notional.getfCashToCurrentCash(maturity, fCashAmount);
        return fCashtoCurrentCash;
    }


    function buyFYDaiPreview(uint128 fyDaiIn) public returns(uint128){
        Yield yield = Yield(0xBa51e4Df86333D53Df3c734D12038722EA9Bf559);
        BigBoyReturn =  yield.buyFYDaiPreview(fyDaiIn);
        return BigBoyReturn;

    }

    function POOLgetFYDaiReserves() public returns(uint128){
        Yield yield = Yield(0x9cAc57C33755d324013D3e12DfA5636309b705F9);
        return yield.getFYDaiReserves();

    }

    function Dec31LPgetFYDaiReserves() public returns(uint128){
        Yield yield = Yield(0xBa51e4Df86333D53Df3c734D12038722EA9Bf559);
        return yield.getFYDaiReserves();

    }


}

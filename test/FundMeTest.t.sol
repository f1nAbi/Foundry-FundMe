// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    // State Variables
    FundMe fundMe;
    DeployFundMe deployer;

    uint256 public s_actualInitialBalance;
    uint256 public s_initialOwnerBalance;
    address public s_owner;
    address public user = makeAddr("user");

    uint256 public constant EXPECTED_INITIAL_BALANCE = 0;
    uint256 public constant INITIAL_USER_BALANCE = 10 ether;
    uint256 public constant FUND_AMOUNT = 1 ether;
    uint256 public constant INSUFFICIENT_FUND_AMOUNT = 0.05 ether;

    // Modifiers
    modifier fundFundMeContract() {
        vm.deal(user, INITIAL_USER_BALANCE);
        vm.prank(user);
        fundMe.fund{value: FUND_AMOUNT}();
        _;
    }

    // Functions
    function setUp() public {
        deployer = new DeployFundMe();
        fundMe = deployer.run();
        s_owner = fundMe.i_owner();
    }

    function testInitialBalance() public {
        s_actualInitialBalance = fundMe.getBalance();
        assert(s_actualInitialBalance == EXPECTED_INITIAL_BALANCE);
    }

    // Funding Test Functions
    function testFundFunctionFundsContract() public fundFundMeContract {
        assert(fundMe.getBalance() == FUND_AMOUNT);
    }

    function testFundWithInsufficiantAmountFails() public {
        vm.deal(user, INITIAL_USER_BALANCE);
        vm.prank(user);
        vm.expectRevert();
        fundMe.fund{value: INSUFFICIENT_FUND_AMOUNT}();
    }

    function testFunderGetsAddedToFundersArray() public fundFundMeContract {
        assert(fundMe.s_funders(0) == user);
    }

    // Withdraw Test Functions
    function testWithdrawFunctionTransfersFundsToOwner() public fundFundMeContract {
        s_initialOwnerBalance = s_owner.balance;
        vm.prank(s_owner);
        fundMe.withdraw();
        assert(fundMe.getBalance() == 0);
        assert(s_owner.balance == s_initialOwnerBalance + FUND_AMOUNT);
    }

    function testWithdrawFailsIfNotOwner() public fundFundMeContract {
        vm.prank(user);
        vm.expectRevert();
        fundMe.withdraw();
    }

    // Getter Test Functions
    function testGetFundersToAmountGetsFundersAmount() public fundFundMeContract {
        assert(fundMe.getFundersToAmount(user) == FUND_AMOUNT);
    }
}

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

/**
 * @title FundMe
 * @author Fin Nöthen
 * @notice This is a simple contract that allows users to fund the contract and the owner to withdraw the funds
 */
contract FundMe {
    /* Errors */
    error FundMe__NotOwner();
    error FundMe__InsufficientFunds();

    /* State Variables */
    address[] public s_funders;
    mapping(address => uint256) public s_funderToAmount;

    address public immutable i_owner;

    uint256 public constant MINIMUM_FUND_AMOUNT = 0.1 ether;

    /* Events */
    event Funded(address indexed funder, uint256 indexed amount);

    /* Modifiers */
    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert FundMe__NotOwner();
        }
        _;
    }

    /* Functions */
    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        if (msg.value < MINIMUM_FUND_AMOUNT) {
            revert FundMe__InsufficientFunds();
        }
        s_funders.push(msg.sender);
        s_funderToAmount[msg.sender] += msg.value;
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        payable(i_owner).transfer(address(this).balance);
    }

    /* Getter Functions */
    function getFundersToAmount(address funder) public view returns (uint256) {
        return s_funderToAmount[funder];
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function getFunders() public view returns (address[] memory) {
        return s_funders;
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }
}

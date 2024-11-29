# Project Title

Simple Funding Contract

## Description

The core contract FundMe.sol that can be found in the src folder is a simple smart contract that allows anybody to fund it through sending Ethereum to the fund() function. Only the Owner of the contract is able to withdraw the funds using the withdraw() function. The contract can be deployed by the DeployFundMe.s.sol script in the script folder and the FundMeTest.t.sol tests the most crucial elemnts of the FundMe contract.

## Getting Started
Make sure you have foundry installed, if not visit the following website:

https://book.getfoundry.sh/getting-started/installation

Clone the repo with the following command:
```
git clone https://github.com/f1nAbi/Foundry-FundMe.git
```

### Dependencies

* No dependencies are needed

### Installing

* Make sure to create an .env file following the example of the .env.example file
* Note: Dont use a private key with real funds for safty

### Executing program

* Deploy Contract on local anvil chain:
```
make deploy
```

* Deploy Contract on Ethereum Sepolia:
```
make deploy-sepolia
```
Note: Your Sepolia Private Key, Sepolia RPC URL and Etherscan Api Key need to be set in your .env file

## Author

Fin Nöthen  


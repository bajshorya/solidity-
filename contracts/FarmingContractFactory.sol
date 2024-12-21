// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {FarmingContract} from "contracts/FarmingContract.sol";

// Factory contract to create individual farming contracts
contract FarmingContractFactory {
    
    // Array to store addresses of all deployed farming contracts
    FarmingContract[] public deployedContractsList;
    
    // Contract ID to keep a track of deployed contracts
    uint256 public contractID;

    // Event emitted when a new farming contract is created
    event FarmingContractCreated(address indexed contractAddress, address indexed buyer, uint256 contractID);


    // Function to create a new farming contract
    function createFarmingContract(
        string memory _cropType,
        uint256 _deliveryDeadline,
        uint256 _quantity,
        uint256 _offeredPricePerKg,
        uint256 _buyerPhoneNumber
    ) public payable returns (FarmingContract) {
        // Validate that some payment is being sent
        require(msg.value > 0, "Initial payment required to create contract");

        // Deploy a new FarmingContract instance
        FarmingContract newContract = new FarmingContract {value :  msg.value} (
            msg.sender,
            _cropType,
            _deliveryDeadline,
            _quantity,
            _offeredPricePerKg,
            _buyerPhoneNumber,
            contractID,
            msg.value // Pass the initial payment to the contract
        );
        
        // Add the newly deployed contract to the array
        deployedContractsList.push(newContract);
        uint256 currentId = contractID;
        contractID++;

        // Emit event to notify the creation of a new contract
        emit FarmingContractCreated(address(newContract), msg.sender, currentId);

        return newContract;
    }


    // Function to retrieve all deployed contract addresses
    function getDeployedContracts(uint256 _contractID) public view returns (FarmingContract) {
        return deployedContractsList[_contractID];
    }


    // Getting deployed contract's details
    function fGetContractDetails(uint256 _contractID) public view returns (
        address _farmerWallet,
        uint256 _farmerPhoneNumber,
        address _buyerWallet,
        uint256 _buyerPhoneNumber,
        string memory _cropType,
        uint256 _deliveryDeadline,
        uint256 _quantity,
        uint256 _pricePerKg,
        uint256 _totalPayment,
        uint256 _contractId,
        FarmingContract.ContractStatus _status
    ) {
        
       return FarmingContract(deployedContractsList[_contractID]).getContractDetails();
    }
}

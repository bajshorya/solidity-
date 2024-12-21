// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Individual farming contract created by the factory
contract FarmingContract {
    address public farmer;
    address public buyer;
    string public cropType;
    uint256 public quantity;
    uint256 public pricePerKg;
    uint256 public totalPayment;
    uint256 public deliveryDeadline;
    uint256 public buyer_phoneNumber;
    uint256 public farmer_phoneNumber;
    uint256 public contractID;
    uint256 public initialPayment; // Payment made during contract creation
    uint256 public paymentReleased;

    enum ContractStatus { Created, Active, Completed, Disputed }
    ContractStatus public status;

    // Events to track contract updates
    event ContractClaimed(address farmer, uint256 contractID, address contractAddress);
    event PaymentReleased(uint256 amount, uint256 contractID, address contractAddress);
    
    // Constructor to initialize the contract
    constructor(
        address _buyer,
        string memory _cropType,
        uint256 _deliveryDeadline,
        uint256 _quantity,
        uint256 _offeredPricePerKg,
        uint256 _buyerPhoneNumber,
        uint256 _contractID,
        uint256 _initialPayment
    ) payable {
        buyer = _buyer;
        cropType = _cropType;
        deliveryDeadline = _deliveryDeadline;
        quantity = _quantity;
        pricePerKg = _offeredPricePerKg;
        totalPayment = _quantity * _offeredPricePerKg;
        buyer_phoneNumber = _buyerPhoneNumber;
        contractID = _contractID;
        initialPayment = _initialPayment;
        paymentReleased = 0;
        status = ContractStatus.Created; // Set initial status to "Created"
    }

    // View function to check contract details
    function getContractDetails() public view returns (

        address _farmerWallet,
        uint256 _farmerPhoneNumber,
        address _buyerWallet,
        uint256 _buyerPhoneNumber,
        string memory _cropType,
        uint256 _deliveryDeadline,
        uint256 _quantity,
        uint256 _pricePerKg,
        uint256 _totalPayment,
        uint256 _contractID,
        ContractStatus _status
    ) {
        return (
            farmer,
            farmer_phoneNumber,
            buyer,
            buyer_phoneNumber,
            cropType,
            deliveryDeadline,
            quantity,
            pricePerKg,
            totalPayment,
            contractID,
            status
        );
    }

    // Function for a farmer to claim the contract
    function claimContract(uint256 _farmerPhoneNumber) public {
        require(farmer == address(0), "Contract already claimed");
        require(status == ContractStatus.Created, "Contract already claimed");

        farmer = msg.sender; // Set the sender (farmer) as the new owner of the contract
        farmer_phoneNumber = _farmerPhoneNumber;
        status = ContractStatus.Active; // Mark the contract as active

        emit ContractClaimed(farmer, contractID, address(this)); // Emit the contract claimed event
    }

    // Function for buyer to deposit negotiated final payment
    function depositPayment(uint256 _negotiatedPricePerKg) public payable {
        require(status == ContractStatus.Active, "Contract must be active");

        pricePerKg = _negotiatedPricePerKg;
        totalPayment = quantity * _negotiatedPricePerKg;

        require((msg.value + initialPayment) >= totalPayment, "Insufficient deposit!");
    }

    // Function to release payment from buyer to farmer
    function releasePayment() public {
        require(msg.sender == buyer, "Only the buyer can release payment");
        require(status == ContractStatus.Active, "Contract must be active");
        require(paymentReleased == 0, "Payment has already been released");

        paymentReleased = totalPayment; // Update the payment released amount
        payable(farmer).transfer(totalPayment); // Transfer the total price to the farmer

        status = ContractStatus.Completed; // Mark the contract as completed
        emit PaymentReleased(paymentReleased, contractID, address(this)); // Emit the payment released event
    }
}

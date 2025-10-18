// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

// This contract allows receiving, storing, and withdrawing Ether.
// It also allows the owner to change ownership.
contract SendEther {
    // This declares a new smart contract named 'SendEther'.
    // This contract is designed to demonstrate how to handle Ether (the native cryptocurrency of Ethereum)
    // within a smart contract, including receiving, storing, and sending it.

    // The owner of the contract (can withdraw and change ownership)
    address payable public owner;
    // This declares a state variable 'owner' of type 'address payable'.
    // 'address payable' is a special address type that can receive Ether.
    // 'public' means this variable can be read by anyone from outside the contract.
    // This variable will store the address of the contract's owner, who has special privileges.

    // Event emitted when Ether is deposited into the contract
    event deposit(address indexed sender, uint256 amount);
    // This declares an event named 'deposit'.
    // Events are used to log actions on the blockchain, making them visible to off-chain applications.
    // 'address indexed sender': The address that sent the Ether, marked as 'indexed' for easy searching.
    // 'uint256 amount': The amount of Ether received.

    // Constructor runs once when the contract is deployed
    constructor() payable {
        // The constructor is a special function that runs only once when the contract is deployed to the blockchain.
        // 'payable' means this constructor can receive Ether during deployment.
        owner = payable(msg.sender);
        // 'msg.sender' is a global variable in Solidity that represents the address of the account
        // that initiated the current transaction.
        // Here, the deployer of the contract is set as the initial 'owner'.
    }

    // Special function that enables the contract to receive Ether directly
    // This function is called when Ether is sent to the contract address
    receive() external payable {
        // The 'receive()' function is a special fallback function that is executed when a contract
        // receives plain Ether (without any function call data).
        // It must be 'external' and 'payable'.
        // It has a gas limit of 2300 gas when called by `transfer()` or `send()`, so it should be simple.

        // Emit an event showing who sent Ether and how much
        emit deposit(msg.sender, msg.value);
        // 'msg.value' is a global variable that represents the amount of Ether (in Wei)
        // sent with the current transaction.
        // This line emits the 'deposit' event, logging the sender and the amount of Ether received.
    }

    // Function to withdraw Ether from the contract
    // Only the owner can call this function
    function withdraw(uint256 _amount) external {
        // This function allows the owner to withdraw Ether from the contract.
        // 'external' means it can only be called from outside the contract.
        // It takes '_amount' as an argument, specifying how much Ether to withdraw.

        require(msg.sender == owner, "Error: Only owner can withdraw. You are not the owner");
        // This 'require' statement acts as an access control mechanism.
        // It ensures that only the 'owner' of the contract can call this function.
        // If anyone else tries to call it, the transaction will revert with the specified error message.

        //require(address(this).balance >= _amount, "Insufficient balance"); // Uncomment to check contract balance before withdrawing
        // This commented line is a good practice: it would check if the contract has enough Ether
        // before attempting to send it. If not, it would revert.

        //owner.transfer(amount); // Alternative way to send Ether to owner
        // This commented line shows an alternative, older method to send Ether.
        // `transfer()` is limited to 2300 gas, which can be problematic for complex recipient fallback functions.

        payable(msg.sender).transfer(_amount);
        // This line sends the specified '_amount' of Ether to the 'msg.sender' (which is the owner, due to the require statement).
        // `payable(msg.sender)` casts the address to a payable address.
        // `transfer()` is a low-level function for sending Ether. It forwards 2300 gas to the recipient.
        // For more robust Ether transfers, especially to contracts, `call{value: _amount}("")` is often preferred.
    }

    // Function to get the contract's Ether balance (commented out)
    // Anyone can call this to see how much Ether is stored in the contract
    //function getBalance() external view returns (uint256) {
    //    return address(this).balance;
    //}

    // Function to change the owner of the contract
    // Only the current owner can call this function
    function setOwner(address _newOwner) external {
        // This function allows the current owner to transfer ownership to a new address.
        // 'external' means it can only be called from outside the contract.

        require(msg.sender == owner, "Error: Only owner can change owner");
        // Another access control check, ensuring only the current owner can change ownership.

        owner = payable(_newOwner);
        // The 'owner' state variable is updated to the '_newOwner' address.
        // This is a critical function for contract management.
    }
}

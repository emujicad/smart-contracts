// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

contract Wallet {
    // This declares a new smart contract named 'Wallet'.
    // This contract functions as a simple Ether wallet, allowing an owner to receive and withdraw Ether.
    // It's a basic example to understand how to manage funds in a smart contract.

    address payable public owner;
    // This declares a state variable 'owner' of type 'address payable'.
    // 'address payable' is a special address type that can receive Ether.
    // 'public' means this variable can be read by anyone from outside the contract.
    // This variable will store the address of the contract's owner, who has special privileges.

    constructor() {
        // The constructor is a special function that runs only once when the contract is deployed to the blockchain.
        // Unlike `SendEther.sol`, this constructor is not marked `payable`, meaning it cannot receive Ether during deployment.
        owner = payable(msg.sender);
        // 'msg.sender' is a global variable in Solidity that represents the address of the account
        // that initiated the current transaction.
        // Here, the deployer of the contract is set as the initial 'owner'.
    }

    receive() external payable {
        // The 'receive()' function is a special fallback function that is executed when a contract
        // receives plain Ether (without any function call data).
        // It must be 'external' and 'payable'.
        // This function allows the contract to receive Ether directly.
        // In a real application, you might want to add an event here to log deposits,
        // similar to the `SendEther` contract.
    }

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

    //function getBalance() external view returns (uint256) {
    //    return address(this).balance;
    //}
    // This commented function would allow anyone to query the current Ether balance of the contract.
    // 'address(this).balance' is a global variable that returns the current Ether balance of the contract itself.
    // 'view' means it doesn't modify state, and 'returns (uint256)' specifies it returns an unsigned integer.

    function changeOwner(address _newOwner) external {
        // This function allows the current owner to transfer ownership to a new address.
        // 'external' means it can only be called from outside the contract.

        require(msg.sender == owner, "Error: Only owner can change owner");
        // Another access control check, ensuring only the current owner can change ownership.

        owner = payable(_newOwner);
        // The 'owner' state variable is updated to the '_newOwner' address.
        // This is a critical function for contract management.
    }
}

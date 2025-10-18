// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableAccessControl 
 * @notice This contract demonstrates VULNERABLE access control - anyone can change the secret!
 * @dev WARNING: This lacks proper access control - any user can call restricted functions
 */

 contract VulnerableAccessControl  {

    // Private variable that should only be changed by the owner
    // However, there's no access control protecting it!
    uint private secretNumber;
    // Public variable showing who deployed the contract (the owner)
    address public owner;
    
    constructor() {
        // Set the contract deployer as the owner
        // msg.sender is the address that called this function (deployed the contract)
        owner = msg.sender;
    }

    // VULNERABLE FUNCTION - Anyone can call this!
    // PROBLEM: No access control means any user can change the secret number
    // This should be restricted to only the owner
    function setSecretNumber(uint _newNumber) public {
        // This function should check if msg.sender == owner, but it doesn't!
        secretNumber = _newNumber;
    }

    // Function to read the secret number
    // Note: Even though secretNumber is "private", anyone can read it on blockchain
    // Private in Solidity means other contracts can't access it, but the data is still public
    function getSecretNumber() public view returns (uint) {
        return secretNumber;
    }

}
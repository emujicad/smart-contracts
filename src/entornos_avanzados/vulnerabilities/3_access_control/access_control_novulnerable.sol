// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableAccessControl 
 * @notice This contract demonstrates SECURE access control using modifiers
 * @dev Uses onlyOwner modifier to restrict function access to the contract owner
 */

 contract NoVulnerableAccessControl  {

    // Private variable that only the owner should be able to change
    uint private secretNumber;
    // Private owner address (more secure than public)
    address private owner;
    
    constructor() {
        // Set the contract deployer as the owner
        owner = msg.sender;
    }

    // MODIFIER - A reusable piece of code that adds conditions to functions
    // This is like a security guard that checks if the caller is the owner
    modifier onlyOwner() {
        // Check if the function caller is the owner
        require(msg.sender == owner, "Error. Only Owner can use this function");
        // The underscore means "run the rest of the function here"
        _;
    }

    // SECURE FUNCTION - Only owner can call this!
    // The "onlyOwner" modifier runs first, checking if caller is the owner
    function setSecretNumber(uint _newNumber) public onlyOwner{
        // This line only runs if the onlyOwner check passes
        secretNumber = _newNumber;
    }

    // Function to read the secret number
    // Anyone can read it, but only owner can change it
    function getSecretNumber() public view returns (uint) {
        return secretNumber;
    }
}
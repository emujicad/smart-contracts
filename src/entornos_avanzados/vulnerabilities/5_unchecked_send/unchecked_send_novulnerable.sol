// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableUncheckedSend
 * @notice This contract demonstrates SECURE send operations with proper error handling
 * @dev Uses .send() with proper error checking to handle failed transfers gracefully
 */

contract NoVulnerableUncheckedSend {
    // Public mapping to track user balances
    mapping(address => uint256) public balances;

    // Function to deposit ether into the contract
    function deposit() public payable {
        // Add deposited amount to user's balance
        balances[msg.sender] += msg.value;
    }

    // SECURE WITHDRAW FUNCTION
    function withdraw(uint256 _amount) public {
        // Check if user has sufficient balance
        require(
            balances[msg.sender] >= _amount,
            "Error: There is not found to withdraw"
        );
        // Update balance BEFORE sending (follows checks-effects-interactions pattern)
        balances[msg.sender] -= _amount;
        
        // SECURE: Using .send() with proper error checking
        // .send() returns true/false instead of reverting
        // This allows us to handle failures gracefully
        require(payable(msg.sender).send(_amount), "Error. Failed to send");
    }
}

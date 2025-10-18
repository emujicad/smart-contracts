// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableUncheckedSend
 * @notice This contract demonstrates VULNERABLE unchecked send operations
 * @dev WARNING: Uses .transfer() which can fail silently or cause DoS attacks
 */

contract VulnerableUncheckedSend {
    // Public mapping to track user balances
    mapping(address => uint256) public balances;

    // Function to deposit ether into the contract
    function deposit() public payable {
        // Add deposited amount to user's balance
        balances[msg.sender] += msg.value;
    }

    // VULNERABLE WITHDRAW FUNCTION
    function withdraw(uint256 _amount) public {
        // Check if user has sufficient balance
        require(
            balances[msg.sender] >= _amount,
            "Error: There is not found to withdraw"
        );
        // VULNERABILITY: Using .transfer() without proper error handling
        // PROBLEMS with .transfer():
        // 1. Only forwards 2300 gas (may not be enough for receiving contract)
        // 2. Reverts on failure (can cause DoS if receiving address always fails)
        // 3. May break with future gas cost changes
        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount;
    }
}

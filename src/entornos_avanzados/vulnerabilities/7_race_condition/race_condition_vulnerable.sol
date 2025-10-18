// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableRaceCondition
 * @notice This contract demonstrates VULNERABLE race condition scenarios
 * @dev WARNING: The race condition check is flawed and doesn't actually prevent attacks
 */

contract VulnerableRaceCondition {
    // Total balance of the contract
    uint256 public balance;

    // Individual user balances
    mapping(address => uint256) public balances;

    // Function to deposit ether
    function deposit() public payable {
        // Update user's individual balance
        balances[msg.sender] += msg.value;
        // Update total contract balance
        balance += msg.value;
    }

    // VULNERABLE WITHDRAW FUNCTION
    // This attempts to prevent race conditions but fails to do so effectively
    function withdraw(uint256 _amount) public {
        // Check if user has sufficient balance
        require(
            balances[msg.sender] >= _amount,
            "Error: There is not found to withdraw"
        );

        // FLAWED RACE CONDITION DETECTION
        // This approach doesn't actually prevent race conditions effectively
        uint256 lastBalance = balances[msg.sender];
        balances[msg.sender] -= _amount;
        require(payable(msg.sender).send(_amount), "Error. Failed to send");

        // PROBLEM: This check happens AFTER the state change and send
        // By this time, any race condition has already occurred
        // This is more of a detection mechanism than a prevention mechanism
        require(balances[msg.sender] == lastBalance, "Error: Race condition detected");
        
    }

}
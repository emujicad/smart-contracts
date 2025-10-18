// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableRaceCondition
 * @notice This contract demonstrates SECURE protection against race conditions
 * @dev Uses a mutex/lock pattern to prevent concurrent withdrawals by the same user
 */

contract NoVulnerableRaceCondition {
    // Total balance of the contract
    uint256 public balance;

    // Individual user balances
    mapping(address => uint256) public balances;
    // Mutex/lock to prevent concurrent operations by same user
    // This acts like a "busy" flag for each address
    mapping(address => bool) public isTransfering;

    // Function to deposit ether
    function deposit() public payable {
        // Update user's individual balance
        balances[msg.sender] += msg.value;
        // Update total contract balance
        balance += msg.value;
    }

    // SECURE WITHDRAW FUNCTION
    // This version prevents race conditions using a mutex/lock pattern
    function withdraw(uint256 _amount) public {
        // Check if user has sufficient balance    
        require(balances[msg.sender] >= _amount, "Error: Insufficient balance");

        // RACE CONDITION PREVENTION: Check if user is already in a transfer
        // This prevents the same user from calling withdraw multiple times simultaneously
        require(!isTransfering[msg.sender], "Error: Transfer in progress");
    
        // Lock the account to prevent race conditions
        isTransfering[msg.sender] = true;

        // Try to send ether first, without modifying the balance yet
        (bool success, ) = payable(msg.sender).call{value: _amount}("");
    
        if (success) {
            // Only update the balance if the transfer was successful
            balances[msg.sender] -= _amount;
        }
    
        // Always release the lock
        isTransfering[msg.sender] = false;
    
        // Revert if the transfer failed; done after releasing the lock
        require(success, "Error: Failed to send Ether");
   }
}   

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableReentrancy
 * @notice This contract demonstrates a VULNERABLE reentrancy attack scenario
 * @dev WARNING: This contract can be exploited by malicious contracts calling withdraw repeatedly
 */

contract VulnerableReentrancy {
    // Mapping to track how much ether each address has deposited
    mapping(address => uint256) private balances;

    // Function to deposit ether into the contract
    function deposit() external payable {
        // Add the sent ether to the sender's balance
        balances[msg.sender] += msg.value;
    }

    // VULNERABLE WITHDRAW FUNCTION
    // This function is vulnerable to reentrancy attacks
    function withdraw(uint256 _amount) public {
        // Check if user has enough balance
        require(
            _amount <= balances[msg.sender],
            "Error: There is not found to withdraw"
        );

        // VULNERABILITY: Sending ether BEFORE updating the balance
        // A malicious contract can call this function again before the balance is updated
        // This allows them to withdraw more than they deposited!
        (bool success, ) = msg.sender.call{value: _amount}("");
        require(success, "Error: Transfer failed");
        // Balance is updated AFTER sending - this is the problem!
        balances[msg.sender] -= _amount;
    }
}

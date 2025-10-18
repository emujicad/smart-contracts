// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableFallBack
 * @notice This contract demonstrates a SECURE fallback function implementation
 * @dev This version prevents accidental ether sends and provides explicit deposit function
 */

contract NoVulnerableFallBack {
    // Mapping to track deposited balances for each address
    mapping(address => uint256) private balances;

    // SECURE FALLBACK FUNCTION
    // This function runs when someone tries to send ether directly to contract
    // SECURITY: It rejects all direct payments to prevent accidents and attacks
    fallback() external payable {
        // Always revert when someone tries to send ether directly
        // This forces users to use the explicit deposit() function instead
        revert("Error: This function is not enabled to receive payments");
    }

    // EXPLICIT DEPOSIT FUNCTION
    // Users must call this specific function to deposit ether
    // This makes the intention clear and prevents accidental transfers
    function deposit() external payable {
        // Add the sent ether to the sender's balance
        balances[msg.sender] += msg.value;
    }

    // Function to withdraw deposited funds
    function withdraw() public {
        uint256 amount = balances[msg.sender];

        require(amount > 0, "Error: There is not found to withdraw");
        // Good practice: Update state before external call (checks-effects-interactions pattern)
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Error: Transfer failed");
    }

    // Receive function: handles plain ether transfers
    // In this secure version, we allow plain ether transfers as deposits
    // This is safer than the vulnerable fallback because it doesn't immediately send back
    receive() external payable {}
}

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableFallBack
 * @notice This contract demonstrates a VULNERABLE fallback function implementation
 * @dev WARNING: This implementation has serious security flaws - do not use in production!
 */

contract VulnerableFallBack {
    // Mapping to track how much ether each address has deposited
    mapping(address => uint256) private balances;

    // VULNERABLE FALLBACK FUNCTION
    // This function automatically runs when someone sends ether directly to the contract
    // PROBLEM: It immediately sends the money back, which can cause reentrancy attacks!
    fallback() external payable {
        // Add the sent amount to user's balance
        balances[msg.sender] += msg.value;
        // VULNERABILITY: Immediately sending money back can trigger malicious contracts
        // This can lead to reentrancy attacks where attacker calls this function repeatedly
        (bool success, ) = msg.sender.call{value: msg.value}("");
        require(success, "Error: Transfer failed");
    }

    // Function to withdraw deposited funds
    function withdraw() public {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Error: There is not found to withdraw");
        // Good practice: Update balance before sending (prevents some reentrancy)
        balances[msg.sender] = 0;
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Error: Transfer failed");
    }

    // Receive function: handles plain ether transfers (when no data is sent)
    // This is different from fallback - it only triggers for plain ether sends
    receive() external payable {}
}

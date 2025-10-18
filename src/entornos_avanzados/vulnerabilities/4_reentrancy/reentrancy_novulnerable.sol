// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableReentrancy
 * @notice This contract demonstrates SECURE protection against reentrancy attacks
 * @dev Uses the "Checks-Effects-Interactions" pattern to prevent reentrancy
 */

contract NoVulnerableReentrancy {
    // Public mapping so balances are visible (for demonstration purposes)
    mapping(address => uint256) public balances;

    // Function to deposit ether into the contract
    function deposit() external payable {
        // Add the sent ether to the sender's balance
        balances[msg.sender] += msg.value;
    }

    // SECURE WITHDRAW FUNCTION
    // This version prevents reentrancy attacks using safer practices
    function withdraw(uint256 _amount) public {
        // CHECKS: Verify the user has enough balance
        require(
            balances[msg.sender] >= _amount,
            "Error: There is not found to withdraw"
        );
        // EFFECTS: Update the state FIRST (before external interaction)
        // This prevents reentrancy because balance is already reduced
        balances[msg.sender] -= _amount;
        
        // INTERACTIONS: External call happens LAST
        // Even if the receiving contract tries to call withdraw again,
        // the balance is already zero, so it will fail
        require(payable(msg.sender).send(_amount), "Error. Failed to send");
    }
}

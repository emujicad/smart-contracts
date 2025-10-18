// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

contract CAuction {
    // This declares a new smart contract named 'CAuction'.
    // Contracts are like classes in other programming languages, but they live on the blockchain.

    uint256 public startAuction = block.timestamp + 1 days;
    // This variable stores the timestamp when the auction starts.
    // 'uint256' means it's an unsigned integer (non-negative) that can store very large numbers (256 bits).
    // 'public' means this variable can be read by anyone from outside the contract.
    // 'block.timestamp' is a global variable in Solidity that returns the current block's timestamp (time in seconds since Unix epoch).
    // '+ 1 days' adds one day (in seconds) to the current timestamp, meaning the auction starts 1 day from deployment.

    uint256 public endAuction = block.timestamp + 2 days;
    // This variable stores the timestamp when the auction ends.
    // It's set to 2 days from the contract deployment, meaning the auction lasts for 1 day after it starts.

    function offer() external view {
        // This declares a function named 'offer'.
        // 'external' means this function can only be called from outside the contract (by users or other contracts).
        // 'view' means this function does not modify the state of the blockchain (it only reads data).
        // It's a good practice to use 'view' when a function doesn't change any contract variables.

        require(block.timestamp >= startAuction && block.timestamp <= endAuction, "You cannot offer now");
        // 'require' is a common Solidity statement used for input validation.
        // If the condition inside 'require' is false, the transaction will revert, and the string message will be returned.
        // Here, it checks if the current time ('block.timestamp') is within the auction's active period.
        // This ensures that bids (offers) can only be made when the auction is live.
    }

    function finishAuction() external view {
        // This declares a function named 'finishAuction'.
        // Similar to 'offer', it's 'external' and 'view'.
        // Note: In a real auction, this function would likely modify the contract state (e.g., transfer funds, declare a winner),
        // so it wouldn't be 'view'. It's 'view' here because it's a simplified example.

        require(block.timestamp > endAuction, "Auction has not ended yet");
        // This 'require' statement checks if the current time is past the auction's end time.
        // This ensures that the auction can only be finalized after it has officially concluded.
        // In a complete auction contract, the logic to determine the winner and distribute assets would go here.
    }
}

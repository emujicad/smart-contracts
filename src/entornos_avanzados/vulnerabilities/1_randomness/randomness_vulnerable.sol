// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title RandomnessVulnerable
 * @notice This contract demonstrates a VULNERABLE way to generate random numbers
 * @dev WARNING: Never use this approach in production! It's predictable and can be manipulated
 */
contract RandomnessVulnerable {

    // Private variable to store a seed value for "randomness"
    // WARNING: This approach is NOT truly random and is vulnerable to attacks
    uint private seed;
    // Public variable that anyone can read to see the generated "random" number
    uint public randomNumber;

    constructor() {
        // Initialize seed with current block timestamp
        // PROBLEM: Block timestamp is predictable and can be manipulated by miners
        seed= block.timestamp;
    }

    // Function that generates a "random" number
    // WARNING: This is NOT truly random and should never be used for important decisions
    function generateRandomNumber() public {
        // This creates a hash using predictable blockchain data
        // VULNERABILITIES:
        // - block.prevrandao: Can be influenced by miners
        // - block.timestamp: Can be manipulated within ~15 second window
        // - seed: Based on predictable timestamp
        // An attacker can predict this "random" number!
        randomNumber = uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, seed)));
    }

}
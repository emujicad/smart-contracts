// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableDenialOfService
 * @notice This contract demonstrates VULNERABLE denial of service attacks
 * @dev WARNING: This function can consume unlimited gas and make the contract unusable
 */

contract VulnerableDenialOfService {
    // VULNERABLE FUNCTION - Can cause Denial of Service
    // This function allows unlimited iterations which can:
    // 1. Consume all available gas
    // 2. Make the transaction fail
    // 3. Make the contract effectively unusable
    function performDoS(uint256 _iterations) public pure {
        // PROBLEM: No limit on iterations - user can pass huge numbers
        // Each iteration creates a large array and fills it
        // With high _iterations, this becomes extremely expensive
        for (uint256 i = 0; i < _iterations; i++) {
            // Creating a new array of size _iterations every loop iteration
            // This uses memory proportional to _iterations^2 total
            uint256[] memory data = new uint256[](_iterations);
            // Nested loop makes this even more expensive: O(_iterations^2)
            for (uint256 j = 0; j < _iterations; j++) {
                data[j] = j;  // Each assignment costs gas
            }
        }
    }
}

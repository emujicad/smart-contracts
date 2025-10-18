// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableDenialOfService
 * @notice This contract demonstrates SECURE protection against denial of service attacks
 * @dev Uses limits and bounds checking to prevent gas exhaustion attacks
 */

contract NoVulnerableDenialOfService {
    // SECURITY MEASURE: Set a reasonable maximum limit for iterations
    // This prevents users from causing DoS by passing huge numbers
    uint256 constant MAX_ITERATION = 100;

    // SECURE FUNCTION - Protected against DoS attacks
    // This version limits the maximum iterations to prevent gas exhaustion
    function performDoS(uint256 _iterations) public pure {
        // PROTECTION: Check that iterations don't exceed our safe limit
        // This prevents malicious users from making the function too expensive
        require(
            _iterations <= MAX_ITERATION,
            "Error. The max number of iterations was exceded"
        );

        // Now we can safely perform the operation knowing it won't consume too much gas
        // The gas consumption is bounded by our MAX_ITERATION constant
        for (uint256 i = 0; i < _iterations; i++) {
            uint256[] memory data = new uint256[](_iterations);

            for (uint256 j = 0; j < _iterations; j++) {
                data[j] = j;
            }
        }
    }
}

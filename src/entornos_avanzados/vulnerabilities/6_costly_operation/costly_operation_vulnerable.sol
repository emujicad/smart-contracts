// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title VulnerableCostlyOperation
 * @notice This contract demonstrates VULNERABLE costly operations that waste gas
 * @dev WARNING: Inefficient loops and calculations lead to high gas costs
 */

contract VulnerableCostlyOperation {
    // Constant defining maximum number of loop iterations
    // This large number will cause expensive gas consumption
    uint256 constant public MAX_ITERATIONS =1600;

    // VULNERABLE FUNCTION - Inefficient and costly
    // This function wastes gas by using an unnecessary loop
    function performCostlyOperation() pure external returns (uint256 result) {
        result= 0;

        // PROBLEM: This loop is highly inefficient and costly
        // Each iteration costs gas, and we're just adding 1 each time
        // The result could be calculated directly as MAX_ITERATIONS
        // This pattern can make functions too expensive to call
        for (uint256 i = 0; i < MAX_ITERATIONS; i++) {
            result +=1;  // Wasteful: just incrementing by 1 in a loop
        }
    }
}
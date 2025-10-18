// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

/**
 * @title NoVulnerableCostlyOperation
 * @notice This contract demonstrates EFFICIENT operations that minimize gas costs
 * @dev Uses mathematical formulas instead of loops to reduce gas consumption
 */

contract NoVulnerableCostlyOperation {
    // Same constant as vulnerable version for comparison
    uint256 constant public MAX_ITERATIONS =1600;

    // OPTIMIZED FUNCTION - Efficient and low gas cost
    // This function achieves the same result with much less gas
    function performCostlyOperation() pure external returns (uint256 result) {
        // Instead of a loop, we use an optimized helper function
        // This demonstrates how to think about gas optimization
        result= sumNumbers(MAX_ITERATIONS);
    }

    // Helper function that calculates sum efficiently
    // Instead of looping, we use the mathematical formula: n * (n + 1) / 2
    // This calculates the sum of numbers from 1 to n in constant time (O(1))
    // Much more efficient than the O(n) loop in the vulnerable version
    function sumNumbers(uint256 n) internal pure returns (uint256) {
        // Mathematical formula: sum of 1+2+3+...+n = n*(n+1)/2
        // This replaces expensive loops with a single calculation
        return (n*(n+1))/2;
    }
}
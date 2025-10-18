// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title SafeMath
 * @notice A library that provides safe arithmetic operations to prevent overflow and underflow
 * @dev This library was crucial before Solidity 0.8.0, which introduced built-in overflow checks
 * @dev It's still useful for educational purposes and understanding safe math practices
 */
library SafeMath {
    /**
     * @dev Safely adds two numbers and reverts if overflow occurs
     * @param a First number to add
     * @param b Second number to add
     * @return The sum of a and b
     * @notice This function prevents overflow by checking if the result is valid
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        // Perform the addition
        uint256 c = a + b;
        // SAFETY CHECK: If overflow occurred, c would be smaller than a
        // Example: If a = 2^256-1 and b = 1, then c would wrap to 0
        // Since 0 < 2^256-1, we detect the overflow
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Safely subtracts two numbers and reverts if underflow occurs
     * @param a Number to subtract from (minuend)
     * @param b Number to subtract (subtrahend)
     * @return The difference of a minus b
     * @notice This function prevents underflow by checking if subtraction is valid
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        // SAFETY CHECK: Make sure we're not subtracting a larger number from smaller
        // Example: If a = 5 and b = 10, this would underflow in uint (wrap to large number)
        require(b <= a, "SafeMath: subtraction overflow");
        // Perform the subtraction - now we know it's safe
        uint256 c = a - b;
        return c;
    }
}
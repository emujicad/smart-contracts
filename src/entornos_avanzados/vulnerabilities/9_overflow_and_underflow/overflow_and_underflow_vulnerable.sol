// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/**
 * @title VulnerableOverflowAndUnderflow
 * @notice This contract demonstrates VULNERABLE overflow and underflow scenarios
 * @dev WARNING: In Solidity <0.8.0, arithmetic operations don't check for overflow/underflow
 */

contract VulnerableOverflowAndUnderflow {

    // VULNERABLE OVERFLOW FUNCTION
    // Demonstrates what happens when numbers get too big for their data type
    function overflowExample(uint8 _val) public pure returns (uint8){
        // uint8 can only hold values from 0 to 255
        uint8 maxValue = 255;
        // PROBLEM: If _val > 0, this will overflow!
        // Example: 255 + 1 = 0 (wraps around to the beginning)
        // This unexpected behavior can break contract logic
        maxValue += _val;
        return maxValue;    
    }

    // VULNERABLE UNDERFLOW FUNCTION
    // Demonstrates what happens when numbers go below zero in unsigned types
    function underflowExample(uint8 _val) public pure returns (uint8){
        // uint8 starts at 0 (minimum value for unsigned integers)
        uint8 minValue = 0;
        // PROBLEM: If _val > 0, this will underflow!
        // Example: 0 - 1 = 255 (wraps around to the maximum value)
        // This can be exploited to create large unexpected values
        minValue -= _val;
        return minValue;    
    }
}

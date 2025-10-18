// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "../10.9_safemath/safemath.sol";

/**
 * @title NoVulnerableOverflowAndUnderflow
 * @notice This contract demonstrates SECURE protection against overflow and underflow
 * @dev Uses SafeMath library to detect and prevent arithmetic overflow/underflow
 */

contract NoVulnerableOverflowAndUnderflow {

    // SECURE OVERFLOW PROTECTION
    // Uses SafeMath to detect overflow and revert if it would occur
    function overflowExample(uint8 _val) public pure returns (uint8){
        uint8 maxValue = 255;
        // PROTECTION: SafeMath.add checks for overflow before performing addition
        // If 255 + _val would overflow, the function reverts with an error
        // This prevents the unexpected wrapping behavior
        maxValue = uint8(SafeMath.add(maxValue,_val));
        return maxValue;    
    }

    // SECURE UNDERFLOW PROTECTION
    // Uses SafeMath to detect underflow and revert if it would occur
    function underflowExample(uint8 _val) public pure returns (uint8){
        uint8 minValue = 0;
        // PROTECTION: SafeMath.sub checks for underflow before performing subtraction
        // If 0 - _val would underflow, the function reverts with an error
        // This prevents the unexpected large value that would result from underflow
        minValue = uint8(SafeMath.sub(minValue,_val));
        return minValue;    
    }
}
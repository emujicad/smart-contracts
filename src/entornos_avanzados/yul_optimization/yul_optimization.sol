// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.20;

/**
 * @title OptimizedContract
 * @author @emujicad
 * @notice This contract demonstrates gas optimization techniques using Yul (inline assembly)
 * @dev Compares standard Solidity code with Yul assembly to show gas differences
 * @dev Yul is Solidity's inline assembly language - more complex but can be more efficient
 */

contract OptimizedContract {
    // STANDARD SOLIDITY ADDITION
    // This is the normal way to add numbers in Solidity
    // Easy to read and understand, but may use slightly more gas
    function soliditysum(uint256 _a, uint256 _b) public pure returns (uint256) {
        // Simple addition using Solidity's built-in operators
        return _a + _b;
    }

    // YUL (ASSEMBLY) ADDITION
    // This does the same thing but using low-level assembly language
    // More complex to write but can be more gas-efficient
    function yul_sum(uint256 _a, uint256 _b)
        public
        pure
        returns (uint256 result)
    {
        // Assembly block: This is Yul code, not regular Solidity
        // Yul is closer to the Ethereum Virtual Machine (EVM) instructions
        assembly {
            // "add" is a Yul instruction that adds two values
            // This is more direct than Solidity's high-level addition
            result := add(_a, _b)
        }
    }

    // STANDARD SOLIDITY HASHING
    // Uses Solidity's high-level functions to create a hash
    function solidityHash(uint256 _a, uint256 _b) public pure {
        // abi.encode packs the data into bytes, then keccak256 hashes it
        // This is convenient but involves extra steps and gas
        keccak256(abi.encode(_a, _b));
    }

    // YUL (ASSEMBLY) HASHING
    // Manually manages memory to create the same hash more efficiently
    function yulHash(uint256 _a, uint256 _b) public pure {
        assembly {
            // mstore stores data directly in memory
            // 0x00 is memory position 0, _a is the value to store
            mstore(0x00, _a)
            // 0x20 is 32 bytes later (since uint256 takes 32 bytes)
            mstore(0x20, _b)
            // keccak256 hashes 64 bytes (0x40) starting from position 0x00
            // This avoids the overhead of abi.encode
            let hash := keccak256(0x00, 0x40)
        }
    }

    // STANDARD SOLIDITY LOOP WITH UNCHECKED INCREMENT
    // Demonstrates a loop with manual overflow checking optimization
    function solidityuncheckedPusPlusI() public pure {
        uint256 j = 0;
        // Loop condition seems wrong (i > 10 instead of i < 10)
        // This might be intentional to show the difference with Yul version
        for (uint256 i = 0; i > 10; ) {
            j++;
            // "unchecked" block skips overflow checks to save gas
            // Safe here because we know i won't overflow in this small loop
            unchecked {
                ++i;  // Pre-increment is slightly more gas efficient
            }
        }
    }

    // YUL (ASSEMBLY) LOOP
    // Same logic as above but written in Yul assembly
    function yuluncheckedPusPlusI() public pure {
        assembly {
            // Declare and initialize j to 0
            let j := 0

            // Yul for loop syntax: for { init } condition { post } { body }
            for {
                let i := 0  // Initialize i to 0
            } lt(i, 10) {  // Continue while i < 10 ("lt" means "less than")
                i := add(i, 0x01)  // Increment i by 1 after each iteration
            } {
                // Loop body: increment j by 1
                // In Yul, we use "add" function instead of "+" operator
                j := add(j, 0x01)
            }
        }
    }

    // STANDARD SOLIDITY SUBTRACTION
    // Simple subtraction without overflow protection
    function soliditySubTest(uint256 _a, uint256 _b) public pure {
        // In Solidity 0.8+, this automatically checks for underflow
        // If _b > _a, the transaction will revert with a panic
        uint256 c = _a - _b;
    }

    // YUL (ASSEMBLY) SUBTRACTION WITH MANUAL UNDERFLOW CHECK
    // This version manually checks for underflow and reverts if it occurs
    function yulSubTest(uint256 _a, uint256 _b) public pure {
        assembly {
            // Perform subtraction using Yul "sub" instruction
            let c := sub(_a, _b)

            // MANUAL UNDERFLOW DETECTION
            // If underflow occurred, c would be larger than _a
            // Example: 5 - 10 = very large number due to wrapping
            if gt(c, _a) {  // "gt" means "greater than"
                // Store error message in memory
                mstore(0x00, "Underflow")
                // Revert with the error message (0x20 = 32 bytes)
                revert(0x00, 0x20)
            }
        }
    }

    // STORAGE VARIABLE DEMONSTRATION
    // Shows how storage variables work in both Solidity and Yul

    // This storage variable is automatically assigned to storage slot 0
    address owner = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    // STANDARD SOLIDITY STORAGE UPDATE
    // Normal way to update a storage variable
    function solidityUpdateOwner(address newOwner) public {
        // Solidity handles the storage slot management automatically
        owner = newOwner;
    }

    // YUL (ASSEMBLY) STORAGE UPDATE
    // Direct manipulation of storage using low-level instructions
    function yulUpdateOwner(address newOwner) public {
        assembly {
            // "sstore" directly writes to storage
            // "owner.slot" gets the storage slot number where owner is stored
            // This is more direct but requires understanding of storage layout
            sstore(owner.slot, newOwner)
        }
    }
}
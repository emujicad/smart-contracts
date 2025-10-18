# SafeMath Library (Safe Arithmetic Operations)

This Solidity library, `SafeMath`, provides functions to perform arithmetic operations (addition and subtraction) securely, preventing overflow and underflow vulnerabilities. It is an essential tool for writing robust smart contracts, especially in Solidity versions prior to 0.8.0.

## What is a Library in Solidity?

A `library` in Solidity is a special type of contract that contains functions that can be reused by other contracts. Library functions are `internal` by default and execute in the context of the calling contract, meaning they do not have their own state storage. This makes them very gas-efficient.

## What are Overflow and Underflow?

*   **Overflow:** Occurs when the result of an arithmetic operation is greater than the maximum value that the data type can store. For example, if a `uint256` (which can store up to `2^256 - 1`) tries to store a larger value, the value "wraps around" and becomes a very small number.
*   **Underflow:** Occurs when the result of an arithmetic operation is less than the minimum value that the data type can store. For example, if a `uint256` (which can store from 0) tries to store a negative value, the value "wraps around" and becomes a very large number.

In Solidity, uncontrolled overflow or underflow can lead to unexpected behavior, balance manipulation, or even loss of funds.

## Key Concepts Used

### `pragma solidity ^0.8.0;`

Indicates the Solidity compiler version that should be used. `^0.8.0` means the library will compile with versions from 0.8.0 up to the next major version (e.g., 0.9.0). It is important to note that from Solidity 0.8.0 onwards, arithmetic operations by default revert in case of overflow/underflow, making `SafeMath` less necessary for newer versions, but it is still good practice for older versions or for explicit clarity.

### `library SafeMath { ... }`

Defines the `SafeMath` library.

### `internal pure`

*   `internal`: Means that functions can only be called from within the library or from contracts that use it.
*   `pure`: Indicates that functions do not modify the blockchain state or read any state variables. They only operate with input parameters and local variables.

## Library Functions

### `add(uint256 a, uint256 b) internal pure returns (uint256)`

*   **Purpose:** Performs a safe addition of two `uint256` numbers.
*   **Parameters:**
    *   `a`: The first operand.
    *   `b`: The second operand.
*   **How it works:**
    1.  `uint256 c = a + b;`: Performs the addition.
    2.  `require(c >= a, "SafeMath: addition overflow");`: **Here lies the security.** Checks that the result `c` is greater than or equal to `a`. If `c` is less than `a`, it means an overflow has occurred (the value has "wrapped around"), and the transaction will revert with the specified error message.
    3.  `return c;`: If there is no overflow, it returns the result of the addition.

### `sub(uint256 a, uint256 b) internal pure returns (uint256)`

*   **Purpose:** Performs a safe subtraction of two `uint256` numbers.
*   **Parameters:**
    *   `a`: The minuend.
    *   `b`: The subtrahend.
*   **How it works:**
    1.  `require(b <= a, "SafeMath: subtraction overflow");`: **Here lies the security.** Checks that `b` is less than or equal to `a`. If `b` is greater than `a`, it means the result would be negative, which would cause an underflow for a `uint256`. The transaction will revert with the specified error message.
    2.  `uint256 c = a - b;`: Performs the subtraction.
    3.  `return c;`: If there is no underflow, it returns the result of the subtraction.

## Why is this library important?

Before Solidity 0.8.0, arithmetic operations did not include automatic overflow/underflow checks. This meant that developers had to implement these checks manually or use libraries like `SafeMath` to ensure the security of their contracts. `SafeMath` became a de facto standard for preventing these critical errors.

Although in Solidity 0.8.0 and later the compiler adds these checks by default, `SafeMath` is still useful for:

*   **Compatibility:** Working with older codebases.
*   **Explicit Clarity:** Making it explicit that safe operations are being performed.
*   **`unchecked` Operations:** If a developer uses an `unchecked { ... }` block to save gas, they could still use `SafeMath` within that block for specific operations that require security.

## How to use this library?

To use `SafeMath` in your contract, you must first import it and then use the `using` keyword to attach it to a data type, for example:

```solidity
import "./10.9_safemath.sol";

contract MyContract {
    using SafeMath for uint256; // Attaches SafeMath to uint256

    uint256 public myValue;

    function addSafely(uint256 _val) public {
        myValue = myValue.add(_val); // Uses the add function from SafeMath
    }

    function subSafely(uint256 _val) public {
        myValue = myValue.sub(_val); // Uses the sub function from SafeMath
    }
}
```
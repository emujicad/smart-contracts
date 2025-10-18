# NoVulnerableOverflowAndUnderflow Smart Contract (Overflow/Underflow Prevention)

This Solidity contract, `NoVulnerableOverflowAndUnderflow`, is an example demonstrating how to prevent overflow and underflow vulnerabilities in arithmetic operations. It uses the `SafeMath` library to perform additions and subtractions securely, ensuring that results remain within data type limits.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract illustrates a fundamental security practice to avoid arithmetic errors that can have serious consequences in smart contracts.

## What are Overflow and Underflow?

*   **Overflow:** Occurs when the result of an arithmetic operation is greater than the maximum value that the data type can store. For example, if a `uint8` (which can store up to 255) tries to store 256, the value "wraps around" and becomes 0.
*   **Underflow:** Occurs when the result of an arithmetic operation is less than the minimum value that the data type can store. For example, if a `uint8` (which can store from 0) tries to store -1, the value "wraps around" and becomes 255.

In Solidity, uncontrolled overflow or underflow can lead to unexpected behavior, balance manipulation, or even loss of funds.

## Key Concepts Used

### `pragma solidity >=0.7.0 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.7.0 <0.9.0` means the contract will compile with versions from 0.7.0 up to 0.8.x. It is important to note that from Solidity 0.8.0 onwards, arithmetic operations by default revert in case of overflow/underflow, making `SafeMath` less necessary for newer versions, but it is still good practice for older versions or for explicit clarity.

### `import "../10.9_safemath/10.9_safemath.sol";`

This line imports the `SafeMath` library from the `10.9_safemath.sol` file. `SafeMath` is a library that provides safe functions for arithmetic operations, reverting the transaction if an overflow or underflow occurs.

## Contract Functions

### `overflowExample(uint8 _val) public pure returns (uint8)`

*   **Purpose:** Demonstrates how to perform an addition safely to prevent an overflow.
*   **Parameters:**
    *   `_val`: A `uint8` value to add.
*   **How it works:**
    1.  `uint8 maxValue = 255;`: A `maxValue` variable is initialized with the maximum value a `uint8` can hold.
    2.  `maxValue = uint8(SafeMath.add(maxValue,_val));`: Instead of using `maxValue + _val`, `SafeMath.add(maxValue, _val)` is used. If the sum of `maxValue` and `_val` exceeds 255, the `SafeMath.add` function will revert the transaction, preventing the overflow.

### `underflowExample(uint8 _val) public pure returns (uint8)`

*   **Purpose:** Demonstrates how to perform a subtraction safely to prevent an underflow.
*   **Parameters:**
    *   `_val`: A `uint8` value to subtract.
*   **How it works:**
    1.  `uint8 minValue = 0;`: A `minValue` variable is initialized with the minimum value a `uint8` can hold.
    2.  `minValue = uint8(SafeMath.sub(minValue,_val));`: Instead of using `minValue - _val`, `SafeMath.sub(minValue, _val)` is used. If the subtraction of `minValue` and `_val` results in a negative number (i.e., less than 0), the `SafeMath.sub` function will revert the transaction, preventing the underflow.

## Why is this approach "Non-Vulnerable"?

This contract is safe against overflows and underflows because it uses the `SafeMath` library. `SafeMath` implements internal checks for each arithmetic operation (addition, subtraction, multiplication, division) that revert the transaction if the result exceeds the data type limits. This ensures that arithmetic operations always produce valid results and prevents malicious manipulations or unexpected errors due to overflows or underflows.

In Solidity versions 0.8.0 and later, the compiler automatically adds these checks for most arithmetic operations, reducing the need for `SafeMath`. However, for earlier versions or when explicit control is needed, `SafeMath` remains a valuable tool.

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Call `overflowExample(value)`:**
    *   If `value` is 0, the result will be 255.
    *   If `value` is 1 or more, the transaction will revert, demonstrating overflow prevention.
3.  **Call `underflowExample(value)`:**
    *   If `value` is 0, the result will be 0.
    *   If `value` is 1 or more, the transaction will revert, demonstrating underflow prevention.

# VulnerableOverflowAndUnderflow Smart Contract (Overflow/Underflow Vulnerability)

This Solidity contract, `VulnerableOverflowAndUnderflow`, is an example illustrating a **critical overflow and underflow vulnerability** in arithmetic operations. It demonstrates how the lack of proper checks can lead to unexpected and potentially exploitable results.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of handling arithmetic operations carefully in Solidity.

## What are Overflow and Underflow?

*   **Overflow:** Occurs when the result of an arithmetic operation is greater than the maximum value that the data type can store. For example, if a `uint8` (which can store up to 255) tries to store 256, the value "wraps around" and becomes 0.
*   **Underflow:** Occurs when the result of an arithmetic operation is less than the minimum value that the data type can store. For example, if a `uint8` (which can store from 0) tries to store -1, the value "wraps around" and becomes 255.

In Solidity, uncontrolled overflow or underflow can lead to unexpected behavior, balance manipulation, or even loss of funds.

## Key Concepts Used

### `pragma solidity >=0.7.0 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.7.0 <0.9.0` means the contract will compile with versions from 0.7.0 up to 0.8.x. It is crucial to understand that in Solidity versions prior to 0.8.0, arithmetic operations did not automatically revert in case of overflow/underflow, which made contracts vulnerable if libraries like `SafeMath` were not used.

## Contract Functions

### `overflowExample(uint8 _val) public pure returns (uint8)`

*   **Purpose:** Demonstrates a vulnerable overflow.
*   **Parameters:**
    *   `_val`: A `uint8` value to add.
*   **How it works (Vulnerable to Overflow):
    1.  `uint8 maxValue = 255;`: A `maxValue` variable is initialized with the maximum value a `uint8` can hold.
    2.  `maxValue += _val;`: **Here lies the vulnerability.** If `_val` is greater than 0, the sum `maxValue + _val` will exceed the maximum value of `uint8` (255). In Solidity 0.7.x, this will not revert the transaction, but instead, the value "wraps around" (e.g., if `_val` is 1, `maxValue` becomes 0).

### `underflowExample(uint8 _val) public pure returns (uint8)`

*   **Purpose:** Demonstrates a vulnerable underflow.
*   **Parameters:**
    *   `_val`: A `uint8` value to subtract.
*   **How it works (Vulnerable to Underflow):
    1.  `uint8 minValue = 0;`: A `minValue` variable is initialized with the minimum value a `uint8` can hold.
    2.  `minValue -= _val;`: **Here lies the vulnerability.** If `_val` is greater than 0, the subtraction `minValue - _val` will result in a negative number. In Solidity 0.7.x, this will not revert the transaction, but instead, the value "wraps around" (e.g., if `_val` is 1, `minValue` becomes 255).

## Why is this approach "Vulnerable"?

This contract is vulnerable to overflows and underflows because it performs arithmetic operations directly without any security checks. In Solidity versions prior to 0.8.0, the compiler did not include automatic checks for these conditions. This means that:

*   **Unexpected Results:** Arithmetic operations can produce results that are not mathematically correct, which can lead to logical errors in the contract.
*   **Balance Manipulation:** In contracts that handle balances or quantities, an attacker could exploit an underflow to make their balance appear much larger than it actually is, or an overflow to reduce the balance of others.
*   **Unpredictable Behavior:** The contract can behave unpredictably, which can lead to financial losses or service disruption.

To avoid this vulnerability, in Solidity versions prior to 0.8.0, it was essential to use libraries like `SafeMath` for all arithmetic operations. In Solidity 0.8.0 and later, the compiler includes automatic checks that revert the transaction in case of overflow/underflow, making these operations safe by default.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Call `overflowExample(value)`:**
    *   Call with `value = 1`. Observe how the result is 0 (255 + 1 = 256, which wraps around to 0 for `uint8`).
3.  **Call `underflowExample(value)`:**
    *   Call with `value = 1`. Observe how the result is 255 (0 - 1 = -1, which wraps around to 255 for `uint8`).

These results demonstrate how values "wrap around" instead of reverting, which can be exploited in a real contract.
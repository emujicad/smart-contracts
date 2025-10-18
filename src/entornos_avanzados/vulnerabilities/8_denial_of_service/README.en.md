# NoVulnerableDenialOfService Smart Contract (Denial of Service Prevention)

This Solidity contract, `NoVulnerableDenialOfService`, is an example demonstrating how to prevent a Denial of Service (DoS) attack in a smart contract. It focuses on limiting the gas consumption of potentially costly operations to ensure the contract remains functional and accessible.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract illustrates the importance of gas efficiency and DoS prevention, as every operation on the blockchain has an associated cost and a block gas limit.

## What is a Denial of Service (DoS) Attack?

A Denial of Service (DoS) attack on the blockchain occurs when an attacker causes a function or the entire contract to consume an excessive amount of gas, either intentionally to block its use or accidentally due to inefficient design. This can make functions impossible to execute or prohibitively expensive.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `uint256 constant public MAX_ITERATION = 100;`

*   `uint256`: An unsigned 256-bit integer.
*   `constant`: Indicates that the value of this variable is fixed and known at compile time. It does not occupy storage space on the blockchain, which saves gas.
*   `public`: Allows the value of this constant to be read from outside the contract.

### `pure`

Functions marked as `pure` do not modify the blockchain state or read any state variables. They only operate with input parameters and local variables. They are the cheapest functions to execute in terms of gas, but can still be costly if they perform many computational operations.

## Contract Functions

### `performDoS(uint256 _iterations) public pure`

*   **Purpose:** Performs an operation that could be costly, but with a limit to prevent DoS.
*   **Parameters:**
    *   `_iterations`: The number of iterations to perform in the inner loop.
*   **How it works:**
    1.  `require(_iterations <= MAX_ITERATION, "Error. The max number of iterations was exceded");`: **Here lies the DoS prevention.** This line ensures that the number of iterations provided by the user (`_iterations`) never exceeds a predefined limit (`MAX_ITERATION`). If the user tries to pass a larger value, the transaction will revert, preventing excessive gas consumption.
    2.  `for (uint256 i = 0; i < _iterations; i++) { ... }`: An outer loop.
    3.  `uint256[] memory data = new uint256[](_iterations);`: Inside the outer loop, an array is created in memory. This is a gas-consuming operation.
    4.  `for (uint256 j = 0; j < _iterations; j++) { data[j] = j; }`: An inner loop that fills the array. This operation also consumes gas.

## Why is this approach "Non-Vulnerable"?

The Denial of Service (DoS) vulnerability often occurs when a function can be forced to consume an arbitrarily large amount of gas, either by an unbounded loop, the manipulation of very large dynamic arrays, or complex calculations that depend on unvalidated inputs.

This contract prevents DoS by:

*   **Limiting Iterations:** The `require(_iterations <= MAX_ITERATION, ...)` check is crucial. By setting a fixed upper limit for the number of iterations, the contract guarantees that the maximum gas cost of the `performDoS` function is predictable and bounded. This means an attacker cannot force the contract to spend an infinite amount of gas.
*   **Gas Predictability:** Although the function performs nested loops and creates arrays in memory (gas-consuming operations), the fact that the maximum number of iterations is limited makes the gas cost predictable and manageable. Users can know in advance the maximum cost of executing this function.

By implementing limits and validations on inputs that affect gas consumption, the contract protects itself against attacks that seek to exhaust network resources or render the contract inoperable.

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Call `performDoS(amount)`:** You can call this function with a value for `amount` (the number of iterations).
    *   If `amount` is less than or equal to `MAX_ITERATION` (100), the function will execute.
    *   If `amount` is greater than `MAX_ITERATION`, the transaction will revert with the error message, demonstrating DoS prevention.

# VulnerableDenialOfService Smart Contract (Denial of Service Vulnerability)

This Solidity contract, `VulnerableDenialOfService`, is an example illustrating a **critical Denial of Service (DoS) vulnerability**. It demonstrates how a function performing costly operations based on an unbounded user input can be exploited to make the contract inoperable or extremely expensive to use.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of validating and limiting user inputs that affect gas consumption.

## What is a Denial of Service (DoS) Attack?

A Denial of Service (DoS) attack on the blockchain occurs when an attacker causes a function or the entire contract to consume an excessive amount of gas, either intentionally to block its use or accidentally due to inefficient design. This can make functions impossible to execute or prohibitively expensive.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `pure`

Functions marked as `pure` do not modify the blockchain state or read any state variables. They only operate with input parameters and local variables. They are the cheapest functions to execute in terms of gas, but can still be costly if they perform many computational operations.

## Contract Functions

### `performDoS(uint256 _iterations) public pure`

*   **Purpose:** Performs a nested loop operation that is susceptible to a DoS attack.
*   **Parameters:**
    *   `_iterations`: The number of iterations to perform in the loops. **This parameter is the source of the vulnerability.**
*   **How it works (Vulnerable to DoS):
    1.  `for (uint256 i = 0; i < _iterations; i++) { ... }`: An outer loop that iterates `_iterations` times.
    2.  `uint256[] memory data = new uint256[](_iterations);`: Inside the outer loop, a memory array is created whose size depends on `_iterations`. Creating large arrays consumes a lot of gas.
    3.  `for (uint256 j = 0; j < _iterations; j++) { data[j] = j; }`: An inner loop that fills the array, also iterating `_iterations` times. Each assignment operation consumes gas.

## Why is this approach "Vulnerable"?

The Denial of Service (DoS) vulnerability in this contract is due to the `performDoS` function allowing a malicious user to directly control the amount of computational work the contract must perform. There is no upper limit for the `_iterations` parameter.

*   **Uncontrolled Loop:** If an attacker calls `performDoS` with a very large value for `_iterations` (e.g., 1000, 10000, or more), the contract will attempt to execute `_iterations * _iterations` assignment operations and array creations. This will result in exponentially high gas consumption.
*   **Exceeding Block Gas Limit:** The gas cost of the `performDoS` function can easily exceed the Ethereum network's block gas limit. When this happens, the transaction will fail with an "Out of Gas" error, and the function will become unexecutable for any `_iterations` value that causes this excess.
*   **Denial of Service Attack:** An attacker can use this vulnerability to:
    *   Make the function so expensive that no one can afford to execute it.
    *   Block the function's execution for all users, as any attempt to call it with a large `_iterations` will fail, and if the function is critical to the contract, this could paralyze it.

To avoid this vulnerability, user inputs that affect gas consumption should always be validated and limited, especially in loops or when manipulating dynamic data structures.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Call `performDoS(amount)`:** You can call this function with different values for `amount`.
    *   Start with small values (e.g., 10, 20) and observe the gas cost.
    *   Increase `amount` (e.g., 100, 200). You will see how the gas cost increases drastically.
    *   Eventually, by using a sufficiently large value for `amount`, the transaction will fail with an "Out of Gas" error, demonstrating the DoS vulnerability.
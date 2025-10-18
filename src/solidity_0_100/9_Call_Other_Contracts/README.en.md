# Interacting with Other Contracts in Solidity

This document explains how smart contracts can call and interact with each other on the blockchain, a concept known as composability. The `call_other_contract.sol` file demonstrates the standard, high-level method for this interaction.

Composability is a core feature of DeFi (Decentralized Finance), allowing different protocols (like Uniswap, Aave, etc.) to be combined like "money legos."

## The Contracts in the File

1.  **`ContratoPrueba` (TestContract):** This is our target contract. It has state variables (`x`, `value`) and functions to set and get their values. It's a simple contract that will be called by another.
2.  **`LlamarContratoPrueba` (CallTestContract):** This is our caller contract. It contains functions that demonstrate how to interact with an already deployed `ContratoPrueba`.

---

## How to Call Another Contract (The High-Level Method)

To interact with another contract, you need two key pieces of information:

1.  **The Address of the Target Contract:** The unique location of the contract on the blockchain.
2.  **The Interface of the Target Contract:** The function signatures (names, parameters, return types) of the contract you want to call. You don't need the full source code, just the function definitions.

In Solidity, you can provide the full contract source code (like in our example) or a formal `interface` definition. An `interface` is like a contract skeleton:

```solidity
// An interface for ContratoPrueba
interface IContratoPrueba {
    function setX(uint _x) external;
    function getX() external view returns (uint);
    // ... and so on
}
```

### The Calling Syntax

The standard syntax to call a function on another contract is:

`TargetContractName(target_address).functionToCall(arguments);`

Let's break down the functions in `LlamarContratoPrueba`.

### Reading Data from another contract

```solidity
function getX(address _test) external view returns (uint x) {
    x = ContratoPrueba(_test).getX();
}
```

1.  `ContratoPrueba(_test)`: We take the address of the target contract (`_test`) and cast it into the `ContratoPrueba` type. This tells Solidity, "Treat the contract at this address as a `ContratoPrueba`."
2.  `.getX()`: Now that Solidity knows the contract's type, we can simply call its public/external functions as if they were part of our own contract.

This is a **read-only** call because `getX()` is a `view` function. It does not consume significant gas.

### Writing Data to another contract

```solidity
function setX(ContratoPrueba _test, uint _x) external {
    _test.setX(_x);
}
```

-   The principle is the same. We call the `setX` function on the target contract.
-   This is a **state-changing** call, as it modifies the `x` variable in `ContratoPrueba`. This will create a real transaction on the blockchain and consume gas.

### Sending Ether While Calling a Function

```solidity
function setXandSendEther(address _test, uint _x) external payable {
    ContratoPrueba(_test).setXandReceiveEther{value: msg.value}(_x);
}
```

-   This demonstrates a more advanced and powerful feature.
-   **`{value: msg.value}`**: This special syntax is used to send Ether along with a function call. `msg.value` is the amount of Ether that was sent to the `setXandSendEther` function.
-   This Ether is forwarded to the `ContratoPrueba` contract, which can then access it inside its `setXandReceiveEther` function (which must be marked `payable`).

## Summary

Inter-contract communication is a cornerstone of Solidity. The high-level method, where you cast an address to a known contract type or interface, is the most common, readable, and secure way to build interconnected applications on Ethereum.

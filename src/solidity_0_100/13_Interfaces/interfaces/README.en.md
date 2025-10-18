# ICounter Interface

This file defines the `ICounter` interface. An interface in Solidity is a collection of function definitions without implementation. It defines a contract's public API, allowing other contracts to interact with it without needing to know its internal logic.

## Key features of interfaces:
- They cannot have any functions implemented.
- They can inherit from other interfaces.
- All declared functions must be `external`.
- They cannot have a constructor.
- They cannot have state variables.

## Functions

### `count()`
Declares a function to get the current count.
- **Visibility:** `external`
- **State Mutability:** `view`
- **Returns:** `uint`

### `inc()`
Declares a function to increment the count.
- **Visibility:** `external`
# IERC20Metadata Interface (Fungible Token Standard Metadata)

This Solidity file, `IERC20Metadata.sol`, defines an **optional interface** for the ERC-20 token standard. This interface specifies functions for an ERC-20 token to provide additional information (metadata) such as its name, symbol, and the number of decimals it uses. It does not contain any implementation logic, only the function signatures.

## What is an Interface in Solidity?

An interface is a type of abstract contract that only contains function and event declarations, but not their implementation. It is used to:

*   **Define Standards:** Like ERC-20, to ensure that all contracts implementing the interface follow the same rules.
*   **Inter-Contract Interaction:** Allows one contract to interact with another contract without knowing its full source code, only its interface.
*   **Compile-Time Verification:** The compiler can verify that a contract claiming to implement an interface actually implements all its functions and events.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the interface will compile with versions from 0.8.24 up to the next major version (e.g., 0.9.0).

### `interface IERC20Metadata { ... }`

Declares the `IERC20Metadata` interface.

### `external view` and `external`

*   `external`: Means that the function can only be called from outside the contract.
*   `view`: Indicates that the function does not modify the contract state. These are read-only functions and do not cost gas to execute (when called outside a transaction).

## Optional ERC-20 Standard Functions (Metadata)

The `IERC20Metadata` interface defines the following optional functions:

### `function name() external view returns (string memory);`

*   **Purpose:** Returns the human-readable name of the token (e.g., "MyToken").

### `function symbol() external view returns (string memory);`

*   **Purpose:** Returns the short symbol of the token (e.g., "MTK").

### `function decimals() external returns (uint8);`

*   **Purpose:** Returns the number of decimals the token uses for its representation. Commonly 18, similar to Ether, meaning 1 token is divided into `10^18` smaller units.

## How is this Interface Used?

A contract that wants to be an ERC-20 token and provide standard metadata must `implement` this interface in addition to the main `IERC20`. This means the contract must have all the functions defined in `IERC20Metadata` with the exact signatures. For example:

```solidity
import "./IERC20.sol";
import "./IERC20Metadata.sol";

contract MyToken is IERC20, IERC20Metadata {
    // ... implementation of all IERC20 and IERC20Metadata functions and events ...
}
```

By doing this, any application or service that understands the `IERC20Metadata` interface will be able to easily obtain the token's name, symbol, and decimals, improving interoperability and user experience.
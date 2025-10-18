# IERC20 Interface (Fungible Token Standard)

This Solidity file, `IERC20.sol`, defines the **interface** for the ERC-20 token standard. An interface in Solidity is like a "contract" of what another contract should do. It specifies the functions and events that a token contract must implement to be considered ERC-20 compliant. It does not contain any implementation logic, only the function signatures and events.

## What is an Interface in Solidity?

An interface is a type of abstract contract that only contains function and event declarations, but not their implementation. It is used to:

*   **Define Standards:** Like ERC-20, to ensure that all contracts implementing the interface follow the same rules.
*   **Inter-Contract Interaction:** Allows one contract to interact with another contract without knowing its full source code, only its interface.
*   **Compile-Time Verification:** The compiler can verify that a contract claiming to implement an interface actually implements all its functions and events.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the interface will compile with versions from 0.8.24 up to the next major version (e.g., 0.9.0).

### `interface IERC20 { ... }`

Declares the `IERC20` interface.

### `event Transfer(address indexed _from, address indexed _to, uint256 _value);`

This is an event that must be emitted whenever tokens are transferred. It is crucial for external applications to track token movements.

*   `indexed`: The `indexed` keywords make parameters "searchable" in blockchain logs, which facilitates event filtering.

### `event Approval(address indexed _owner, address indexed _spender, uint256 _value);`

This event must be emitted whenever a `_spender` is approved to spend tokens on behalf of an `_owner`.

### `external view` and `external`

*   `external`: Means that the function can only be called from outside the contract.
*   `view`: Indicates that the function does not modify the contract state. These are read-only functions and do not cost gas to execute (when called outside a transaction).

## Mandatory ERC-20 Standard Functions

The `IERC20` interface defines the six main functions that any ERC-20 token must have:

### `function totalSupply() external view returns (uint256);`

*   **Purpose:** Returns the total supply of tokens in circulation.

### `function balanceOf(address _owner) external view returns (uint256);`

*   **Purpose:** Returns the token balance of a specific address.
*   **Parameters:**
    *   `_owner`: The address whose balance is to be queried.

### `function transfer(address _to, uint256 _value) external returns (bool);`

*   **Purpose:** Transfers `_value` of tokens from the sender (`msg.sender`) to the `_to` address.
*   **Return:** `true` if the transfer was successful, `false` otherwise (although modern practice is to revert on failure).

### `function transferFrom(address _from, address _to, uint256 _value) external returns (bool);`

*   **Purpose:** Transfers `_value` of tokens from the `_from` address to the `_to` address, using the prior approval of `_from` by the sender (`msg.sender`).
*   **Return:** `true` if the transfer was successful.

### `function approve(address _spender, uint256 _value) external returns (bool);`

*   **Purpose:** Allows an address (`_spender`) to spend up to `_value` of tokens on behalf of the sender (`msg.sender`).
*   **Return:** `true` if the approval was successful.

### `function allowance(address _owner, address _spender) external view returns (uint256);`

*   **Purpose:** Returns the amount of tokens that `_spender` can spend on behalf of `_owner`.

## How is this Interface Used?

A contract that wants to be an ERC-20 token must `implement` this interface. This means the contract must have all the functions and events defined in `IERC20` with the exact signatures. For example:

```solidity
import "./IERC20.sol";

contract MyToken is IERC20 {
    // ... implementation of all IERC20 functions and events ...
}
```

By doing this, any application or contract that understands the `IERC20` interface will be able to interact with `MyToken` in a standard way.
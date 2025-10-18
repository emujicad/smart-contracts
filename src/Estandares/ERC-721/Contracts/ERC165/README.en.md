# ERC165 Abstract Contract (Interface Detection Standard)

This Solidity contract, `ERC165.sol`, provides a basic implementation of the **EIP-165** standard. This standard allows smart contracts to declare which interfaces (sets of functions) they implement. It is fundamental for interoperability on the blockchain, as it allows other contracts or applications to query whether a given contract supports a specific functionality.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. `ERC165` is an `abstract` contract, meaning it cannot be deployed directly, but is designed to be inherited by other contracts that need interface detection functionality.

## What is EIP-165?

EIP-165 (Ethereum Improvement Proposal 165) is a standard that defines a method for contracts to publish the interfaces they implement. This is useful because it allows a contract to check if another contract supports a particular set of functions without having to try calling those functions and risking the transaction failing.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the contract will compile with versions from 0.8.24 up to the next major version (e.g., 0.9.0).

### `import "../../interfaces/IERC165/IERC165.sol";`

This line imports the `IERC165` interface, which defines the `supportsInterface` function that must be implemented.

### `abstract contract ERC165 is IERC165 { ... }`

*   `abstract contract`: An abstract contract cannot be deployed by itself. It is designed to be a base for other contracts, providing common functionalities that can be extended or modified.
*   `is IERC165`: Indicates that this contract implements the `IERC165` interface.

## Contract Functions

### `supportsInterface(bytes4 interfaceId) public view virtual override returns (bool)`

*   **Purpose:** This is the central function of the EIP-165 standard. It allows querying whether the contract implements a specific interface.
*   **Parameters:**
    *   `interfaceId`: A unique 4-byte identifier for the interface to be queried. This ID is calculated by XORing the function selectors of all functions in the interface.
*   **How it works:**
    *   `public view virtual override`: 
        *   `public`: Can be called by anyone.
        *   `view`: Does not modify the contract state.
        *   `virtual`: Allows contracts inheriting from `ERC165` to override this function to add support for more interfaces.
        *   `override`: Indicates that this function is overriding a function from the `IERC165` interface.
    *   `return interfaceId == type(IERC165).interfaceId;`: In this basic implementation, the function only returns `true` if the provided `interfaceId` matches the `interfaceId` of the `IERC165` interface itself. Contracts that inherit from `ERC165` and want to declare support for other interfaces (like `IERC721`) will need to override this function to include those checks.

## How is this Contract Used?

Other contracts that need to implement the EIP-165 standard (such as ERC-721 or ERC-1155 tokens) will inherit from `ERC165`. Then, they will override the `supportsInterface` function to add the logic that declares support for their own interfaces. For example, an ERC-721 contract would override `supportsInterface` to return `true` for both `type(IERC165).interfaceId` and `type(IERC721).interfaceId`.

This allows an application or a blockchain explorer to ask any contract: "Do you implement the ERC-721 interface?" and receive a reliable answer.
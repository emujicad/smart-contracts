# IERC721 Interface (Non-Fungible Token Standard - NFT)

This Solidity file, `IERC721.sol`, defines the **interface** for the **EIP-721** non-fungible token (NFT) standard. An NFT is a unique and non-repeatable digital asset, such as a digital artwork, a collectible, or virtual property. This interface specifies the set of functions and events that an NFT contract must implement to be compatible with the Ethereum ecosystem (wallets, marketplaces, etc.). It inherits from `IERC165` to be able to announce that it implements this interface.

## What is an Interface in Solidity?

An interface is a type of abstract contract that only contains function and event declarations, but not their implementation. It is used to:

*   **Define Standards:** Like ERC-721, to ensure that all contracts implementing the interface follow the same rules.
*   **Inter-Contract Interaction:** Allows one contract to interact with another contract without knowing its full source code, only its interface.
*   **Compile-Time Verification:** The compiler can verify that a contract claiming to implement an interface actually implements all its functions and events.

## Key Concepts Used

### `pragma solidity ^0.8.20;`

Indicates the Solidity compiler version that should be used. `^0.8.20` means the interface will compile with versions from 0.8.20 up to the next major version (e.g., 0.9.0).

### `import {IERC165} from "../IERC165/IERC165.sol";`

This line imports the `IERC165` interface, which is the standard for interface detection. By inheriting from `IERC165`, an ERC-721 contract can inform other contracts that it supports the ERC-721 standard.

### `interface IERC721 is IERC165 { ... }`

Declares the `IERC721` interface and specifies that it inherits from `IERC165`.

## ERC-721 Standard Events

### `event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);`

*   **Purpose:** Emitted when a token with ID `tokenId` is transferred from `from` to `to`.
*   **Importance:** Events are crucial for external applications (like block explorers or NFT marketplaces) to track token movements without having to read the entire contract state. `indexed` parameters allow for more efficient searching and filtering of these events.

### `event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);`

*   **Purpose:** Emitted when `owner` approves `approved` to manage the `tokenId` token.
*   **Importance:** This is like giving permission to someone else to move your digital trading card.

### `event ApprovalForAll(address indexed owner, address indexed operator, bool approved);`

*   **Purpose:** Emitted when `owner` approves or disapproves an `operator` to manage *all* their tokens.
*   **Importance:** This is a broader permission than `Approval`. An "operator" could be, for example, an NFT marketplace that needs to be able to transfer your tokens on your behalf when you sell them.

## Mandatory ERC-721 Standard Functions

The `IERC721` interface defines the main functions that any ERC-721 token must have:

### `function balanceOf(address owner) external view returns (uint256 balance);`

*   **Purpose:** Returns the number of tokens (NFTs) owned by an `owner` address.

### `function ownerOf(uint256 tokenId) external view returns (address owner);`

*   **Purpose:** Returns the owner's address of the token with ID `tokenId`.

### `function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;`

### `function safeTransferFrom(address from, address to, uint256 tokenId) external;`

*   **Purpose:** Safely transfers a token from `from` to `to`.
*   **Security:** The "safe" version checks if the recipient is a contract capable of receiving NFTs. If `to` is a contract, it must implement the `onERC721Received` function. This prevents tokens from getting "stuck" in contracts that don't know how to handle them.

### `function transferFrom(address from, address to, uint256 tokenId) external;`

*   **Purpose:** Transfers a token from `from` to `to`.
*   **WARNING!** This is an "unsafe" transfer. If `to` is a contract that doesn't know how to handle NFTs, the token could be lost forever. It's generally better to use `safeTransferFrom`.

### `function approve(address to, uint256 tokenId) external;`

*   **Purpose:** Grants permission to `to` to transfer the `tokenId` token on behalf of the owner. Only one address can be approved per token at a time.

### `function setApprovalForAll(address operator, bool approved) external;`

*   **Purpose:** Approves or revokes an `operator` to manage *all* tokens of the caller (`msg.sender`).

### `function getApproved(uint256 tokenId) external view returns (address operator);`

*   **Purpose:** Returns the approved address for a specific `tokenId`.

### `function isApprovedForAll(address owner, address operator) external view returns (bool);`

*   **Purpose:** Queries if an `operator` is approved to manage all assets of an `owner`.

## How is this Interface Used?

A contract that wants to be an ERC-721 token must `implement` this interface. This means the contract must have all the functions and events defined in `IERC721` with the exact signatures. By doing this, any application or contract that understands the `IERC721` interface will be able to interact with the token in a standard way.
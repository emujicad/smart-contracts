# TokenERC721 Smart Contract (Non-Fungible Token Standard - NFT)

This Solidity contract, `TokenERC721`, is a comprehensive implementation of the **ERC-721** standard for non-fungible tokens (NFTs). An NFT is a unique digital asset that is not interchangeable with another of its kind, such as a digital artwork, a collectible, or virtual property. This contract manages the creation (minting), transfer, and ownership tracking of these unique assets, and also implements the EIP-165 standard for interface detection.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. `TokenERC721` defines the rules and logic for the existence and management of NFTs on the blockchain.

## What is an ERC-721 Token (NFT)?

ERC-721 is the technical standard for non-fungible tokens on Ethereum. Unlike ERC-20 tokens (fungible), each ERC-721 token is unique and has a distinctive `tokenId`. This makes them ideal for representing unique and collectible assets.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the contract will compile with versions from 0.8.24 up to the next major version (e.9. 0.9.0).

### Interface Imports

*   `../../interfaces/IERC165/IERC165.sol`: Interface for the EIP-165 standard, which allows contracts to declare which interfaces they support.
*   `../../interfaces/IERC721/IERC721.sol`: Main interface of the ERC-721 standard, which defines the mandatory functions and events for an NFT.
*   `../../interfaces/IERC721Receiver/IERC721Receiver.sol`: Interface for contracts that can safely receive NFTs.

### `contract TokenERC721 is IERC165, IERC721 { ... }`

Declares the `TokenERC721` contract and indicates that it implements the `IERC165` and `IERC721` interfaces.

### State Variables (Mappings)

*   `_owners (mapping(uint256 => address))`: Associates each `tokenId` with its owner's address.
*   `_balances (mapping(address => uint256))`: Stores the number of NFTs each address owns.
*   `_tokenApprovals (mapping(uint256 => address))`: Stores the approved address to transfer a specific `tokenId`.
*   `_operatorApprovals (mapping(address => mapping(address => bool)))`: Stores whether an `operator` has permission to manage all tokens of an `owner`.

## ERC-165 Standard Functions

### `supportsInterface(bytes4 interfaceId) public view virtual override returns (bool)`

*   **Purpose:** Allows other contracts or applications to query whether this contract supports a specific interface (like ERC-721 or ERC-165).
*   **How it works:** Returns `true` if the provided `interfaceId` matches that of `IERC721` or `IERC165`.

## ERC-721 Standard Functions

### `balanceOf(address owner) public view virtual override returns (uint256)`

*   **Purpose:** Returns the number of NFTs owned by an address.

### `ownerOf(uint256 tokenId) public view virtual override returns (address)`

*   **Purpose:** Returns the owner's address of a specific `tokenId`.

### `approve(address to, uint256 tokenId) public virtual override`

*   **Purpose:** Grants permission to an address (`to`) to transfer a specific `tokenId`.
*   **Restrictions:** Only the token owner or an approved operator can call this function.

### `setApprovalForAll(address operator, bool approved) public virtual override`

*   **Purpose:** Grants or revokes permission for an `operator` to manage *all* tokens of the sender (`msg.sender`).

### `getApproved(uint256 tokenId) public view virtual override returns (address operator)`

*   **Purpose:** Returns the address that is approved to transfer a specific `tokenId`.

### `isApprovedForAll(address owner, address operator) public view virtual override returns (bool)`

*   **Purpose:** Queries whether an `operator` has permission to manage all tokens of an `owner`.

### `safeTransferFrom(address from, address to, uint256 tokenId)` (two versions)

*   **Purpose:** Safely transfers a token from `from` to `to`. The version with `bytes calldata data` allows sending additional data.
*   **Security:** Includes a check to ensure that the recipient contract (`to`) can handle NFTs (by calling `onERC721Received`). If the recipient is a contract that does not implement this function, the transaction reverts, preventing NFTs from getting "stuck."

### `transferFrom(address from, address to, uint256 tokenId) public virtual override`

*   **Purpose:** Transfers a token from `from` to `to` ("less safe" version).
*   **Warning:** It is the caller's responsibility to ensure that the recipient (`to`) can handle the token. It does not perform the `onERC721Received` check.

## Internal Functions (Main Logic)

### `_safeMint(address to, uint256 tokenId)` (two versions)

*   **Purpose:** Safely mints (creates) a new token and assigns it to `to`.
*   **Security:** Includes the `_checkOnERC721Received` verification to ensure the recipient can handle the NFT.

### `_mint(address to, uint256 tokenId) internal virtual`

*   **Purpose:** Core logic for minting a new token. Updates balances and assigns ownership.
*   **Restrictions:** Cannot mint to the zero address or a token that already exists.

### `_transfer(address from, address to, uint256 tokenId) internal virtual`

*   **Purpose:** Core logic for transferring a token. It is used by all transfer functions.
*   **How it works:** Checks ownership, clears previous approvals, updates balances and owners, and emits a `Transfer` event.

### `_beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual`

*   **Purpose:** A "hook" that can be overridden by child contracts to add custom logic before any transfer (e.g., whitelists).

### `_approve(address to, uint256 tokenId) internal virtual`

*   **Purpose:** Sets the approval for a `tokenId`.

### `_exists(uint256 tokenId) internal view virtual returns (bool)`

*   **Purpose:** Checks if a token with the given `tokenId` exists.

### `_isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool)`

*   **Purpose:** Checks if an address (`spender`) is authorized to transfer a `tokenId` (is the owner, an approved operator, or has specific approval).

### `_checkOnERC721Received(...) internal virtual returns(bool)`

*   **Purpose:** Calls the `onERC721Received` function on a recipient contract if `to` is a contract. This is part of the `safeTransferFrom` security.

### `isContract(address addr) private view returns (bool)`

*   **Purpose:** Helper function to determine if an address is a smart contract (has code).

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed, you can start minting NFTs.
2.  **Mint NFTs:** Use a minting function (which would typically be added in a contract inheriting from `TokenERC721`) to create new tokens and assign them to addresses.
3.  **Transfer NFTs:** Use `transferFrom` or `safeTransferFrom` to move NFTs between addresses.
4.  **Manage Approvals:** Use `approve` to allow others to transfer your NFTs, or `setApprovalForAll` to give full control to an operator.
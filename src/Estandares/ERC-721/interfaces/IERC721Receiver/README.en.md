# IERC721Receiver Interface (Safe ERC-721 Token Receiver)

This Solidity file, `IERC721Receiver.sol`, defines the **interface** for any contract that wishes to safely receive ERC-721 tokens. It is a fundamental part of the `safeTransferFrom` mechanism of the ERC-721 standard, designed to prevent the accidental loss of NFTs when sent to contracts.

## What is an Interface in Solidity?

An interface is a type of abstract contract that only contains function and event declarations, but not their implementation. It is used to:

*   **Define Standards:** Like `IERC721Receiver`, to ensure that contracts implementing this interface follow the rules for safe NFT reception.
*   **Inter-Contract Interaction:** Allows one contract (the NFT sender) to interact with another contract (the NFT receiver) in a predictable manner.
*   **Compile-Time Verification:** The compiler can verify that a contract claiming to implement an interface actually implements all its functions and events.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the interface will compile with versions from 0.8.24 up to the next major version (e.g., 0.9.0).

### `interface IERC721Receiver { ... }`

Declares the `IERC721Receiver` interface.

### `external returns (bytes4)`

*   `external`: Means that the function can only be called from outside the contract.
*   `returns (bytes4)`: Indicates that the function must return a `bytes4` value. This value is a "magic number" or function selector, which the NFT sending contract expects to confirm that the receiver is ready to handle the token.

## Interface Functions

### `function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);`

*   **Purpose:** This is the only function defined in the `IERC721Receiver` interface. It is automatically called by the NFT sending contract (the one executing `safeTransferFrom`) on the recipient contract after a safe transfer.
*   **Parameters:**
    *   `operator`: The address that initiated the `safeTransferFrom` call.
    *   `from`: The address that owned the token before the transfer.
    *   `tokenId`: The unique ID of the token that has been received.
    *   `data`: Optional additional data that can be sent with the transfer.
*   **Return:** To confirm that the recipient contract is prepared to receive the token, this function **must return** the "magic number" (selector) of its own function signature: `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.

## How is this Interface Used?

When the `safeTransferFrom` function is used to send an NFT to an address that is a contract, the NFT sending contract (the one implementing ERC-721) will attempt to call the `onERC721Received` function on the recipient contract. If the recipient contract:

1.  Does not implement the `IERC721Receiver` interface.
2.  Implements the interface but `onERC721Received` does not return the correct "magic number."
3.  The call to `onERC721Received` fails or reverts.

...then the original `safeTransferFrom` transfer will revert. This ensures that NFTs are not accidentally sent to contracts that do not know how to handle them, preventing tokens from getting "stuck" and unrecoverable.

A contract that wants to receive NFTs safely must `implement` this interface and ensure that its `onERC721Received` function returns the correct value. For example:

```solidity
import "./IERC721Receiver.sol";

contract MyNFTCollector is IERC721Receiver {
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4) {
        // Here you can add logic to handle the received NFT
        // For example, record that you have received the token

        // MUST return the function selector to confirm reception
        return this.onERC721Received.selector;
    }
}
```
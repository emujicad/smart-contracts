# ERC-721 Smart Contract Project

## Overview

This project is an educational implementation of the **EIP-721** non-fungible token (NFT) standard in Solidity. The goal is to provide a clear and well-documented example of how an NFT contract works, designed for people who are new to Web3 and smart contract development.

The main contract, `TokenERC721.sol`, implements all the mandatory functions of the ERC-721 standard, as well as the **EIP-165** standard for interface detection.

## File Structure

The project is organized into the following files:

-   `TokenERC721.sol`: This is the heart of the project. It is the smart contract that implements the logic of an NFT. Here it is defined how tokens are created (minting), how they are transferred, who owns each one, and how permissions are managed.

-   `ERC165.sol`: A base contract that implements the EIP-165 standard. Our `TokenERC721` inherits from this contract to be able to "announce" to other contracts which functionalities (interfaces) it supports.

-   `interfaces/`: This folder contains the "interfaces" that our contract promises to implement. An interface in Solidity is like a contract: it defines what functions must have a contract, but without implementing the logic.

    -   `IERC165/IERC165.sol`: Defines the `supportsInterface` function, which is the core of the EIP-165 standard. It allows other contracts to ask: "Hey, do you support X functionality?".

    -   `IERC721/IERC721.sol`: The main interface for NFTs. It defines all the functions and events that an ERC-721 token must have, such as `transferFrom`, `ownerOf`, `balanceOf`, `approve`, etc. This ensures that our NFT is compatible with any wallet or marketplace in the Ethereum ecosystem.

    -   `IERC721Receiver/IERC721Receiver.sol`: A crucial interface for safe transfers. A contract that wants to safely receive an NFT must implement the `onERC721Received` function defined here. This prevents NFTs from being accidentally sent to contracts that do not know how to handle them, avoiding their loss.

## Key Concepts for Beginners

#### What is an NFT (ERC-721)?

A Non-Fungible Token (NFT) is a type of cryptographic token that represents a unique asset. "Non-fungible" means that it is unique and cannot be replaced by another identical one. Think of the difference between a 10 euro bill (fungible, you can exchange it for any other 10 euro bill) and an original work of art like the Mona Lisa (non-fungible, it is unique). Each NFT has a unique token ID that distinguishes it from the others.

#### What is an Interface in Solidity?

An interface is like a skeleton of a contract. It defines a set of functions that a contract must implement, specifying their names, parameters, and return types, but without any internal logic. When a contract "implements" an interface, it commits to providing the code for all the functions of that interface. This is essential for interoperability, as it allows different contracts to communicate in a standardized way.

#### What is the ERC-165 standard?

It is a standard that allows a contract to announce which interfaces it implements. The only function it has is `supportsInterface(bytes4 interfaceID)`, which returns `true` or `false`. In this way, before trying to interact with a contract, we can ask it if it supports the interface we need (for example, the ERC-721 interface).

#### `transferFrom` vs. `safeTransferFrom`

Both functions transfer an NFT, but there is a key security difference:

-   `transferFrom`: Simply changes the ownership of the token. If you send it to a contract address that is not designed to handle NFTs, the token can get stuck and be lost forever.
-   `safeTransferFrom`: This is the recommended option. Before transferring the token to a contract address, it checks if that contract implements the `IERC721Receiver` interface. If it doesn't, the transfer fails, protecting the NFT from being lost.

#### `approve` vs. `setApprovalForAll`

These functions are used to give permissions to other accounts to transfer your NFTs:

-   `approve`: You give permission to a specific account to transfer a **single NFT** with a specific token ID. The permission is revoked once the token is transferred.
-   `setApprovalForAll`: You give permission (or revoke it) to another account (an "operator") to manage **all your NFTs** in that contract. This is very useful for NFT marketplaces, as it allows them to transfer any token you put up for sale without you having to approve each one individually.

## How to Use

1.  **Compilation**: You can compile these contracts in a development environment like Remix, Hardhat, or Foundry. Make sure to select a compiler compatible with the specified Solidity version (`^0.8.20` or higher).
2.  **Deployment**: Deploy the `TokenERC721.sol` contract.
3.  **Interaction**: Once deployed, you can interact with the contract's functions:
    -   Call `safeMint(address, tokenId)` to create a new NFT and assign it to an address.
    -   Use `transferFrom` or `safeTransferFrom` to send the token to another address.
    -   Use `approve` or `setApprovalForAll` to manage permissions.
    -   Use `ownerOf` and `balanceOf` to query ownership information.

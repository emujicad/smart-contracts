// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {IERC165} from "../IERC165/IERC165.sol";

/**
 * @title IERC721
 * @dev Interface of the EIP-721 Non-Fungible Token Standard.
 *      It defines a set of functions and events that an NFT contract must implement
 *      to be compatible with other applications in the Ethereum ecosystem (like
 *      wallets, marketplaces, etc.).
 *      An NFT is a unique, non-repeatable token. Think of it as a digital trading card
 *      or a unique piece of art. Each token has a unique ID.
 *      It inherits from IERC165 to be able to announce that it implements this interface.
 *      https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when a token with ID `tokenId` is transferred from `from` to `to`.
     *      Events are a way to log information on the blockchain that external
     *      applications can listen to without having to query the contract's state.
     *      `indexed` allows for more efficient searching and filtering of these events.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` approves `approved` to manage the `tokenId` token.
     *      This is like giving permission to someone else to move your trading card.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` approves or disapproves an `operator` to manage
     *      ALL of their tokens. This is a broader permission than `Approval`.
     *      An "operator" could be, for example, an NFT marketplace that needs to be able
     *      to transfer your tokens on your behalf when you sell them.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @notice Returns the number of tokens (NFTs) owned by an `owner`.
     * @param owner The address of the account to query.
     * @return balance The number of tokens owned by the `owner`.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @notice Returns the owner of the token with ID `tokenId`.
     * @param tokenId The unique ID of the token to query.
     * @return owner The address of the token's owner.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @notice Safely transfers a token from `from` to `to`.
     * @dev "Safely" means it checks if the recipient is a contract
     *      capable of receiving NFTs to prevent tokens from being locked forever.
     *      If `to` is a contract, it must implement the `onERC721Received` function.
     * @param from The address of the current owner of the token.
     * @param to The address of the recipient.
     * @param tokenId The ID of the token to transfer.
     * @param data Additional data that can be sent with the transfer, with no specific format.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;

    /**
     * @notice Overload of the `safeTransferFrom` function without the `data` parameter.
     *      It's a simpler version of the safe transfer.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @notice Transfers a token from `from` to `to`.
     * @dev WARNING! This is an "unsafe" transfer. If `to` is a contract
     *      that doesn't know how to handle NFTs, the token could be lost forever.
     *      It's generally better to use `safeTransferFrom`.
     * @param from The address of the current owner.
     * @param to The address of the recipient.
     * @param tokenId The ID of the token to transfer.
     */
    function transferFrom(address from, address to, uint256 tokenId) external;

    /**
     * @notice Grants permission to `to` to transfer the `tokenId` token on behalf of the owner.
     *      Only one address can be approved per token at a time.
     * @param to The address that will receive the permission.
     * @param tokenId The ID of the token to approve.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @notice Approves or revokes an `operator` to manage all tokens of the caller (msg.sender).
     * @param operator The address of the operator.
     * @param approved `true` to approve, `false` to revoke.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @notice Returns the approved address for a specific `tokenId`.
     * @param tokenId The ID of the token to query.
     * @return operator The address of the operator approved for this token.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @notice Queries if an `operator` is approved to manage all assets of an `owner`.
     * @param owner The address of the owner.
     * @param operator The address of the operator.
     * @return `true` if the operator is approved, `false` otherwise.
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}
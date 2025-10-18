// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title IERC721Receiver
 * @dev Interface for any contract that wants to safely receive ERC721 tokens.
 *      When `safeTransferFrom` is used to send an NFT to a contract, the
 *      recipient contract MUST implement this interface. If it doesn't, the transfer is reverted.
 *      This prevents the accidental loss of tokens.
 */
interface IERC721Receiver {
    /**
     * @notice This function is called on the recipient contract after a safe transfer (`safeTransferFrom`).
     * @dev It must return the "magic number" (selector) of this same function to confirm
     *      that the contract is prepared to receive the token. The selector is `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
     * @param operator The address that called `safeTransferFrom`.
     * @param from The address that owned the token before the transfer.
     * @param tokenId The ID of the token that has been received.
     * @param data Additional data sent with the transfer.
     * @return Must return `this.onERC721Received.selector`.
     */
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}
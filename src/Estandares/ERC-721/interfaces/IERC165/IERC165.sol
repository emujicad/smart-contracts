// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title IERC165
 * @dev Interface of the EIP-165 standard, which allows smart contracts to
 *      declare the interfaces they implement. This is useful for other
 *      contracts to check if a contract can handle certain types of
 *      interactions (like receiving a specific type of token).
 *      https://eips.ethereum.org/EIPS/eip-165
 */
interface IERC165 {
    /**
     * @notice Queries if a contract implements a specific interface.
     * @param interfaceId The ID of the interface to query. This ID is a `bytes4`
     *                    calculated from the signature of the interface's functions.
     * @return `true` if the contract implements the `interfaceId`, `false` otherwise.
     */
    function supportsInterface (bytes4 interfaceId) external view returns (bool);
}

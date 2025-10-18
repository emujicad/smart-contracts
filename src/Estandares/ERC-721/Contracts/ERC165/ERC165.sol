// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "../../interfaces/IERC165/IERC165.sol";

/**
 * @title ERC165
 * @dev Basic implementation of the EIP-165 standard.
 *      Contracts that inherit from this contract will already have the
 *      EIP-165 functionality implemented.
 *      An `abstract` contract means it is not intended to be deployed
 *      directly, but to be inherited by other contracts.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @notice Queries if the contract implements a specific interface.
     * @dev This basic implementation only recognizes the IERC165 interface itself.
     *      Contracts that inherit from ERC165 and want to declare support for
     *      other interfaces (like IERC721) will need to override this function.
     * @param interfaceId The ID of the interface to query.
     * @return `true` if the contract implements the `interfaceId`, `false` otherwise.
     */
    function supportsInterface (bytes4 interfaceId) public view virtual override returns (bool){
        // Compare the provided interfaceId with the ID of the IERC165 interface.
        // type(IERC165).interfaceId calculates the standard interface ID.
        return interfaceId == type(IERC165).interfaceId;
    }
}
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {ERC20FlashMint} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20FlashMint.sol";
import {ERC20Pausable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import {ERC20Permit} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title MyToken
 * @dev This is an example ERC-20 token contract that extends functionalities from OpenZeppelin.
 * It includes features like burning, pausing, flash minting, and access control (ownership).
 * This contract is designed to be a versatile token for various use cases.
 */
contract MyToken is ERC20, ERC20Burnable, ERC20Pausable, Ownable, ERC20Permit, ERC20FlashMint {
    /**
     * @dev Constructor to initialize the token and set the initial owner.
     * @param initialOwner The address that will be the owner of this contract,
     * and will have special permissions (e.g., pausing, minting).
     */
    constructor(address initialOwner)
        ERC20("MyToken", "EAM") // Initializes the ERC-20 token with a name ("MyToken") and symbol ("EAM").
        Ownable(initialOwner) // Sets the initial owner of the contract.
        ERC20Permit("MyToken") // Initializes the EIP-2612 permit functionality with the token name.
    {}

    /**
     * @dev Pauses all token transfers.
     * Only the contract owner can call this function.
     * Useful for emergency situations or maintenance.
     */
    function pause() public onlyOwner {
        _pause(); // Calls the internal _pause function inherited from ERC20Pausable.
    }

    /**
     * @dev Unpauses all token transfers.
     * Only the contract owner can call this function.
     * Resumes normal token operations after a pause.
     */
    function unpause() public onlyOwner {
        _unpause(); // Calls the internal _unpause function inherited from ERC20Pausable.
    }

    /**
     * @dev Mints new tokens and assigns them to a specific address.
     * Only the contract owner can call this function.
     * @param to The address to which the new tokens will be minted.
     * @param amount The amount of new tokens to mint.
     */
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); // Calls the internal _mint function inherited from ERC20.
    }

    // The following functions are overrides required by Solidity.
    /**
     * @dev Internal function that is called before any token transfer or balance update.
     * It ensures that the token transfer rules (e.g., pause status) are applied.
     * This function is overridden from both ERC20 and ERC20Pausable to combine their logic.
     * @param from The address from which tokens are being transferred.
     * @param to The address to which tokens are being transferred.
     * @param value The amount of tokens being transferred.
     */
    function _update(address from, address to, uint256 value)
        internal
        override(ERC20, ERC20Pausable)
    {
        super._update(from, to, value); // Calls the _update function of the parent contracts.
    }
}

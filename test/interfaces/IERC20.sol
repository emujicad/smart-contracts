// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// This is an interface for the ERC20 token standard.
// Interfaces define the functions that a contract must implement.
// They are a way to interact with contracts without having their full code.
// This is useful for interoperability, as any token that implements the ERC20 standard
// will have the functions defined in this interface.
interface IERC20 {
    // Events are a way for contracts to communicate with the outside world.
    // They are emitted when something important happens in the contract, and can be listened to by applications.

    // Emitted when tokens are transferred from one address to another.
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Emitted when an owner approves a spender to withdraw a certain amount of tokens.
    event Approval(address indexed _owner, address indexed spender, uint256 value);

    // These are the six mandatory functions that an ERC20 token contract must implement.

    // Returns the total amount of tokens in existence.
    function totalSupply() external view returns (uint256);

    // Returns the amount of tokens owned by a specific account.
    function balanceOf(address account) external view returns (uint256);

    // Transfers a certain amount of tokens from the caller's account to a recipient.
    function transfer(address recipient, uint256 amount) external returns (bool);

    // Returns the remaining number of tokens that a spender is allowed to withdraw from an owner's account.
    function allowance(address owner, address spender) external view returns (uint256);

    // Allows a spender to withdraw a certain amount of tokens from the caller's account.
    function approve(address spender, uint256 amount) external returns (bool);

    // Transfers a certain amount of tokens from a sender's account to a recipient, using the allowance mechanism.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

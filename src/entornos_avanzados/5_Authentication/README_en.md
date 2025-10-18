# Simple Wallet Contract (Wallet.sol)

This Solidity contract (`Wallet.sol`) implements a basic Ether wallet on the blockchain. It allows a designated owner to receive and withdraw Ether, and also to transfer contract ownership. It's a fundamental example for understanding fund management and access control in smart contracts.

## Key Features

*   **Ether Reception**: The contract can receive Ether directly.
*   **Ether Withdrawal**: Only the owner can withdraw a specified amount of Ether.
*   **Ownership Control**: The address that deploys the contract becomes the owner, with exclusive access to sensitive functions.
*   **Change Owner**: The current owner can transfer contract ownership to a new address.

## Solidity Concepts to Learn

*   **`pragma solidity ^0.8.24;`**: Defines the Solidity compiler version.
*   **`address payable public owner;`**: Declaration of a state variable for the owner.
    *   **`address payable`**: A special address type that can receive Ether.
    *   **`public`**: Allows reading the owner's address from outside the contract.
*   **`constructor() { ... }`**: Special function executed only once upon contract deployment.
    *   **`msg.sender`**: Global variable representing the address that initiated the current transaction.
*   **`receive() external payable { ... }`**: Special function executed when the contract receives plain Ether (simple Ether transaction without call data).
    *   **`external`**: Can only be called from outside the contract.
    *   **`payable`**: Allows the function to receive Ether.
*   **`function withdraw(uint256 _amount) external { ... }`**: Function to withdraw Ether.
    *   **`require(condition, "error message");`**: Used to validate conditions and revert the transaction if not met. Here, used for access control, ensuring only the owner can withdraw.
    *   **`payable(address).transfer(amount);`**: Method to send Ether to an address.
*   **`function changeOwner(address _newOwner) external { ... }`**: Function to change the owner.

## How It Works

1.  **Deployment**: Upon deploying the contract, the deploying address is set as the `owner`.
2.  **Ether Deposit**: Anyone can send Ether directly to the contract's address. The Ether will be stored in the contract's balance.
3.  **Ether Withdrawal**: The `owner` can call the `withdraw()` function to send a specified amount of Ether from the contract to their own address. If a non-owner address attempts to call this function, the transaction will fail.
4.  **Change Ownership**: The current `owner` can transfer contract ownership to a new address by calling `changeOwner()`.

## Usage (Educational Example)

This contract is an excellent starting point for understanding how contracts that manage funds can be built and how to implement basic security patterns like ownership-based access control.

To interact with this contract (after deploying it to a testnet or development environment):

*   Send Ether to the contract's address.
*   Call `withdraw()` from the owner's address to withdraw funds.
*   Try calling `withdraw()` from a non-owner address to observe the error message.
*   Call `changeOwner()` to transfer ownership to another address.

This contract provides a solid foundation for exploring more advanced concepts of fund management and security in Solidity.

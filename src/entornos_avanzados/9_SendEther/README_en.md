# Ether Sending and Receiving Contract (SendEther.sol)

This Solidity contract (`SendEther.sol`) is a fundamental example for understanding how smart contracts can handle Ether (Ethereum's native cryptocurrency). It demonstrates how a contract can receive, store, and send Ether, as well as implement basic access control for sensitive functions.

## Key Features

*   **Ether Reception**: The contract can receive Ether directly via its `receive()` function.
*   **Ether Storage**: Received Ether is stored in the contract's balance.
*   **Retiro de Ether**: The contract owner can withdraw a specified amount of Ether.
*   **Ownership Control**: Implements an `owner` mechanism to restrict access to critical functions.
*   **Change Owner**: The current owner can transfer contract ownership to a new address.
*   **Events**: Emits a `deposit` event each time Ether is received, making it easy to track funds.

## Solidity Concepts to Learn

*   **`pragma solidity ^0.8.24;`**: Defines the Solidity compiler version.
*   **`address payable public owner;`**: Declaration of a state variable for the owner.
    *   **`address payable`**: A special address type that can receive Ether.
    *   **`public`**: Allows reading the owner's address from outside the contract.
*   **`event deposit(address indexed sender, uint256 amount);`**: Event declaration to log deposits.
    *   **`indexed`**: Makes the `sender` parameter searchable in blockchain logs.
*   **`constructor() payable { ... }`**: Special function executed only once upon contract deployment.
    *   **`payable`**: Allows the constructor to receive Ether during deployment.
    *   **`msg.sender`**: Global variable representing the address that initiated the current transaction.
*   **`receive() external payable { ... }`**: Special function executed when the contract receives plain Ether (simple Ether transaction without call data).
    *   **`external`**: Can only be called from outside the contract.
    *   **`payable`**: Allows the function to receive Ether.
    *   **`msg.value`**: Global variable representing the amount of Ether (in Wei) sent with the current transaction.
*   **`function withdraw(uint256 _amount) external { ... }`**: Function to withdraw Ether.
    *   **`require(condition, "error message");`**: Used to validate conditions and revert the transaction if not met. Here, used for access control.
    *   **`address(this).balance`**: Global variable returning the contract's current Ether balance.
    *   **`payable(address).transfer(amount);`**: Method to send Ether to an address. It's a secure way but with a gas limit of 2300.
*   **`function changeOwner(address _newOwner) external { ... }`**: Function to change the owner.
*   **`view`**: State mutability modifier for functions that only read the contract's state and do not modify it.
*   **`returns (uint256)`**: Specifies the data type a function returns.

## How It Works

1.  **Deployment**: Upon deploying the contract, the deploying address becomes the `owner`.
2.  **Ether Deposit**: Anyone can send Ether directly to the contract's address. This will trigger the `receive()` function, which will emit a `deposit` event to log the transaction.
3.  **Ether Withdrawal**: Only the `owner` can call the `withdraw()` function to take Ether out of the contract. It checks that `msg.sender` is the `owner` before allowing the withdrawal.
4.  **Change Ownership**: The current `owner` can transfer contract ownership to a new address by calling `changeOwner()`.

## Usage (Educational Example)

This contract is fundamental for understanding Ether management in Solidity. It's a building block for more complex contracts that need to handle funds, such as vaults, payment systems, or crowdfunding contracts.

To interact with this contract (after deploying it to a testnet or development environment):

*   Send Ether directly to the contract's address.
*   Call `withdraw()` from the owner's address to withdraw funds.
*   Try calling `withdraw()` from a non-owner address to see how the transaction fails.
*   Call `changeOwner()` to transfer ownership.

This contract provides a solid foundation for understanding Ether interactions on the blockchain and access control patterns.

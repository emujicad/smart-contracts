# NoVulnerableAccessControl Smart Contract (Secure Access Control)

This Solidity contract, `NoVulnerableAccessControl`, is an example demonstrating how to implement secure access control in a smart contract. It uses the `onlyOwner` pattern to restrict the execution of certain functions to a single authorized address, thereby preventing unwanted access.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract illustrates a fundamental security practice: ensuring that only authorized entities can perform critical actions.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `uint private secretNumber;`

A private variable that stores a secret number. Its value can only be modified by the contract owner.

### `address private owner;`

This variable stores the address of the account that deployed the contract. This address will be the `owner` and will have special permissions.

### `constructor() { ... }`

The `constructor` is a special function that executes only once when the contract is deployed. Here, the `owner` is initialized:

*   `owner = msg.sender;`: Sets the contract deployer (`msg.sender`) as the initial `owner`. `msg.sender` is a global variable that always refers to the address that initiated the transaction.

### `modifier onlyOwner() { ... }`

A `modifier` is a piece of code that can be attached to functions to change their behavior declaratively. The `onlyOwner` modifier is a very common security pattern:

*   `require(msg.sender == owner, "Error. Only Owner can use this function");`: This line is the key to access control. `require` checks a condition, and if it's false, it reverts the entire transaction. Here, it ensures that the address calling the function (`msg.sender`) is exactly the same as the `owner`'s address.
*   `_;`: This special part of the modifier indicates where the code of the function to which the modifier is applied will be inserted. If the `require` condition passes, the function's code executes; otherwise, the transaction reverts.

## Contract Functions

### `setSecretNumber(uint _newNumber) public onlyOwner`

*   **Purpose:** Allows the contract owner to set a new value for `secretNumber`.
*   **Parameters:**
    *   `_newNumber`: The new secret number to set.
*   **How it works:** Thanks to the `onlyOwner` modifier, only the `owner`'s address can call this function and change the `secretNumber`. If another address tries to call it, the transaction will fail with the error message specified in the modifier's `require` statement.

### `getSecretNumber() public view returns (uint)`

*   **Purpose:** Allows anyone to read the current value of `secretNumber`.
*   **How it works:** This function is `public` and `view`, meaning it does not modify the contract state and can be called by anyone without gas cost to get the value of `secretNumber`.

## Why is this approach "Non-Vulnerable"?

This contract implements basic but effective access control. By using the `onlyOwner` modifier, it ensures that critical functions (like `setSecretNumber`) can only be executed by the authorized address. This prevents unauthorized users from modifying sensitive data or performing privileged actions, which is a common vulnerability in contracts without proper access control.

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet), the account that deploys it becomes the `owner`.
2.  **Set Secret Number (as Owner):** The `owner` can call `setSecretNumber()` to change the value of `secretNumber`.
3.  **Attempt to Set Secret Number (as Non-Owner):** If another account tries to call `setSecretNumber()`, the transaction will fail, demonstrating access control.
4.  **Get Secret Number (anyone):** Any account can call `getSecretNumber()` to read the current value.

# VulnerableAccessControl Smart Contract (Access Control Vulnerability)

This Solidity contract, `VulnerableAccessControl`, is an example illustrating a **critical vulnerability** in access control. It demonstrates how the lack of proper restrictions on important functions can allow any unauthorized user to modify sensitive data or perform privileged actions.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of implementing robust access control in Web3.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `uint private secretNumber;`

A private variable that stores a secret number. The intention is that only the owner can modify it, but the implementation is flawed.

### `address public owner;`

This variable stores the address of the account that deployed the contract. Although an `owner` exists, it is not used to restrict access to critical functions.

### `constructor() { ... }`

The `constructor` is a special function that executes only once when the contract is deployed. Here, the `owner` is initialized:

*   `owner = msg.sender;`: Sets the contract deployer (`msg.sender`) as the initial `owner`.

## Contract Functions

### `setSecretNumber(uint _newNumber) public`

*   **Purpose:** Allows setting a new value for `secretNumber`.
*   **Parameters:**
    *   `_newNumber`: The new secret number to set.
*   **How it works:** This function is `public`, meaning **anyone** can call it. There are no restrictions (like an `onlyOwner` modifier) preventing an unauthorized address from changing the value of `secretNumber`.

### `getSecretNumber() public view returns (uint)`

*   **Purpose:** Allows anyone to read the current value of `secretNumber`.
*   **How it works:** This function is `public` and `view`, meaning it does not modify the contract state and can be called by anyone without gas cost to get the value of `secretNumber`.

## Why is this approach "Vulnerable"?

The main vulnerability of this contract lies in the `setSecretNumber` function. Being a `public` function without any access restrictions, anyone can call this function and change the value of `secretNumber` at will. This means that data that should be controlled by a specific entity (the `owner`) can be manipulated by anyone.

In a real scenario, this could lead to:

*   **Data manipulation:** If `secretNumber` controls any critical logic or an important value, an attacker could change it for their benefit.
*   **Loss of control:** The contract owner loses exclusive control over this data.
*   **Unexpected behavior:** The contract could behave unpredictably if `secretNumber` is modified by malicious actors.

To avoid this vulnerability, functions like `setSecretNumber` that modify critical contract state should be protected with access control, such as the `onlyOwner` modifier or a more complex role-based system.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Set Secret Number (as Owner):** The `owner` can call `setSecretNumber()` to change the value of `secretNumber`.
3.  **Set Secret Number (as Non-Owner):** Any other account can call `setSecretNumber()` and change the value of `secretNumber`, demonstrating the vulnerability.
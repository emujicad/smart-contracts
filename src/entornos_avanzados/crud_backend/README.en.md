# User CRUD Smart Contract

This Solidity contract, `UserCrud`, is a basic example of how to implement CRUD (Create, Read, Update, Delete) operations to manage users on the blockchain. It is designed to be easy to understand for newcomers to Web3 and Solidity.

## What is a Smart Contract?

Imagine a smart contract as a program that lives on the blockchain. Once deployed, it functions exactly as programmed, with no possibility of being modified by anyone. In this case, our `UserCrud` contract allows us to interact with a list of users.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

This tells the Solidity compiler which version to use. It's like specifying the version of a programming language to ensure your code works correctly.

### `struct User { ... }`

A `struct` is like a template for creating objects. Here, `User` defines what a user looks like, with properties such as:

*   `id` (unique user identifier)
*   `name` (user's name)
*   `age` (user's age)
*   `isActive` (a `true` or `false` value to know if the user is active or has been logically "deleted")

### `mapping(uint256 => User) private users;`

A `mapping` is like a dictionary or a key-value map. In this case, each user `id` (`uint256`) is associated with a `User` object. It is very efficient for looking up users by their ID.

### `uint256 private nextId;`

This variable keeps track of the next available ID for a new user. It is incremented each time a user is created to ensure each one has a unique ID.

### `event UserCreated(...)`, `UserUpdated(...)`, `UserDeleted(...)`

`Events` are a way to log what happens in your contract on the blockchain. They are like "notifications" that external applications (like a web user interface) can listen to, to know when a user has been created, updated, or deleted. This is very useful because directly reading the state of the blockchain can be costly, but listening to events is more efficient.

## Contract Functions

### `createUser(string memory _name, uint256 _age) public`

*   **Purpose:** Adds a new user to the list.
*   **Parameters:**
    *   `_name`: The user's name (text).
    *   `_age`: The user's age (number).
*   **How it works:** Creates a new `User` object with a unique `id`, the provided name and age, and marks it as `isActive = true`. Then, it emits a `UserCreated` event.

### `readUser(uint256 _id) public view returns (User memory)`

*   **Purpose:** Retrieves the information of a specific user.
*   **Parameters:**
    *   `_id`: The ID of the user you want to search for.
*   **How it works:** Checks if the user exists and is active. If found, it returns the complete `User` object. Otherwise, it reverts the transaction with an error message.
*   **`view`:** Means that this function does not modify the state of the contract on the blockchain, so it does not cost gas to execute.

### `updateUser(uint256 _id, string memory _name, uint256 _age) public`

*   **Purpose:** Changes the name and age of an existing user.
*   **Parameters:**
    *   `_id`: The ID of the user to update.
    *   `_name`: The new name.
    *   `_age`: The new age.
*   **How it works:** Searches for the user by their ID, verifies that they exist and are active, and then updates their name and age. Emits a `UserUpdated` event.

### `deleteUser(uint256 _id) public`

*   **Purpose:** Logically "deletes" a user.
*   **Parameters:**
    *   `_id`: The ID of the user to "delete".
*   **How it works:** Instead of erasing the user from the blockchain (which is complex and costly), this function simply changes the `isActive` value to `false`. This means the user will no longer be considered active, but their record still exists. Emits a `UserDeleted` event.

### `getAllActiveUsers() public view returns (User[] memory)`

*   **Purpose:** Gets a list of all currently active users.
*   **How it works:** Iterates through all registered users, counts how many are active, and then creates a new array with only those active users to return. This function is also `view` and does not cost gas.

## How to interact with this contract?

Once deployed on an Ethereum network (or a testnet), you can interact with it using tools like Remix, Hardhat, Truffle, or through a user interface (DApp) you have built. Each public function can be called to perform the CRUD operations.
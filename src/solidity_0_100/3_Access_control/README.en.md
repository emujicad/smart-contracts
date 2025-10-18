# c1_AccessControl Smart Contract (Role-Based Access Control)

This Solidity contract, `c1_AccessControl`, implements a basic role-based access control system. It allows defining different roles (such as `ADMIN` or `USER`) and assigning or revoking these roles to specific addresses. Functions can be protected so that only users with a certain role can execute them.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract is fundamental for the security of decentralized applications, as it allows managing who can do what within the contract.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `event AssingRole (bytes32 indexed role, address indexed account);`
### `event RevokeRole (bytes32 indexed role, address indexed account);`

These are `events` that are emitted when a role is assigned or revoked to an account. They are useful for external applications to track changes in user permissions.

### `mapping (bytes32 => mapping (address => bool)) public roles;`

This is the core of the role system. It is a nested `mapping`:

*   The first key (`bytes32`) is the hash of the role name (e.g., `ADMIN`).
*   The second key (`address`) is the account address.
*   The value (`bool`) indicates whether the account has that role (`true`) or not (`false`).

### `bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));`
### `bytes32 private constant USER = keccak256(abi.encodePacked("USER"));`

These lines define unique identifiers for the `ADMIN` and `USER` roles. `keccak256(abi.encodePacked("ROLE_NAME"))` is used to generate a unique hash for each role name, which is a common practice to save storage space and avoid name collisions.

### `modifier onlyAdmin(bytes32 _role) { ... }`

A `modifier` is a piece of code that can be attached to functions to change their behavior. The `onlyAdmin` modifier checks if the account calling the function (`msg.sender`) has the specified role (`_role`).

*   `require(roles[_role][msg.sender], "Error. You are not authorized");`: If the account does not have the role, the transaction reverts.
*   `_;`: If the check passes, the code of the function to which the modifier is applied executes.

## Contract Functions

### `_assignRole (bytes32 _role, address _account) internal`

*   **Purpose:** Assigns a role to an account. It is an internal function, meaning it can only be called from within the contract.
*   **How it works:** Sets `roles[_role][_account]` to `true` and emits the `AssingRole` event.

### `_revokeRole (bytes32 _role, address _account) internal`

*   **Purpose:** Revokes a role from an account. It is also an internal function.
*   **How it works:** Sets `roles[_role][_account]` to `false` and emits the `RevokeRole` event.

### `assignRole (bytes32 _role, address _account) external onlyAdmin(ADMIN)`

*   **Purpose:** Public function to assign a role to an account.
*   **Restriction:** Only accounts with the `ADMIN` role can call this function, thanks to the `onlyAdmin(ADMIN)` modifier.

### `revokeRole (bytes32 _role, address _account) external onlyAdmin(ADMIN)`

*   **Purpose:** Public function to revoke a role from an account.
*   **Restriction:** Only accounts with the `ADMIN` role can call this function.

### `constructor () { ... }`

The `constructor` is a special function that executes only once when the contract is deployed. Here, the role system is initialized:

*   `_assignRole(ADMIN, msg.sender);`: Assigns the `ADMIN` role to the account that deploys the contract (`msg.sender`). This ensures that there is always at least one initial administrator.

## How to interact with this contract?

1.  **Deploy the Contract:** The account that deploys the contract automatically gets the `ADMIN` role.
2.  **Assign Roles (as ADMIN):** The administrator can call `assignRole` to give roles (like `USER` or even `ADMIN`) to other accounts.
3.  **Revoke Roles (as ADMIN):** The administrator can call `revokeRole` to remove roles from other accounts.
4.  **Check Roles:** You can query the `roles` mapping directly (since it is `public`) to see what roles each account has.
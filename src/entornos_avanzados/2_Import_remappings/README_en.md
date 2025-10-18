# ERC-20 Token Creation with Solmate (ImportERC20.sol)

This Solidity contract (`ImportERC20.sol`) demonstrates an efficient and common way to create an ERC-20 compliant token using the Solmate library. Solmate is known for its gas-optimized contracts and concise code, making it an excellent choice for Solidity developers.

## Key Features

*   **ERC-20 Import**: Utilizes Solmate's ERC-20 implementation.
*   **Simple Inheritance**: Creates a new token by directly inheriting from Solmate's `ERC20` contract and setting its basic properties (name, symbol, decimals) in the contract declaration.

## Solidity Concepts to Learn

*   **`pragma solidity ^0.8.13;`**: Defines the Solidity compiler version.
*   **`import "path/to/Contract.sol";`**: The `import` statement allows including code from other files or libraries. It's fundamental for modularity and code reuse in Solidity.
*   **`contract Token is ERC20(...) { ... }`**: Contract inheritance.
    *   **`is`**: Keyword used to indicate that a contract inherits from another. The `Token` contract gains all the functions and state variables of the `ERC20` contract.
    *   **Base Contract Constructor**: When inheriting, the constructor of the base contract (in this case, `ERC20`) is automatically called. Here, it's passed the initial token parameters: "CoinTest" (name), "CTK" (symbol), and 18 (decimals).
*   **ERC-20 Standard**: A set of rules and functions that a token must implement to be compatible with the Ethereum ecosystem. By inheriting from an ERC-20 implementation like Solmate's, your token automatically complies with this standard.

## How It Works

1.  **Import**: The line `import "solmate/tokens/ERC20.sol";` brings the code of Solmate's `ERC20` contract into your project.
2.  **Herencia y Configuración**: The line `contract Token is ERC20("CoinTest", "CTK", 18) {}` does two main things:
    *   Declares a new contract named `Token`.
    *   Indicates that `Token` is an extension of `ERC20`, meaning `Token` will have all the functions of an ERC-20 token (like `transfer`, `balanceOf`, `approve`, etc.) without needing to write them manually.
    *   Initializes the token with a name ("CoinTest"), a symbol ("CTK"), and 18 decimals.

## Usage (Quick Token Creation)

This pattern is ideal for quickly creating standard ERC-20 tokens for testing, development, or even for production projects when seeking efficiency and proven security.

To deploy this token:

1.  Ensure the Solmate library is correctly installed and accessible in your development environment (e.g., via `forge install solmate`).
2.  Compile and deploy the `Token` contract.

Once deployed, you will have a fully functional ERC-20 token with the specified properties, ready to interact with other applications and services on the blockchain.

This contract is an excellent example of how modularity and libraries can greatly simplify smart contract development, allowing developers to focus on the unique business logic of their applications.

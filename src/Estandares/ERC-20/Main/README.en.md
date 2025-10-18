# Main Smart Contract (Token Management)

This Solidity contract, `Main`, is an example demonstrating how to interact with a custom ERC-20 token (`ERC20.sol`) within another contract. It allows for token creation, selling tokens in exchange for Ether, generating new tokens, and querying balances and total supply.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. In this case, `Main` acts as a manager for an ERC-20 token.

## Key Concepts Used

### `pragma solidity ^0.8.24;`

Indicates the Solidity compiler version that should be used. `^0.8.24` means the contract will compile with versions from 0.8.24 up to the next major version (e.g., 0.9.0).

### `import "../ERC20.sol";`

This line imports the code from the `ERC20.sol` contract. This allows the `Main` contract to use the functionalities defined in `ERC20.sol`, such as token creation, transfers, etc.

### `ERC20 private _token;`

Declares a private `_token` variable of type `ERC20`. This variable will store the instance of our custom ERC-20 token.

### `address private owner;`

Stores the address of the person who deployed the `Main` contract. This is a common practice to implement functions that only the owner can execute.

### `address private contractAddress;`

Stores the address of the `Main` contract itself on the blockchain.

### `constructor() { ... }`

The `constructor` is a special function that runs only once when the contract is deployed on the blockchain. Here, variables are initialized:

*   `_token = new ERC20("TEST Coin", "TCI");`: Creates a new instance of the ERC-20 token with the name "TEST Coin" and the symbol "TCI".
*   `owner = msg.sender;`: Sets the contract deployer as the `owner`.
*   `contractAddress = address(this);`: Stores the address of this contract.

### `public pure` and `public payable`

*   **`public`**: The function can be called by anyone.
*   **`pure`**: The function does not read or modify the blockchain state. It only performs calculations with the input parameters.
*   **`payable`**: The function can receive Ether (the native cryptocurrency of Ethereum) along with the function call.

## Contract Functions

### `priceTokens(uint256 _numTokens) public pure returns (uint256)`

*   **Purpose:** Calculates the total price in Ether for a given amount of tokens.
*   **Parameters:**
    *   `_numTokens`: The amount of tokens for which the price is to be calculated.
*   **How it works:** Multiplies the token amount by `1 ether`. This means 1 token costs 1 Ether in this example.

### `buyTokens(address _client, uint256 _amount) public payable`

*   **Purpose:** Allows a user to buy tokens by sending Ether to the contract.
*   **Parameters:**
    *   `_client`: The address to which the purchased tokens will be sent.
    *   `_amount`: The amount of tokens to buy.
*   **How it works:**
    1.  Calculates the required `price` using `priceTokens`.
    2.  `require(msg.value >= price, "buy more tokens");`: Checks that the amount of Ether sent (`msg.value`) is sufficient to cover the price. If not, the transaction fails.
    3.  `returnValue = msg.value - price;`: Calculates the change if more Ether than necessary was sent.
    4.  `payable(msg.sender).transfer(returnValue);`: Sends the change back to the buyer.
    5.  `_token.transfer(_client, _amount);`: Transfers the purchased tokens from the `Main` contract to the client's address.

### `generateTokens(uint256 _amount) public`

*   **Purpose:** Generates a new amount of tokens and assigns them to the `Main` contract.
*   **Parameters:**
    *   `_amount`: The amount of new tokens to generate.
*   **How it works:** Calls the `increaseTotalSupply` function of the `_token` contract (our ERC-20) to increase the total supply and assign these new tokens to the `Main` contract's address.

### `getContractAddress() public view returns (address)`

*   **Purpose:** Returns the address of the `Main` contract itself.
*   **How it works:** Simply returns the value of `contractAddress`.

### `balanceAccount(address _account) public view returns (uint256)`

*   **Purpose:** Queries the token balance of a specific address.
*   **Parameters:**
    *   `_account`: The address whose token balance is to be queried.
*   **How it works:** Calls the `balanceOf` function of the `_token` contract to get the token balance of the provided address.

### `getTotalSupply() public view returns (uint256)`

*   **Purpose:** Returns the total supply of existing tokens.
*   **How it works:** Calls the `totalSupply` function of the `_token` contract to get the total supply of tokens.

## How to interact with this contract?

This contract would be deployed along with the `ERC20.sol` contract (which is imported). Once deployed, you can interact with its public functions through a user interface or directly from a blockchain development console (like Remix or Hardhat) to buy tokens, generate more, or query information.
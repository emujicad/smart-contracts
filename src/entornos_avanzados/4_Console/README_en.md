# Using `console.log` for Debugging

In smart contract development with Foundry, `console.log` is an indispensable debugging tool. It allows you to print messages and variable values from your Solidity contracts during test execution, similar to how it's used in JavaScript.

## How does it work?

Foundry provides a `console.log` implementation through a special contract (a "cheat code") that you can import into your test contracts. When you run your tests with an appropriate verbosity level, Foundry captures these calls and displays the output in your terminal.

## Importing `console.log`

To use `console.log` in your test contracts, you need to import `console.sol` from the `forge-std` library:

```solidity
import "forge-std/console.sol";
```

## Usage Examples

You can use `console.log` to print different data types:

*   **Strings and numbers:**
    ```solidity
    console.log("The value of my variable is:", myVariable);
    ```

*   **Addresses:**
    ```solidity
    console.log("The sender's address is:", msg.sender);
    ```

*   **Integers (with `console.logInt`):**
    ```solidity
    console.logInt(aSignedInteger);
    ```

## Important Considerations

*   **For development and testing only:** `console.log` has no effect on the mainnet or public testnets. It is a tool exclusively for the local Foundry development environment.
*   **Verbosity:** To see the output of `console.log`, you must run your tests with a high verbosity flag, such as `-vv`, `-vvv`, or `-vvvv`.

Using `console.log` is a fundamental practice for understanding the execution flow of your contracts, debugging errors, and verifying that variables contain the expected values during tests.
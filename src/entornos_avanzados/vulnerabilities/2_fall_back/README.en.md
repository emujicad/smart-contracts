# NoVulnerableFallBack Smart Contract (Secure Ether Handling)

This Solidity contract, `NoVulnerableFallBack`, is an example demonstrating a secure way to handle Ether reception in a smart contract. It focuses on how to avoid vulnerabilities related to `fallback` and `receive` functions, ensuring that Ether is only received intentionally and in a controlled manner.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract illustrates best practices for Ether management, a crucial aspect for fund security in Web3.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) private balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

### `fallback() external payable { ... }`

The `fallback` function is a special function that executes when a contract receives Ether and there is no call data, or when the call data does not match any other function in the contract. In this contract, the `fallback` function is designed to **revert** any attempt to send Ether unexpectedly:

*   `revert("Error: This funtion is not enabled to receive payments");`: This ensures that if someone sends Ether to the contract without specifying a valid function, the transaction will fail and the Ether will be returned. This prevents accidental or unwanted deposits.

### `receive() external payable { ... }`

The `receive` function is another special function, introduced in Solidity 0.6.0. It executes specifically when a contract receives Ether without call data (i.e., a "simple" Ether transfer).

*   In this contract, the `receive` function is empty (`{}`). This means that the contract **can receive Ether** through direct transfers (without call data), but it does not perform any additional logic. This is useful if the contract needs to receive Ether for its internal operation, but does not want the `fallback` logic to be activated.

## Contract Functions

### `deposit() external payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `external payable`: The function can be called from outside the contract and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.

### `withdraw() public`

*   **Purpose:** Allows a user to withdraw their deposited Ether from the contract.
*   **How it works:**
    1.  `uint256 amount = balances[msg.sender];`: Gets the amount of Ether the sender has available to withdraw.
    2.  `require(amount > 0, "Error: There is not found to withdraw");`: Checks that the user has funds to withdraw.
    3.  `balances[msg.sender] = 0;`: Resets the user's balance to zero to prevent double withdrawals (reentrancy).
    4.  `(bool success, ) = msg.sender.call{value: amount}("");`: Attempts to send Ether to `msg.sender` using `call`. This is a secure method for sending Ether because it forwards a fixed amount of gas (2300 gas) and returns a boolean `success` indicating whether the transfer was successful. If the transfer fails, the contract does not stop, but we can verify the result.
    5.  `require(success, "Error: Transfer failed");`: Checks that the Ether transfer was successful. If not, it reverts the transaction.

## Why is this approach "Non-Vulnerable"?

This contract is secure because:

*   **Deposit Control:** The `fallback` function explicitly reverts, preventing unintended Ether from getting "stuck" in the contract without clear logic for its handling. The `receive` function allows direct deposits if necessary, but without complex logic that could be exploited.
*   **Secure Withdrawals:** The `withdraw` function uses the "Checks-Effects-Interactions" pattern:
    1.  **Checks:** `require(amount > 0, ...)`
    2.  **Effects:** `balances[msg.sender] = 0;` (updates the state *before* the external interaction)
    3.  **Interactions:** `msg.sender.call{value: amount}("");`
    This pattern is crucial for preventing reentrancy attacks, where an attacker could repeatedly call the `withdraw` function before the balance is updated to zero.

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Withdraw Ether:** Call the `withdraw()` function to retrieve your deposited Ether.

# VulnerableFallBack Smart Contract (Fallback Vulnerability)

This Solidity contract, `VulnerableFallBack`, is an example illustrating a **critical vulnerability** related to the `fallback` function. It demonstrates how an incorrect implementation of this function can lead to reentrancy attacks, allowing an attacker to repeatedly withdraw funds in an unauthorized manner.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the dangers of not following security best practices when handling Ether.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) private balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

### `fallback() external payable { ... }`

The `fallback` function is a special function that executes when a contract receives Ether and there is no call data, or when the call data does not match any other function in the contract. In this contract, the `fallback` function is the source of the vulnerability:

*   `balances[msg.sender] += msg.value;`: This line updates the sender's balance with the received Ether. So far, it seems harmless.
*   `(bool success, ) = msg.sender.call{value: msg.value}("");`: **Here lies the vulnerability.** Immediately after updating the balance, the contract attempts to send the same `msg.value` back to the `msg.sender`. If the `msg.sender` is another malicious contract, it can have a `receive` or `fallback` function that, upon receiving the Ether, calls the `withdraw` function again (or even the `fallback` itself) of `VulnerableFallBack` before the attacker's balance has been set to zero. This allows for repeated withdrawal of funds.
*   `require(success, "Error: Transfer failed");`: Checks that the transfer was successful.

### `receive() external payable { ... }`

The `receive` function is present but empty. This means the contract can receive Ether directly without activating the `fallback` logic if Ether is sent without call data. However, the main vulnerability is in the `fallback`.

## Contract Functions

### `withdraw() public`

*   **Purpose:** Allows a user to withdraw their deposited Ether from the contract.
*   **How it works:**
    1.  `uint256 amount = balances[msg.sender];`: Gets the amount of Ether the sender has available to withdraw.
    2.  `require(amount > 0, "Error: There is not found to withdraw");`: Checks that the user has funds to withdraw.
    3.  `balances[msg.sender] = 0;`: Resets the user's balance to zero. **In a reentrancy-vulnerable contract, this line should execute *before* the external transfer.**
    4.  `(bool success, ) = msg.sender.call{value: amount}("");`: Attempts to send Ether to `msg.sender`.
    5.  `require(success, "Error: Transfer failed");`: Checks that the Ether transfer was successful.

## Why is this approach "Vulnerable"?

The main vulnerability of this contract is the **reentrancy** attack in the `fallback` function. When a malicious contract calls `VulnerableFallBack` and sends Ether, the `fallback` function is activated. Inside `fallback`, the `VulnerableFallBack` contract sends Ether back to the malicious contract *before* the attacker's balance has been updated to zero.

The attacking contract can have a `receive` or `fallback` function that, upon receiving the Ether, calls `VulnerableFallBack` again to withdraw more funds. This cycle can repeat multiple times, draining the `VulnerableFallBack` contract of its Ether, as the attacker's balance is not set to zero until the first call to `fallback` (or `withdraw`) finishes.

To prevent this, the "Checks-Effects-Interactions" pattern should be followed:
1.  **Checks:** `require(...)`
2.  **Effects:** Update the contract state (e.g., `balances[msg.sender] = 0;`)
3.  **Interactions:** Perform external calls (e.g., `msg.sender.call{value: amount}("");`)

In this contract, the external interaction occurs *before* the balance is set to zero in the `withdraw` function, and the `fallback` function also performs an external interaction immediately after a partial effect, which makes it vulnerable.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Send Ether:** Send Ether directly to the `VulnerableFallBack` contract (this will activate the `fallback` function).
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `fallback` or `withdraw` function of `VulnerableFallBack`.
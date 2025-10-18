# NoVulnerableReentrancy Smart Contract (Reentrancy Prevention)

This Solidity contract, `NoVulnerableReentrancy`, is an example demonstrating how to prevent the reentrancy vulnerability in a smart contract. It implements a secure withdrawal pattern that protects the contract's funds from malicious attacks.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract illustrates one of the most well-known vulnerabilities in Solidity and how to avoid it, which is crucial for fund security in Web3.

## What is the Reentrancy Vulnerability?

Reentrancy occurs when a contract makes an external call to another contract (or a user address) before updating its own state. If the external contract is malicious, it can "re-enter" the original contract and call the withdrawal function repeatedly before the original contract's state has been updated, thus draining the funds.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) public balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

## Contract Functions

### `deposit() external payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `external payable`: The function can be called from outside the contract and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Checks-Effects-Interactions Pattern):
    1.  **Checks:**
        *   `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  **Effects:**
        *   `balances[msg.sender] -= _amount;`: **This is key to preventing reentrancy.** The user's balance is updated (reduced) *before* making the external call to send the Ether. This ensures that, even if the external call attempts to "re-enter" the contract, the attacker's balance will have already been reduced, preventing additional withdrawals.
    3.  **Interactions:**
        *   `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: Attempts to send Ether to `msg.sender` using `send()`. `send()` is a low-level method that forwards a fixed amount of gas (2300 gas) and returns a boolean indicating success or failure. If the transfer fails, the transaction reverts due to the `require`.

## Why is this approach "Non-Vulnerable"?

This contract is secure against reentrancy attacks because it follows the security pattern known as **Checks-Effects-Interactions**:

1.  **Checks:** All necessary validations are performed (e.g., `require` to check the balance).
2.  **Effects:** The contract state is updated (e.g., `balances[msg.sender] -= _amount;`). **This is done before any external interaction.**
3.  **Interactions:** Finally, the external call is made (e.g., `payable(msg.sender).send(_amount);`).

By updating the user's balance *before* sending the Ether, the contract protects itself from an attacker attempting to call `withdraw` multiple times in a single transaction. When the attacker tries to "re-enter," their balance has already been reduced, and the initial check (`require(balances[msg.sender] >= _amount, ...)`) will fail, preventing the attack.

## How to interact with this contract?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Withdraw Ether:** Call the `withdraw(amount)` function to withdraw a specific amount of your deposited Ether.

# VulnerableReentrancy Smart Contract (Reentrancy Vulnerability)

This Solidity contract, `VulnerableReentrancy`, is an example illustrating a **critical vulnerability** known as reentrancy. It demonstrates how an incorrect implementation of a withdrawal function can allow an attacker to repeatedly drain the contract's funds.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of following security patterns when interacting with external contracts or user addresses.

## What is the Reentrancy Vulnerability?

Reentrancy occurs when a contract makes an external call to another contract (or a user address) before updating its own state. If the external contract is malicious, it can "re-enter" the original contract and call the withdrawal function repeatedly before the original contract's state has been updated, thus draining the funds.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) private balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

## Contract Functions

### `deposit() external payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `external payable`: The function can be called from outside the contract and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Vulnerable to Reentrancy):**
    1.  `require(_amount <= balances[msg.sender], "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  `(bool success, ) = msg.sender.call{value: _amount}("");`: **Here lies the vulnerability.** The contract makes an external call to send Ether to `msg.sender` *before* updating the sender's balance. If `msg.sender` is a malicious contract, it can execute arbitrary code at this point.
    3.  `require(success, "Error: Transfer failed");`: Checks that the transfer was successful.
    4.  `balances[msg.sender] -= _amount;`: Finally, the sender's balance is reduced. However, if the malicious contract "re-entered" before this line, it will have already withdrawn additional funds.

## Why is this approach "Vulnerable"?

This contract is vulnerable to **reentrancy** attacks due to the order of operations in the `withdraw` function. The recommended security pattern is **Checks-Effects-Interactions**:

1.  **Checks:** Perform all necessary validations.
2.  **Effects:** Update the contract state (e.g., reduce the user's balance).
3.  **Interactions:** Perform external calls.

In this contract, the order is **Checks-Interactions-Effects**. This allows an attacking contract, upon receiving Ether from the external call (`msg.sender.call{value: _amount}("");`), to "re-enter" the `withdraw` function of the `VulnerableReentrancy` contract before the attacker's balance has been reduced to zero. The attacker can repeat this process multiple times, draining the contract's funds until `VulnerableReentrancy` runs out of Ether or gas runs out.

**Attack Scenario:**
1.  An attacker deposits Ether into `VulnerableReentrancy`.
2.  The attacker calls `withdraw` from a malicious contract.
3.  `VulnerableReentrancy` checks the balance and then sends Ether to the malicious contract (`msg.sender.call{value: _amount}("");`).
4.  The malicious contract, in its `receive` or `fallback` function, calls `withdraw` again on `VulnerableReentrancy`.
5.  Since the attacker's balance in `VulnerableReentrancy` has not yet been reduced (the `balances[msg.sender] -= _amount;` line has not yet executed), the initial check (`require(_amount <= balances[msg.sender], ...)`) passes again.
6.  The cycle repeats, allowing the attacker to withdraw more Ether than they should, until the `VulnerableReentrancy` contract runs out of funds or gas is exhausted.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `withdraw` function of `VulnerableReentrancy`.
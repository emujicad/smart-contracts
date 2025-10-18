# VulnerableUncheckedSend Smart Contract (Reentrancy Vulnerability with send())

This Solidity contract, `VulnerableUncheckedSend`, is an example illustrating a **reentrancy vulnerability** despite using the `send()` function to transfer Ether. It demonstrates that, although `send()` is safer than `call` in terms of gas forwarded, it does not completely prevent reentrancy attacks if the order of operations is not correct.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of following the Checks-Effects-Interactions pattern even when using seemingly safer Ether transfer methods.

## What is the Reentrancy Vulnerability?

Reentrancy occurs when a contract makes an external call to another contract (or a user address) before updating its own state. If the external contract is malicious, it can "re-enter" the original contract and call the withdrawal function repeatedly before the original contract's state has been updated, thus draining the funds.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) public balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

## Contract Functions

### `deposit() public payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `public payable`: The function can be called by anyone and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Vulnerable to Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Here lies the vulnerability.** The contract makes an external call to send Ether to `msg.sender` using `send()`. Although `send()` only forwards 2300 gas units (which limits the complexity of the code the receiving contract can execute), it does not prevent a malicious contract from "re-entering" if the balance has not been updated *before* this call.
    3.  `balances[msg.sender] -= _amount;`: Finally, the sender's balance is reduced. However, if the malicious contract "re-entered" before this line, it will have already withdrawn additional funds.

## Why is this approach "Vulnerable"?

This contract is vulnerable to **reentrancy** attacks because it does not strictly follow the **Checks-Effects-Interactions** security pattern. The order of operations is:

1.  **Checks:** `require(balances[msg.sender] >= _amount, ...)`
2.  **Interactions:** `payable(msg.sender).send(_amount)`
3.  **Effects:** `balances[msg.sender] -= _amount;`

The problem is that the external interaction (`send()`) occurs *before* the contract state (`balances[msg.sender]`) is updated. This allows an attacking contract, upon receiving Ether from the `send()` call, to "re-enter" the `withdraw` function of the `VulnerableUncheckedSend` contract before the attacker's balance has been reduced to zero. The attacker can repeat this process multiple times, draining the contract's funds.

Although `send()` limits the gas forwarded, an attacker can still perform a reentrancy if the re-entry logic is simple enough to execute within that gas limit. The key to preventing reentrancy is always to update the contract state *before* making any external calls.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `withdraw` function of `VulnerableUncheckedSend`.

# VulnerableUncheckedSend Smart Contract (Reentrancy Vulnerability with transfer())

This Solidity contract, `VulnerableUncheckedSend`, is an example illustrating a **reentrancy vulnerability** in its `withdraw` function, despite using `transfer()` to send Ether. It demonstrates that, although `transfer()` is a safer Ether sending method than `call` in certain contexts, it does not completely prevent reentrancy attacks if the order of operations does not follow the recommended security pattern.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of following the Checks-Effects-Interactions pattern to protect funds in Web3.

## What is the Reentrancy Vulnerability?

Reentrancy occurs when a contract makes an external call to another contract (or a user address) before updating its own state. If the external contract is malicious, it can "re-enter" the original contract and call the withdrawal function repeatedly before the original contract's state has been updated, thus draining the funds.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) public balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

## Contract Functions

### `deposit() public payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `public payable`: The function can be called by anyone and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Vulnerable to Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  `payable(msg.sender).transfer(_amount);`: **Here lies the vulnerability.** The contract makes an external call to send Ether to `msg.sender` using `transfer()`. Although `transfer()` only forwards 2300 gas units (which limits the complexity of the code the receiving contract can execute), it does not prevent a malicious contract from "re-entering" if the balance has not been updated *before* this call.
    3.  `balances[msg.sender] -= _amount;`: Finally, the sender's balance is reduced. However, if the malicious contract "re-entered" before this line, it will have already withdrawn additional funds.

## Why is this approach "Vulnerable"?

This contract is vulnerable to **reentrancy** attacks because it does not strictly follow the **Checks-Effects-Interactions** security pattern. The order of operations is:

1.  **Checks:** `require(balances[msg.sender] >= _amount, ...)`
2.  **Interactions:** `payable(msg.sender).transfer(_amount)`
3.  **Effects:** `balances[msg.sender] -= _amount;`

The problem is that the external interaction (`transfer()`) occurs *before* the contract state (`balances[msg.sender]`) is updated. This allows an attacking contract, upon receiving Ether from the `transfer()` call, to "re-enter" the `withdraw` function of the `VulnerableUncheckedSend` contract before the attacker's balance has been reduced to zero. The attacker can repeat this process multiple times, draining the contract's funds.

Although `transfer()` limits the gas forwarded, an attacker can still perform a reentrancy if the re-entry logic is simple enough to execute within that gas limit. The key to preventing reentrancy is always to update the contract state *before* performing any external calls.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `withdraw` function of `VulnerableUncheckedSend`.
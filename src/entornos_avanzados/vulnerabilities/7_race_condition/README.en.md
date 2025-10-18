# NoVulnerableRaceCondition Smart Contract (Attempt to Prevent Race Condition - Still Vulnerable)

This Solidity contract, `NoVulnerableRaceCondition`, is an example that attempts to prevent a race condition using an `isTransfering` flag. However, despite this attempt, the contract **remains vulnerable to reentrancy attacks** due to the order of operations in the withdrawal function.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the complexity of securing contracts against race conditions and reentrancy.

## What is a Race Condition?

A race condition occurs when the outcome of an operation depends on the sequence or timing of uncontrollable events. On the blockchain, this often manifests as a reentrancy attack, where an attacker can execute malicious code before the contract's state is fully updated.

## Key Concepts Used

### `pragma solidity >=0.8.2 <0.9.0;`

Indicates the Solidity compiler version that should be used. `^0.8.2 <0.9.0` means the contract will compile with versions from 0.8.2 up to 0.8.x.

### `mapping(address => uint256) public balances;`

A `mapping` that associates an Ethereum address (`address`) with a balance (`uint256`). It is used to keep track of how much Ether each user has deposited into the contract.

### `mapping(address => bool) public isTransfering;`

A `mapping` that associates an address with a boolean value. The intention is to use it as a "lock" to indicate if an address is already in the middle of a transfer, attempting to prevent concurrent calls.

## Contract Functions

### `deposit() public payable`

*   **Purpose:** Allows users to deposit Ether into the contract.
*   **How it works:**
    1.  `public payable`: The function can be called by anyone and can receive Ether.
    2.  `balances[msg.sender] += msg.value;`: Adds the amount of Ether sent (`msg.value`) to the sender's (`msg.sender`) balance in the `balances` mapping.
    3.  `balance += msg.value;`: Updates a total contract balance.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Vulnerable to Reentrancy):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  `require(!isTransfering[msg.sender],"Error: Transfer in progress");`: **Attempt at prevention.** Checks if a transfer is already in progress for this address. If so, it reverts. However, this does not prevent reentrancy if the attacker "re-enters" within the same transaction.
    3.  `isTransfering[msg.sender] = true;`: Sets the flag to `true`. This should block concurrent calls, but not re-entries within the same transaction.
    4.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Here lies the vulnerability.** The contract makes an external call to send Ether to `msg.sender` *before* updating the sender's balance. If `msg.sender` is a malicious contract, it can execute arbitrary code at this point and "re-enter" the `withdraw` function.
    5.  `balances[msg.sender] -= _amount;`: Finally, the sender's balance is reduced. If the malicious contract "re-entered" before this line, it will have already withdrawn additional funds.
    6.  `isTransfering[msg.sender] = false;`: Resets the flag to `false`.

## Why is this approach "Still Vulnerable"?

This contract is vulnerable to **reentrancy** attacks because it does not strictly follow the **Checks-Effects-Interactions** security pattern. The order of operations is:

1.  **Checks:** `require(balances[msg.sender] >= _amount, ...)` and `require(!isTransfering[msg.sender], ...)`
2.  **Effects (Partial):** `isTransfering[msg.sender] = true;`
3.  **Interactions:** `payable(msg.sender).send(_amount)`
4.  **Effects (Complete):** `balances[msg.sender] -= _amount;` and `isTransfering[msg.sender] = false;`

The problem is that the external interaction (`send()`) occurs *before* the critical contract state (`balances[msg.sender]`) is updated. Although the `isTransfering` flag attempts to prevent concurrent calls, it does not stop a re-entry within the same transaction. An attacking contract can "re-enter" the `withdraw` function after receiving the Ether from `send()` and before `balances[msg.sender]` has been reduced and `isTransfering` has been reset to `false`. This allows it to withdraw funds multiple times.

The key to preventing reentrancy is always to update the contract state *before* making any external calls.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `withdraw` function of `NoVulnerableRaceCondition`.

# VulnerableRaceCondition Smart Contract (Race Condition Vulnerability)

This Solidity contract, `VulnerableRaceCondition`, is an example illustrating a **race condition vulnerability** in its `withdraw` function. Although it attempts to detect a race condition with a final check, the order of operations makes it susceptible to reentrancy attacks, where an attacker can manipulate the contract's state.

## What is a Smart Contract?

A smart contract is a program that runs on the blockchain. Once deployed, its code is immutable and executes autonomously. This particular contract serves as a warning about the importance of following the Checks-Effects-Interactions pattern to protect funds in Web3.

## What is a Race Condition?

A race condition occurs when the outcome of an operation depends on the sequence or timing of uncontrollable events. On the blockchain, this often manifests as a reentrancy attack, where an attacker can execute malicious code before the contract's state is fully updated.

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
    3.  `balance += msg.value;`: Updates a total contract balance.

### `withdraw(uint256 _amount) public`

*   **Purpose:** Allows a user to withdraw a specific amount of their deposited Ether from the contract.
*   **Parameters:**
    *   `_amount`: The amount of Ether (in Wei) that the user wishes to withdraw.
*   **How it works (Vulnerable to Race Condition):
    1.  `require(balances[msg.sender] >= _amount, "Error: There is not found to withdraw");`: Checks that the user has sufficient funds to withdraw the requested amount.
    2.  `uint256 lastBalance = balances[msg.sender];`: Saves the sender's current balance. **This is an attempt at verification, but it is performed at a vulnerable moment.**
    3.  `balances[msg.sender] -= _amount;`: Reduces the sender's balance. **This is the effect, but it occurs before the external interaction.**
    4.  `require(payable(msg.sender).send(_amount), "Error. Failed to send");`: **Here lies the vulnerability.** The contract makes an external call to send Ether to `msg.sender`. If `msg.sender` is a malicious contract, it can execute arbitrary code at this point and "re-enter" the `withdraw` function.
    5.  `require(balances[msg.sender] == lastBalance, "Error: Race condition detected");`: **This final check is ineffective.** If an attacker re-enters and withdraws more funds, `balances[msg.sender]` will be less than expected, but the attack will have already occurred. Furthermore, if the attacker re-enters and then returns the funds, this check could falsely pass as secure.

## Why is this approach "Vulnerable"?

This contract is vulnerable to **reentrancy** attacks (a form of race condition) because it does not strictly follow the **Checks-Effects-Interactions** security pattern. The order of operations is:

1.  **Checks:** `require(balances[msg.sender] >= _amount, ...)`
2.  **Effects (Partial):** `uint256 lastBalance = balances[msg.sender];` and `balances[msg.sender] -= _amount;`
3.  **Interactions:** `payable(msg.sender).send(_amount)`
4.  **Checks (Final):** `require(balances[msg.sender] == lastBalance, ...)`

The problem is that the external interaction (`send()`) occurs *after* the balance is reduced, but *before* the final check. An attacking contract can "re-enter" the `withdraw` function after receiving the Ether from `send()` and before the original transaction finishes. During this re-entry, the attacker can withdraw more funds. The final check `require(balances[msg.sender] == lastBalance, ...)` would only detect the inconsistency *after* the attack has already been completed, and it does not prevent it.

The key to preventing reentrancy is always to update the contract state *before* making any external calls.

## How to interact with this contract (to understand the vulnerability)?

1.  **Deploy the Contract:** Once deployed on an Ethereum network (or a testnet).
2.  **Deposit Ether:** Call the `deposit()` function and send Ether along with the transaction.
3.  **Simulate Attack:** To see the vulnerability in action, you would need to deploy a second contract (an attacking contract) that is designed to perform the reentrancy attack by repeatedly calling the `withdraw` function of `VulnerableRaceCondition`.
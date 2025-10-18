// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// This line imports the ERC20 contract from the Solmate library.
// Solmate is a highly optimized and gas-efficient Solidity library.
// Importing allows your contract to inherit functionalities from other contracts.
// This is a common practice in Solidity to reuse well-tested and secure code,
// rather than writing everything from scratch.

contract Token is ERC20("CoinTest", "CTK") {
    // This declares a new smart contract named 'Token'.
    // 'is ERC20("CoinTest", "CTK")' means that 'Token' contract inherits from the 'ERC20' contract.
    // When inheriting, the constructor of the base contract (ERC20 in this case) is called.
    // Here, it's calling the ERC20 constructor with:
    // - "CoinTest": The name of the token.
    // - "CTK": The symbol of the token.
    // The number of decimals is 18 by default in the OpenZeppelin ERC20 contract.
    // By inheriting from ERC20, the 'Token' contract automatically gets all the standard ERC-20 functionalities
    // like `totalSupply`, `balanceOf`, `transfer`, `approve`, `transferFrom`, and their corresponding events.
    // This makes it very easy to create a new ERC-20 compliant token.
}
// This declares a new smart contract named 'Token'.
// 'is ERC20("CoinTest", "CTK", 18)' means that 'Token' contract inherits from the 'ERC20' contract.
// When inheriting, the constructor of the base contract (ERC20 in this case) is called.
// Here, it's calling the ERC20 constructor with:
// - "CoinTest": The name of the token.
// - "CTK": The symbol of the token.
// - 18: The number of decimal places for the token.
// By inheriting from ERC20, the 'Token' contract automatically gets all the standard ERC-20 functionalities
// like `totalSupply`, `balanceOf`, `transfer`, `approve`, `transferFrom`, and their corresponding events.
// This makes it very easy to create a new ERC-20 compliant token.

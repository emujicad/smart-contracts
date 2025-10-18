// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

contract Counter {
    // This declares a new smart contract named 'Counter'.
    // This contract is a very simple example, often used to introduce basic Solidity concepts.

    uint256 public number;
    // This declares a state variable named 'number' of type 'uint256'.
    // 'uint256' is an unsigned integer (non-negative) that can store very large numbers.
    // 'public' means this variable can be read by anyone from outside the contract.
    // State variables are stored permanently on the blockchain.

    function setNumber(uint256 newNumber) public {
        // This declares a function named 'setNumber'.
        // It takes one argument, 'newNumber', which is also a 'uint256'.
        // 'public' means this function can be called from anywhere (by users or other contracts).
        // This function allows you to set the value of the 'number' variable.
        number = newNumber;
    }

    function increment() public {
        // This declares a function named 'increment'.
        // 'public' means this function can be called from anywhere.
        // This function increases the value of the 'number' variable by 1.
        // When this function is called, it changes the state of the blockchain,
        // so it will cost gas (transaction fees).
        number++;
    }

    function decrement() public {
        // This declares a function named 'decrement'.
        // 'public' means this function can be called from anywhere.
        // This function decreases the value of the 'number' variable by 1.
        // Similar to 'increment', calling this function changes the state and costs gas.
        number--;
    }
}

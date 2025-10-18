// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.13;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.13 up to (but not including) 0.9.0.

contract helloworld {
    // This declares a new smart contract named 'helloworld'.
    // This is the classic "Hello, World!" program adapted for the blockchain.
    // It's a great starting point for beginners to understand basic contract structure,
    // state variables, and functions.

    string private message;
    // This declares a state variable named 'message' of type 'string'.
    // 'string' is used to store text data.
    // 'private' means this variable can only be accessed from within this contract.
    // State variables are stored permanently on the blockchain.

    constructor() {
        // The constructor is a special function that runs only once when the contract is deployed to the blockchain.
        // It's used to initialize the contract's state variables.
        message = "Hello, World from foundry!";
        // When the contract is deployed, the 'message' variable will be set to this initial string.
    }

    function getMessage() public view returns (string memory) {
        // This declares a function named 'getMessage'.
        // 'public' means this function can be called from anywhere (by users or other contracts).
        // 'view' means this function does not modify the state of the blockchain (it only reads data).
        // 'returns (string memory)' specifies that this function will return a string.
        // 'memory' is a data location for variables that are temporary and only exist during the function call.
        return message;
        // This line returns the current value of the 'message' state variable.
    }

    function updateMessage(string memory _newMessage) public {
        // This declares a function named 'updateMessage'.
        // 'public' means this function can be called from anywhere.
        // It takes one argument, '_newMessage', which is a string.
        // This function allows you to change the value of the 'message' state variable.
        // Since it modifies the state, calling this function will cost gas (transaction fees).
        message = _newMessage;
        // This line updates the 'message' variable with the new string provided as an argument.
    }
}

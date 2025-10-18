// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Imports the ICounter interface from another file.
// This allows the CallInterface contract to know about the functions defined in ICounter.
import "./interfaces/interface.sol";

// This contract demonstrates how to call functions on another contract using an interface.
contract CallInterface {
    // A public state variable to store the count obtained from the Counter contract.
    uint public count;

    // This function takes the address of a Counter contract and interacts with it.
    // `_counter` is the address of the contract that implements the ICounter interface.
    function examples(address _counter) external {
        // Creates an instance of the ICounter interface at the given address.
        // This allows us to call the functions defined in the ICounter interface on the contract at `_counter` address.
        ICounter counter = ICounter(_counter);

        // Calls the `inc()` function on the Counter contract.
        counter.inc();

        // Calls the `count()` function on the Counter contract and stores the result in the `count` state variable.
        count = counter.count();
    }
}

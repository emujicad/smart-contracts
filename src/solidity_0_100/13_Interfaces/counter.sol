// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// This contract implements a simple counter.
contract Counter {
    // A public state variable to store the count.
    // `public` automatically creates a getter function to read its value from outside the contract.
    uint public count;

    // Increments the count by 1.
    // `external` means this function can be called from other contracts and transactions.
    function inc() external {
        count += 1;
    }

    // Decrements the count by 1.
    // `external` means this function can be called from other contracts and transactions.
    function dec() external {
        count -= 1;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Defines an interface for a counter contract.
// Interfaces specify the functions a contract must implement, without providing the implementation.
// This allows contracts to interact with each other without needing to know the other's full code, just its interface.
interface IhaciaCallContract  {
    // Declares a function to get the current count.
    // `external` means it can be called from other contracts and transactions.
    // `view` means it does not modify the state of the contract.
    // `returns (uint)` specifies that it will return an unsigned integer.
    function count_local() external view returns (uint);

    // Declares a function to increment the count.
    // `external` means it can be called from other contracts and transactions.
    function callContract () external;
}

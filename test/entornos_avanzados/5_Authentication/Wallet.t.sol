// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library.
// 'forge-std' is a standard library for Foundry, providing essential utilities for writing tests in Solidity.

import "../../../src/entornos_avanzados/5_Authentication/Wallet.sol";
// This line imports the 'Wallet.sol' contract from the 'src' directory.
// This is the contract that we are going to test, which implements a simple Ether wallet.

contract WalletTest is Test {
    // This declares a new smart contract named 'WalletTest'.
    // 'is Test' means that 'WalletTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    Wallet public wallet;
    // This declares a state variable 'wallet' of type 'Wallet'.
    // This variable will hold an instance of the 'Wallet' contract, allowing us to interact with it in our tests.

    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        wallet = new Wallet();
        // This line deploys a new instance of the 'Wallet' contract and assigns its address to 'wallet'.
        // Each test will get its own fresh instance of the contract.
    }

    function test_changeOwner() public {
        // This test function verifies that the `changeOwner()` function correctly updates the contract's owner.

        address newOwner = address(0x00000123);
        // Defines a new address to become the owner.

        console.log("Before become msg.sender address:", msg.sender);
        // Logs the current `msg.sender` (which is the test contract itself).
        console.log("Before become - Current wallet.owner address:", wallet.owner());
        // Logs the current owner of the `wallet` contract.

        wallet.changeOwner(newOwner);
        // Calls the `changeOwner()` function on the `wallet` contract, passing the `newOwner` address.
        // Since the `setUp()` function deploys the `Wallet` contract, the `msg.sender` for this call
        // is the `WalletTest` contract itself, which is the initial owner.

        console.log("After become msg.sender address:", msg.sender);
        // Logs `msg.sender` again (still the test contract).
        console.log("After become - Current wallet.owner address:", wallet.owner());
        // Logs the updated owner of the `wallet` contract.

        assertEq(wallet.owner(), newOwner, "Owner should be updated");
        // `assertEq()` is an assertion function from `forge-std/Test.sol`.
        // It checks if two values are equal. Here, we assert that the `owner` variable in the `wallet` contract
        // has been successfully updated to `newOwner`.
    }

    function test_failNotOwner() public {
        // This test function verifies that `changeOwner()` reverts when called by an address that is not the owner.

        //console.log("Before prank - Current msg.sender address:", msg.sender); // Logs for debugging
        //console.log("Before prank - Current wallet.owner address:", wallet.owner()); // Logs for debugging

        vm.prank(address(0x00000124));
        // `vm.prank()` is a Foundry cheat code that sets the `msg.sender` for the *next* transaction.
        // Here, we simulate a call from `address(0x00000124)`, which is not the owner.

        //console.log("After prank - Current msg.sender address:", msg.sender); // Logs for debugging
        //console.log("After prank - Current wallet.owner address:", wallet.owner()); // Logs for debugging

        vm.expectRevert("Error: Only owner can change owner");
        // `vm.expectRevert()` tells Foundry to expect the next function call to revert
        // with the specific error message "Error: Only owner can change owner".

        wallet.changeOwner(address(0x00000124));
        // Calls the `changeOwner()` function. Since `msg.sender` is now `address(0x00000124)` (not the owner),
        // the `require` statement in `changeOwner()` should trigger a revert, and this test should pass.

        //console.log("After become msg.sender address:", msg.sender); // Logs for debugging
        //console.log("After become - Current wallet.owner address:", wallet.owner()); // Logs for debugging
    }

    // The commented out test below is an example of a test that would fail if uncommented,
    // as `changeOwner` can only be called once by the original owner to set a new owner.
    // Subsequent calls by the *original* owner would fail if the owner has already been changed.
    // If the intention was to test that the *new* owner can change it again, the `vm.prank` would need to be set to the new owner.
    //function test_FailSetOwnerAgain() public {
    //    address newOwner = address(0x00000123);
    //    wallet.changeOwner(newOwner);
    //}
}

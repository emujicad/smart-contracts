// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library.
// 'forge-std' is a standard library for Foundry, providing essential utilities for writing tests in Solidity.
// The 'Test' contract provides functions like `vm.warp`, `vm.expectRevert`, `assertEq`, etc., which are crucial for testing.

import "../../../src/entornos_avanzados/8_TestTime/Auction.sol";
// This line imports the 'CAuction.sol' contract from the 'src' directory.
// This is the contract that we are going to test.

contract AuctionTest is Test {
    // This declares a new smart contract named 'AuctionTest'.
    // 'is Test' means that 'AuctionTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    CAuction public cAuction; // Declare the Auction contract instance
    // This declares a state variable 'cAuction' of type 'CAuction'.
    // This variable will hold an instance of the 'CAuction' contract, allowing us to interact with it in our tests.

    uint256 private start;
    uint256 private end;
    // These private variables will store the calculated start and end times for the auction
    // within the test environment, allowing for precise control over time-based tests.

    // Setting up the Auction contract before each test
    // This function is called before each test function
    // It initializes the CAuction contract instance
    // and sets the start and end times for the auction
    // The auction starts in 1 day and lasts for 3 days
    // The start time is set to the current block timestamp plus 1 day
    // The end time is set to the start time plus 3 days
    // This ensures that the auction is ready for testing
    // The start and end times are used to verify the auction's state
    // during the tests, ensuring that the auction logic is functioning correctly.
    // The startAuction variable is set to the current block timestamp plus 1 day
    // The endAuction variable is set to the startAuction plus 2 days
    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        cAuction = new CAuction(); // Initialize the Auction contract
        // This line deploys a new instance of the 'CAuction' contract and assigns its address to 'cAuction'.
        // Each test will get its own fresh instance of the contract.

        start = block.timestamp + 1 days; // Auction starts now
        // Sets a 'start' timestamp for testing purposes, 1 day from the current block.
        end = block.timestamp + 2 days; // Auction lasts for 2 days
            // Sets an 'end' timestamp for testing purposes, 2 days from the current block.
            // Note: The `CAuction` contract itself calculates `startAuction` and `endAuction` based on its deployment time.
            // These `start` and `end` variables in the test are for controlling the test environment's time.
    }

    function testOfferBeforeAuctionStarts() public {
        // This test function checks if the 'offer' function reverts when called before the auction starts.

        //vm.warp(cAuction.startAuction() - 1); // Warp to before the auction starts
        // `vm.warp()` is a cheat code from Foundry that allows you to manipulate the blockchain's timestamp.
        // This line (if uncommented) would set the block.timestamp to 1 second before the auction's actual start time.

        vm.expectRevert("You cannot offer now");
        // `vm.expectRevert()` is a cheat code that tells Foundry to expect the next function call to revert
        // with a specific error message. If it doesn't revert, or reverts with a different message, the test fails.

        cAuction.offer();
        // This calls the 'offer' function on our deployed 'cAuction' contract.
        // We expect this call to revert because the time is before the auction starts.
    }

    function testOffer() public {
        // This test function checks if the 'offer' function executes successfully during the auction.

        vm.warp(start + 1 days);
        // We use `vm.warp()` to advance the blockchain's timestamp to 1 day after our calculated 'start' time,
        // placing us within the active auction period.

        cAuction.offer();
        // We call the 'offer' function. Since we are within the valid time, we expect it NOT to revert.
        // If this call reverts, the test will fail.
        // No revert expected, so the test passes if no revert occurs
    }

    function testOfferfailAfterAuctionEnds() public {
        // This test function checks if the 'offer' function reverts when called after the auction ends.

        vm.warp(start + 3 days);
        // We use `vm.warp()` to advance the blockchain's timestamp to 3 days after our calculated 'start' time,
        // placing us after the auction has ended.

        vm.expectRevert("You cannot offer now");
        // We expect the 'offer' function to revert with the "You cannot offer now" message.

        cAuction.offer();
        // We call the 'offer' function, expecting it to fail.
    }

    function testTimestamp() public {
        // This test demonstrates how to manipulate and verify `block.timestamp` using Foundry's cheat codes.

        uint256 t = block.timestamp;
        // Stores the current block's timestamp.

        skip(100);
        // `skip()` is a cheat code that advances the block.timestamp by the specified number of seconds.
        // Here, it advances the time by 100 seconds.

        assertEq(t + 100, block.timestamp);
        // `assertEq()` is an assertion function from `forge-std/Test.sol`.
        // It checks if two values are equal. Here, we assert that the new `block.timestamp` is
        // the original timestamp plus 100 seconds.

        rewind(10);
        // `rewind()` is a cheat code that rewinds the block.timestamp by the specified number of seconds.
        // Here, it rewinds the time by 10 seconds.

        assertEq(t + 90, block.timestamp);
        // We assert that the `block.timestamp` is now the original timestamp plus 90 seconds (100 - 10).
    }

    function testBlockNumber() public {
        // This test demonstrates how to manipulate and verify `block.number` using Foundry's cheat codes.

        uint256 b = block.number;
        // Stores the current block's number.

        vm.roll(255);
        // `vm.roll()` is a cheat code that sets the block.number to a specific value.
        // Here, it sets the block number to 255.

        assertEq(block.number, 255);
        // We assert that the current `block.number` is indeed 255.

        vm.roll(b);
        // We use `vm.roll()` again to set the block number back to its original value.

        assertEq(b, block.number);
        // We assert that the `block.number` has been successfully rolled back to its original value.
    }
}

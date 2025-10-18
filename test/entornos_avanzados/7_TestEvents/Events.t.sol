// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;
// This line declares the Solidity compiler version. The contract will compile with versions from 0.8.24 up to (but not including) 0.9.0.

import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library.
// 'forge-std' is a standard library for Foundry, providing essential utilities for writing tests in Solidity.

import "../../../src/entornos_avanzados/7_TestEvents/Events.sol";
// This line imports the 'CEvents.sol' contract from the 'src' directory.
// This is the contract that we are going to test, which demonstrates event emission.

contract EventsTest is Test {
    // This declares a new smart contract named 'EventsTest'.
    // 'is Test' means that 'EventsTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    CEvents public cevents;
    // This declares a state variable 'cevents' of type 'CEvents'.
    // This variable will hold an instance of the 'CEvents' contract, allowing us to interact with it in our tests.

    event Transfer(address indexed from, address indexed to, uint256 amount);
    // This re-declares the 'Transfer' event within the test contract.
    // This is necessary for `vm.expectEmit` to correctly identify and match the event being emitted by the tested contract.
    // The parameters and their 'indexed' status must match the event declaration in `CEvents.sol`.

    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        cevents = new CEvents();
        // This line deploys a new instance of the 'CEvents' contract and assigns its address to 'cevents'.
        // Each test will get its own fresh instance of the contract.
    }

    function testEmitTransferOnce() public {
        // This test function verifies that the `transferOnce` function correctly emits a `Transfer` event.

        address from = address(this);
        // Sets the 'from' address to the address of the current test contract.
        address to = address(0x456);
        // Sets a dummy 'to' address.
        uint256 amount = 200;
        // Sets a dummy amount.

        // Expect the Transfer event to be emitted
        vm.expectEmit(true, true, false, true);
        // `vm.expectEmit()` is a powerful cheat code from Foundry used to assert that a specific event is emitted.
        // The parameters are:
        // 1. `bool checkTopic1`: Whether to check the first indexed parameter (topic1). (true for `from`)
        // 2. `bool checkTopic2`: Whether to check the second indexed parameter (topic2). (true for `to`)
        // 3. `bool checkTopic3`: Whether to check the third indexed parameter (topic3). (false as `amount` is not indexed)
        // 4. `bool checkData`: Whether to check the non-indexed data. (true for `amount`)

        emit Transfer(from, to, amount);
        // This line "pre-emits" the expected event. Foundry captures this and compares it with the actual event
        // emitted by the contract call that follows.

        // Call the transferOnce function that should emit the event
        cevents.transferOnce(from, to, amount);
        // This calls the `transferOnce` function on our deployed `cevents` contract.
        // This call is expected to emit the `Transfer` event that we just set up `vm.expectEmit` for.

        // Verify that the event was emitted correctly
        vm.expectEmit(true, false, false, false);
        // Another `vm.expectEmit` call. This one only checks the first indexed topic (`from`).
        // This demonstrates flexibility in what parts of the event you want to assert.
        emit Transfer(from, to, 400);
        // Pre-emit the expected event for the second call.

        // Call the transferOnce function that should emit the event
        cevents.transferOnce(from, to, 400);
        // Call `transferOnce` again with a different amount.
    }

    function testEmitTransferMany() public {
        // This test function verifies that the `transferMany` function correctly emits multiple `Transfer` events.

        address from = address(this);
        // Sets the 'from' address to the address of the current test contract.
        address[] memory to = new address[](2);
        to[0] = address(0x123);
        to[1] = address(0x456);
        // Creates an array of dummy recipient addresses.
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 150;
        amounts[1] = 250;
        // Creates an array of dummy amounts.

        // Expect the Transfer event to be emitted for each recipient
        for (uint256 i = 0; i < to.length; i++) {
            // We loop through the expected events. For each expected event, we set up `vm.expectEmit`.
            vm.expectEmit(true, true, false, true);
            // Expects the event to check topic1, topic2, and data.
            emit Transfer(from, to[i], amounts[i]);
            // Pre-emits the specific event expected for this iteration.
        }

        // Call the transferMany function that should emit the events
        cevents.transferMany(from, to, amounts);
        // This calls the `transferMany` function. Since it emits multiple events in a loop,
        // Foundry will check each emitted event against the `vm.expectEmit` calls in the order they were set up.
    }
}

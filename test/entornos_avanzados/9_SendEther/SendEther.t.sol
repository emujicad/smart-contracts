// SPDX-License-Identifier: UNLICENSED
// This line specifies the license for the smart contract. UNLICENSED means it's not under any specific license.
pragma solidity ^0.8.24;

// Import Foundry's Test utilities for unit testing
import "forge-std/Test.sol";
// This line imports the 'Test.sol' contract from the 'forge-std' library,
// providing essential utilities for writing tests in Solidity, including cheat codes.

// Import the contract to be tested
import "../../../src/entornos_avanzados/9_SendEther/SendEther.sol";
// This line imports the 'SendEther.sol' contract from the 'src' directory.
// This is the contract that we are going to test, which handles Ether transactions.

// Test contract for SendEther
contract SendEtherTest is Test {
    // This declares a new smart contract named 'SendEtherTest'.
    // 'is Test' means that 'SendEtherTest' inherits from the 'Test' contract,
    // gaining access to all its testing utilities.

    // Instance of the SendEther contract9_SendEther9:
    SendEther public sendEther; // Declare the SendEther contract instance
    // This declares a state variable 'sendEther' of type 'SendEther'.
    // This variable will hold an instance of the 'SendEther' contract, allowing us to interact with it in our tests.

    // This function runs before each test. It deploys a new SendEther contract.
    function setUp() public {
        // The `setUp()` function is a special function in Foundry tests.
        // It is executed before *each* test function (any function starting with `test`).
        // This is useful for setting up a fresh state for every test, ensuring tests are independent.

        //sendEther = new SendEther{value: 5 ether}(); // This line is commented out, but shows how to send Ether during deployment.
        sendEther = new SendEther();
        // This line deploys a new instance of the 'SendEther' contract.
        // Each test will get its own fresh instance of the contract.
    }

    // Helper function to send Ether to the SendEther contract
    // Only used internally by this test contract
    function _send(uint256 _amount) private {
        // This is a private helper function used within the test contract to send Ether.
        // 'private' means it can only be called from within this contract.

        require(_amount > 0, "Amount must be greater than zero");
        // Ensures that the amount to send is positive.

        require(address(this).balance >= _amount, "Insufficient balance in test contract");
        // Ensures that the test contract itself has enough Ether to send.

        // Send ether to the SendEther contract using low-level call
        (bool success,) = address(sendEther).call{value: _amount}("");
        // This line uses a low-level `call` to send Ether to the `sendEther` contract.
        // `call` is a more flexible and recommended way to send Ether to contracts compared to `transfer()` or `send()`,
        // especially when interacting with contracts that might have complex `receive()` or `fallback()` functions.
        // `value: _amount` specifies the amount of Ether to send.
        // `""` means no function data is sent, so it will trigger the `receive()` or `fallback()` function.
        // It returns a `bool success` indicating if the call was successful and `bytes memory data` (which we ignore here).

        require(success, "Failed to send Ether");
        // Asserts that the Ether transfer was successful.
    }

    // Test function to print the balances of this contract and the SendEther contract
    // Uses Foundry's console.log for debugging
    function testEtherBalance() public view {
        // This function demonstrates how to use `console.log` to inspect Ether balances during tests.
        // 'public view' means it can be called from anywhere and does not modify the blockchain state.

        console.log("Current this.balance:", address(this).balance / 1e18, "ETH");
        // Logs the Ether balance of the current test contract. `1e18` converts Wei to Ether.

        console.log("Current sendEther.balance:", address(sendEther).balance / 1e18, "ETH");
        // Logs the Ether balance of the `sendEther` contract.
    }

    // Test sending Ether from this contract to the SendEther contract
    function testSendEther() public {
        // This test verifies that Ether can be successfully sent from the test contract to the `SendEther` contract.

        uint256 initialBalance = address(this).balance;
        // Stores the initial Ether balance of the test contract.

        console.log("Before sendEther.owner address:", sendEther.owner());
        console.log("Before this.balance:", address(this).balance / 1e18, "ETH");
        console.log("Before sendEther.balance:", address(sendEther).balance / 1e18, "ETH");
        // Logs balances before the transfer for debugging.

        uint256 amount = 1 ether;
        // Defines the amount of Ether to send (1 Ether, which is 10^18 Wei).

        _send(amount);
        // Calls our helper function to send Ether to the `sendEther` contract.

        console.log("After sendEther.owner address:", sendEther.owner());
        console.log("After this.balance:", address(this).balance / 1e18, "ETH");
        console.log("After sendEther.balance:", address(sendEther).balance / 1e18, "ETH");
        // Logs balances after the transfer for debugging.

        // Assert that the SendEther contract received the correct amount
        assertEq(address(sendEther).balance, amount, "SendEther contract should have the sent amount");
        // Asserts that the `sendEther` contract's balance is now equal to the amount sent.

        // Assert that this contract's balance decreased by the sent amount
        assertEq(address(this).balance, initialBalance - amount, "Test contract should have reduced balance");
    }

    // Test sending Ether from a different address to the SendEther contract
    function testSendEther2() public {
        // This test demonstrates sending Ether from simulated external accounts using Foundry's cheat codes.

        uint256 initialBalance = address(sendEther).balance;
        // Stores the initial balance of the `SendEther` contract before these specific transfers.

        // Give address(1) 10 ether for testing
        deal(address(1), 10 ether);
        // `deal()` is a Foundry cheat code that sets the Ether balance of a specific address.
        // Here, it gives `address(1)` (a dummy address) 10 Ether.

        assertEq(address(1).balance, 10 ether, "Address 1 should have 10 ether");
        // Asserts that `address(1)` now has 10 Ether.

        // Give address(1) 145 ether for next test
        deal(address(1), 145 ether);
        // `deal()` can also be used to add more Ether to an existing balance. `address(1)` now has 155 Ether.

        vm.prank(address(1));
        // `vm.prank()` is a Foundry cheat code that sets the `msg.sender` for the *next* transaction.
        // This simulates `address(1)` calling the next function.

        _send(145);
        // Calls our helper function to send 145 Ether. Since `vm.prank(address(1))` was used,
        // this Ether will be sent from `address(1)`.

        // Simulate a transaction from address(1) with 345 ether
        hoax(address(1), 345 ether);
        // `hoax()` is another Foundry cheat code that combines `deal()` and `prank()`.
        // It sets the balance of `address(1)` to 345 Ether and then sets `msg.sender` to `address(1)` for the next call.
        // Note: The comment `Simulate a transaction from address(1) with 145 ether` is incorrect, it's 345 ether.

        _send(345);
        // Calls our helper function to send 345 Ether from `address(1)`.

        // Assert that the SendEther contract's balance increased correctly
        assertEq(address(sendEther).balance, initialBalance + 145 + 345, "SendEther contract should have 490 ether");
        // Asserts that the `sendEther` contract's balance has increased by the total amount sent from `address(1)`.
    }
}

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24; // Specifies the required compiler version.

import {Test} from "forge-std/Test.sol"; // Imports Foundry's testing utilities.
import {console} from "forge-std/console.sol"; // Imports logging utilities for debugging.

// An interface is a collection of function definitions without implementation.
// It allows our contract to interact with other contracts without having their full code.
interface IWETH {
    // This function returns the WETH balance of a given address.
    function balanceOf(address) external view returns (uint256);
    // This function converts ETH to WETH. 'payable' means it can receive Ether.
    function deposit() external payable;
}

// This is our test contract, which inherits from Foundry's 'Test' contract.
contract ForkTest is Test {
    // This creates a variable 'weth' that we can use to call the functions defined in the IWETH interface.
    IWETH public weth;

    // The setUp function is a special function that runs before each test case.
    // It's useful for initializing state or setting up conditions for your tests.
    function setUp() public {
        // We are pointing our 'weth' variable to the official WETH contract on the Ethereum mainnet.
        // This is the actual, live contract address.
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    // This is a test function, identified by the 'test' prefix in its name.
    // It will be automatically run by Foundry.
    function testDeposit() public {
        // We get the initial WETH balance of this contract before doing anything.
        uint256 initialBalance = weth.balanceOf(address(this));
        // console.log is a helpful tool for debugging. It prints information to the console during the test.
        console.log("Initial Balance", initialBalance, "Address:", address(this));

        // Here, we call the 'deposit' function of the WETH contract.
        // We send 500 wei (the smallest unit of Ether) along with the call to be wrapped into WETH.
        weth.deposit{value: 500}();

        // After the deposit, we check the balance again to see if it has changed.
        uint256 finalBalance = weth.balanceOf(address(this));
        console.log("Final Balance", finalBalance, "Address:", address(this));
    }
}

// API_ALCHEMY: https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P // API URL for mainnet fork
// forge test --fork-url https://eth-mainnet.g.alchemy.com/v2/rWQAOZwUSF6-eBK-YPy3P --match-path test/10_ExecuteMainnet/Fork.t.sol -vvv // Command to run the test

// SPDX-License-Identifier: UNLICENSED
// Specifies the version of the Solidity compiler to be used.
pragma solidity ^0.8.24;

// Imports Foundry's testing utilities, which provide a set of tools for writing tests.
import {Test} from "forge-std/Test.sol";
// Imports Foundry's console logging utilities, which are useful for debugging during tests.
import {console} from "forge-std/console.sol";

// Imports the IERC20 interface, which defines the standard functions for an ERC20 token.
// This allows the contract to interact with any ERC20-compliant token.
import "../../interfaces/IERC20.sol";

// This is the test contract, which inherits from Foundry's 'Test' contract.
// Inheriting from 'Test' gives access to Foundry's testing functionalities.
contract ForkDaiTest is Test {
    // This declares a public variable 'dai' of type IERC20.
    // This variable will be used to interact with the DAI token contract.
    IERC20 public dai;

    // The setUp function is a special function that runs before each test case.
    // It is used to initialize the state or set up the conditions for the tests.
    function setUp() public {
        // This line initializes the 'dai' variable with the address of the official DAI contract on the Ethereum mainnet.
        // This is the actual, live contract address for DAI.
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    // This is a test function, identified by the 'test' prefix in its name.
    // Foundry automatically runs any function with this prefix as a test.
    function testDeposit() public {
        // An example address is created for testing purposes.
        address account = address(123);

        // The initial DAI balance of the 'account' is retrieved.
        uint256 initialBalance = dai.balanceOf(account);
        // The initial balance is logged to the console for debugging.
        console.log("Address Account:", account, "| Initial Balance = ", initialBalance / 1e18);

        // The initial total supply of DAI is retrieved.
        uint256 initialTotal = dai.totalSupply();
        // The initial total supply is logged to the console for debugging.
        console.log("Address Contract:", address(dai), "| Initial Total Supply DAI = ", initialTotal / 1e18);

        // Foundry's 'deal' cheatcode is used to simulate the 'account' receiving 1 million DAI tokens.
        // This is a powerful feature for testing, as it allows you to set up any scenario without needing real funds.
        deal(address(dai), account, 1e6 * 1e18); // Fund the account with 1 million DAI for testing

        // The final DAI balance of the 'account' is retrieved after the 'deal' operation.
        uint256 finalBalance = dai.balanceOf(account);
        // The final balance is logged to the console for debugging.
        console.log("Address Account:", account, "| Final Balance = ", finalBalance / 1e18);

        // The final total supply of DAI is retrieved.
        uint256 finalTotal = dai.totalSupply();
        // The final total supply is logged to the console for debugging.
        console.log("Address Contract:", address(dai), "| Final Total Supply DAI = ", finalTotal / 1e18);

        // It is asserted that the final balance is greater than the initial balance, which confirms that the 'deal' was successful.
        assert(finalBalance > initialBalance);
        // It is asserted that the total supply remains unchanged, as the 'deal' cheatcode only affects the balance of the specified account.
        assert(finalTotal == initialTotal);
    }
}

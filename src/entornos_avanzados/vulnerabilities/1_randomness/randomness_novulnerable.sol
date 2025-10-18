// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

// Interface to communicate with an external randomness oracle
// Oracles are external services that provide data to smart contracts
interface RandomnessOracle {
    // Function signature that the oracle contract must implement
    function getRandomNumber() external returns (uint);
}
/**
 * @title RandomnessNoVulnerable
 * @notice This contract demonstrates a SECURE way to generate random numbers using an oracle
 * @dev Uses an external oracle service to get truly random numbers
 */

 contract RandomnessNoVulnerable {

    // Address of the oracle contract that provides random numbers
    // Private means only this contract can access this variable
    address private oracle;
    // Public variable to store the random number (anyone can read it)
    uint public randomNumber;

    constructor(address _oracleAddress) {
        // Set the oracle address when the contract is deployed
        // This connects our contract to the external randomness service
        oracle= _oracleAddress;
    }

    // Function to get a truly random number from the oracle
    function generateRandomNumber() public {
        // Safety check: make sure oracle address is set
        // address(0) is like a null address - means nothing is set
        require(oracle != address(0), "Oracle address is not set");
        // Call the oracle contract to get a random number
        // This is secure because the oracle uses proper randomness sources
        randomNumber = RandomnessOracle(oracle).getRandomNumber();
    }

}
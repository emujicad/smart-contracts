// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../ERC20.sol";

/**
 * @title Main
 * @notice Token sale and management contract
 * @dev This contract manages the sale of ERC-20 tokens and allows token generation
 * @dev It acts as a "token store" where users can buy tokens with Ether
 */
contract Main {

    // Instance of the ERC-20 token contract we're managing
    ERC20 private _token;
    // Address of the contract owner (who deployed this contract)
    address private owner;
    // Address of this contract itself
    address private contractAddress;
    
    /**
     * @dev Constructor creates a new token and sets up the contract
     * @notice Creates a token called "TEST Coin" with symbol "TCI"
     */
    constructor() {
        // Create a new ERC-20 token called "TEST Coin" with symbol "TCI"
        _token = new ERC20("TEST Coin", "TCI");
        // Set the deployer as the owner
        owner = msg.sender;
        // Store this contract's address for reference
        contractAddress = address(this);
    }

    /**
     * @dev Calculate the price in Wei (smallest ETH unit) for a number of tokens
     * @param _numTokens Number of tokens to price
     * @return The cost in Wei (1 token = 1 ETH in this example)
     */
    function priceTokens(uint256 _numTokens) public pure returns (uint256) {
        // Simple pricing: 1 token costs 1 ETH
        // In real projects, you might have more complex pricing logic
        return _numTokens * 1 ether;
    }

    /**
     * @dev Buy tokens by sending ETH to this function
     * @param _client Address that will receive the tokens
     * @param _amount Number of tokens to purchase
     * @notice You need to send enough ETH to cover the token price
     */
    function buyTokens(address _client, uint256 _amount) public payable {
        // Calculate how much ETH is needed for this purchase
        uint256 price = priceTokens(_amount);
        // Check that enough ETH was sent
        require(msg.value >= price, "buy more tokens");
        // Calculate any excess ETH to return to buyer
        uint256 returnValue = msg.value - price;
        // Return excess ETH to buyer
        payable(msg.sender).transfer(returnValue);

        // Transfer the purchased tokens to the client
        _token.transfer(_client, _amount);
    }

    /**
     * @dev Generate (mint) new tokens to increase the available supply
     * @param _amount Number of new tokens to create
     * @notice New tokens are minted to this contract's address
     */
    function generateTokens(uint256 _amount) public {
        // Mint new tokens to this contract so they can be sold
        _token.increaseTotalSupply(contractAddress, _amount);
    }

    /**
     * @dev Get the address of this smart contract
     * @return The contract's address
     */
    function getContractAddress() public view returns (address) {
        return contractAddress;
    }

    /**
     * @dev Get the token balance of any account
     * @param _account Address to check the balance for
     * @return Number of tokens owned by the account
     */
    function balanceAccount(address _account) public view returns (uint256) {
        return _token.balanceOf(_account);
    }

    /**
     * @dev Get the total supply of tokens in circulation
     * @return Total number of tokens that exist
     */
    function getTotalSupply() public view returns (uint256) {
        return _token.totalSupply();
    }
}

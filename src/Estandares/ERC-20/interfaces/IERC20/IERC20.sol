// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title IERC20
 * @notice Interface for the ERC-20 fungible token standard
 * @dev This interface defines the functions that all ERC-20 tokens must implement
 * @dev Interfaces are like contracts but only declare function signatures, no implementation
 * @dev Think of this as a "contract template" that ensures all ERC-20 tokens work the same way
 * @dev ERC-20 tokens are fungible, meaning each token is identical and interchangeable
 */
interface IERC20 {
    // EVENTS - These are emitted when certain actions happen
    
    /**
     * @dev Emitted when tokens are transferred from one address to another
     * @param _from Address sending the tokens (indexed for efficient searching)
     * @param _to Address receiving the tokens (indexed for efficient searching) 
     * @param _value Amount of tokens transferred
     */
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    
    /**
     * @dev Emitted when an approval is made (permission to spend tokens)
     * @param _owner Address that owns the tokens
     * @param _spender Address that gets permission to spend
     * @param _value Amount of tokens approved for spending
     */
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    // MANDATORY FUNCTIONS - All ERC-20 tokens must implement these 6 functions
    
    /**
     * @dev Returns the total number of tokens in existence
     * @return Total supply of tokens
     * @notice This is like asking "how many of these tokens exist in total?"
     */
    function totalSupply() external view returns (uint256);
    
    /**
     * @dev Returns the token balance of a specific address
     * @param _owner Address to check balance for
     * @return Number of tokens owned by the address
     * @notice This is like checking someone's wallet balance
     */
    function balanceOf(address _owner) external view returns (uint256);
    
    /**
     * @dev Transfer tokens from caller to another address
     * @param _to Recipient address
     * @param _value Amount of tokens to transfer
     * @return true if transfer succeeded
     * @notice This is the basic "send tokens" function
     */
    function transfer (address _to, uint256 _value)external returns (bool);
    
    /**
     * @dev Transfer tokens from one address to another (requires prior approval)
     * @param _from Address to transfer from
     * @param _to Address to transfer to
     * @param _value Amount to transfer
     * @return true if transfer succeeded
     * @notice This allows someone else to spend your tokens (if you approved them)
     */
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
    
    /**
     * @dev Give permission to another address to spend your tokens
     * @param _spender Address that will be allowed to spend
     * @param _value Maximum amount they can spend
     * @return true if approval succeeded
     * @notice This is like giving someone permission to use your credit card up to a limit
     */
    function approve(address _spender, uint256 _value) external returns (bool);
    
    /**
     * @dev Check how many tokens an address is allowed to spend on behalf of owner
     * @param _owner Address that owns the tokens
     * @param _spender Address that has spending permission
     * @return Amount of tokens the spender can still spend
     * @notice This checks how much "allowance" is remaining
     */
    function allowance (address _owner, address _spender) external view returns (uint256);
}

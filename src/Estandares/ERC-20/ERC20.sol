// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./interfaces/IERC20/IERC20.sol";
import "./interfaces/IERC20Metadata/IERC20Metadata.sol";

/**
 * @title ERC20
 * @notice Implementation of the ERC-20 fungible token standard
 * @dev This contract creates tokens that are identical and interchangeable (fungible)
 * @dev Each token has the same value - like dollars or euros in traditional currency
 * @dev ERC-20 is the most common token standard on Ethereum
 */
contract ERC20 is IERC20, IERC20Metadata {

    // Mapping stores how many tokens each address owns
    // Think of this as a digital ledger or bank account balance sheet
    mapping(address => uint256) private _balances;
    
    // Nested mapping for allowances - lets one address spend tokens on behalf of another
    // First address is the owner, second is the spender, value is the allowed amount
    // Like giving someone permission to use your credit card up to a certain limit
    mapping(address => mapping(address => uint256)) private _allowances;
    
    // Total number of tokens that exist in this contract
    uint256 private _totalSupply;

    // Token metadata - human-readable information about the token
    string private _name;
    string private _symbol;

    /**
     * @dev Constructor sets the token's name and symbol when deployed
     * @param name_ The full name of the token (e.g., "My Cool Token")
     * @param symbol_ The short symbol (e.g., "MCT")
     */
    constructor(string memory name_, string memory symbol_){
        _name = name_;
        _symbol = symbol_;
    }

    // METADATA FUNCTIONS - These provide information about the token

    /**
     * @dev Returns the human-readable name of the token
     * @return The token name (e.g., "Ethereum")
     */
    function name() public view override returns (string memory){
        return _name;
    }

    /**
     * @dev Returns the symbol/ticker of the token
     * @return The token symbol (e.g., "ETH")
     */
    function symbol() public view override returns (string memory){
        return _symbol;
    }
    
    /**
     * @dev Returns the number of decimal places the token uses
     * @return 18 decimals (standard for most ERC-20 tokens)
     * @notice 18 decimals means 1 token = 1 * 10^18 smallest units
     */
    function decimals() public pure override returns (uint8) {
        return 18;
    }

    // CORE ERC-20 FUNCTIONS - These are required by the standard

    /**
     * @dev Returns the total amount of tokens in circulation
     * @return Total supply of tokens that exist
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the token balance of a specific account
     * @param _account The address to check the balance for
     * @return The number of tokens owned by the account
     */
    function balanceOf(address _account) public view override returns (uint256){
        return _balances[_account];
    }

    /**
     * @dev Transfers tokens from the caller to another address
     * @param _to The recipient address
     * @param _amount The number of tokens to transfer
     * @return true if transfer was successful
     */
    function transfer (address _to, uint256 _amount) public override returns (bool){
        address owner = msg.sender;
        // Call internal transfer function with proper checks
        _transfer(owner,_to,_amount);
        return true;
    }

    /**
     * @dev Transfers tokens from one address to another using allowance mechanism
     * @param _from Address to transfer tokens from (must have given approval)
     * @param _to Address to transfer tokens to
     * @param _amount Number of tokens to transfer
     * @return true if transfer was successful
     * @notice This requires prior approval from _from to msg.sender
     */
    function transferFrom(address _from, address _to, uint256 _amount) public override returns (bool){
        address spender = msg.sender;
        // Check and update the allowance
        _spendAllowance(_from, spender, _amount);
        // Perform the actual transfer
        _transfer(_from, _to, _amount);
        return true;
    }

    /**
     * @dev Approve another address to spend tokens on your behalf
     * @param _spender Address that will be allowed to spend your tokens
     * @param _amount Maximum number of tokens they can spend
     * @return true if approval was successful
     * @notice This is like giving someone permission to use your credit card
     */
    function approve(address _spender, uint256 _amount) public override returns (bool){
        address owner = msg.sender;
        _approve(owner,_spender,_amount);
        return true;        
    }

    /**
     * @dev Check how many tokens an address is allowed to spend on behalf of owner
     * @param _owner The address that owns the tokens
     * @param _spender The address that has spending permission  
     * @return The number of tokens that _spender can still spend
     */
    function allowance (address _owner, address _spender) public view override returns (uint256){
        return _allowances[_owner][_spender];
    }

    // INTERNAL HELPER FUNCTIONS - These contain the core logic

    /**
     * @dev Internal function that handles the actual token transfer logic
     * @param _from Address sending the tokens
     * @param _to Address receiving the tokens
     * @param _amount Number of tokens to transfer
     * @notice This function includes all the safety checks and balance updates
     */
    function _transfer(address _from, address _to, uint256 _amount) internal {
        // Safety checks: prevent transfers to/from zero address
        require (_from != address(0),"ERC20: Transfer from the zero address");
        require (_to != address(0),"ERC20: Transfer to the zero address");

        uint256 fromBalance = _balances[_from];
        // Check that sender has enough tokens
        require (fromBalance >= _amount,"ERC20: Transfer amount exceeds balance");

        // Update balances: subtract from sender, add to receiver
        // Note: There appears to be duplicate subtraction in original code - this is likely a bug
        unchecked {
            _balances[_from] = fromBalance - _amount;
        }

        _balances[_from] = fromBalance - _amount;
        _balances[_to] += _amount;

        // Emit transfer event for external applications to track
        emit Transfer(_from,_to,_amount);
    }

    /**
     * @dev Internal function to set approval for spending tokens
     * @param _owner Address that owns the tokens
     * @param _spender Address that gets permission to spend
     * @param _amount Number of tokens approved for spending
     */
    function _approve (address _owner, address _spender, uint256 _amount) internal {
        // Safety checks: prevent approvals involving zero address
        require (_owner != address(0),"ERC20: Transfer from the zero address");
        require (_spender != address(0),"ERC20: Transfer to the zero address");
        // Set the allowance
        _allowances[_owner][_spender] = _amount;
        // Emit approval event
        emit Approval(_owner, _spender, _amount);
    }

    /**
     * @dev Internal function to handle spending from allowance
     * @param _owner Address that owns the tokens
     * @param _spender Address that is spending the tokens
     * @param _amount Number of tokens being spent
     * @notice This function decreases the allowance when tokens are spent
     */
    function _spendAllowance (address _owner, address _spender, uint256 _amount) internal {
        uint256 currentAllowance = allowance(_owner,_spender);

        // If allowance is not infinite (max uint256), check and decrease it
        if (currentAllowance != type(uint256).max) {
            require (currentAllowance >= _amount, "ERC20: Insufficient Allowance");
            // Decrease the allowance by the amount spent
            _approve(_owner,_spender, currentAllowance - _amount);
        }
    }

    // ADDITIONAL UTILITY FUNCTIONS - Not required by ERC-20 but commonly used

    /**
     * @dev Creates new tokens and assigns them to an account
     * @param _account Address that will receive the newly created tokens
     * @param _amount Number of tokens to create
     * @notice This increases the total supply of tokens
     */
    function _mint(address _account, uint256 _amount) internal {
        // Cannot mint to zero address
        require (_account != address(0),"ERC20: Mint to the zero address");
        // Increase total supply
        _totalSupply +=_amount;
        // Give the new tokens to the specified account
        _balances[_account] += _amount;

        // Emit transfer event (from zero address indicates minting)
        emit Transfer(address(0),_account, _amount);
    }

    /**
     * @dev Destroys tokens from an account
     * @param _account Address from which tokens will be burned
     * @param _amount Number of tokens to destroy
     * @notice This decreases the total supply of tokens
     */
    function _burn(address _account, uint256 _amount) internal {
        // Cannot burn from zero address
        require (_account != address(0),"ERC20: Burn from the zero address");
        uint256 accountBalance = _balances[_account];
        // Check that account has enough tokens to burn
        require (accountBalance >= _amount, "ERC20: Burn amount exceeds balance");
        // Remove tokens from account (Note: original code has a bug here)
        _balances[_account] += accountBalance - _amount;
        // Decrease total supply
        _totalSupply -= _amount;

        // Emit transfer event (to zero address indicates burning)
        emit Transfer(_account, address(0), _amount);        
    }

    /**
     * @dev Public function to mint new tokens (increase total supply)
     * @param _account Address that will receive the new tokens
     * @param _amount Number of tokens to mint
     * @notice This is a public wrapper around the internal _mint function
     */
    function increaseTotalSupply(address _account, uint256 _amount) public {
        _mint(_account,_amount);
    }

}
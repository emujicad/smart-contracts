// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

/**
 * @title IERC20Metadata
 * @notice Interface for optional metadata functions in ERC-20 tokens
 * @dev These functions provide human-readable information about the token
 * @dev While not required by ERC-20, most tokens implement these for better user experience
 * @dev This makes tokens more user-friendly by providing descriptive information
 */
interface IERC20Metadata {
    // OPTIONAL METADATA FUNCTIONS - Not required by ERC-20 standard but commonly implemented
    
    /**
     * @dev Returns the human-readable name of the token
     * @return Token name (e.g., "Ethereum")
     * @notice This is the full name that users will see in wallets and applications
     */
    function name() external view returns (string memory);
    
    /**
     * @dev Returns the symbol/ticker of the token  
     * @return Token symbol (e.g., "ETH")
     * @notice This is the short abbreviation, usually 3-4 characters
     */
    function symbol() external view returns (string memory);
    
    /**
     * @dev Returns the number of decimal places used by the token
     * @return Number of decimals (usually 18 for most tokens)
     * @notice Decimals determine the smallest unit of the token
     * @notice 18 decimals means 1 token = 1 * 10^18 smallest units (like ETH and wei)
     * @notice For example: if decimals = 18, then 1.5 tokens = 1500000000000000000 smallest units
     */
    function decimals() external returns (uint8);
}

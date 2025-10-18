# IERC20 Interface

This file defines the interface for the ERC20 token standard. It includes the six mandatory functions that any ERC20 token must implement:

*   `totalSupply()`
*   `balanceOf(address account)`
*   `transfer(address recipient, uint256 amount)`
*   `allowance(address owner, address spender)`
*   `approve(address spender, uint256 amount)`
*   `transferFrom(address sender, address recipient, uint256 amount)`

It also defines two events, `Transfer` and `Approval`, which are emitted when tokens are transferred or approved.

This interface is used in the test files to interact with ERC20 tokens, such as the DAI token in the `forkDai.sol` test.
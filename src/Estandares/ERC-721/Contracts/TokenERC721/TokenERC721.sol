// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Import the necessary interfaces. Interfaces define a set of functions
// that our contract promises to implement.
import "../../interfaces/IERC165/IERC165.sol";
import "../../interfaces/IERC721/IERC721.sol";
import "../../interfaces/IERC721Receiver/IERC721Receiver.sol";

/**
 * @title TokenERC721
 * @dev Implementation of a non-fungible token (NFT) that complies with EIP-721 and EIP-165 standards.
 *      This contract manages the creation (minting), transfer, and ownership tracking of NFTs.
 */
contract TokenERC721 is IERC165, IERC721 {
    // --- State Variables ---

    // Mapping from the ID of each token to the address of its owner.
    // `mapping` is like a dictionary or hash table. `private` means it can only be accessed from this contract.
    mapping(uint256 => address) private _owners;

    // Mapping from the address of each owner to the number of tokens they own.
    mapping(address => uint256) private _balances;

    // Mapping from the ID of each token to the address that is approved to transfer it.
    // There can only be one approved address per token.
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from an owner to an "operator". The operator is an address that has
    // permission to manage ALL of the owner's tokens.
    // The boolean `bool` indicates whether the permission is active (`true`) or not (`false`).
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // --- ERC165 Standard Functions ---

    /**
     * @notice Declares the interfaces that this contract implements.
     * @dev Overrides the function from ERC165. A contract that implements ERC721
     *      must also implement ERC165.
     * @param interfaceId The ID of the interface to query.
     * @return `true` if the contract implements `interfaceId`.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    // --- ERC721 Standard Functions ---

    /**
     * @notice Returns the number of NFTs owned by an `owner`.
     */
    function balanceOf(address owner) public view virtual override returns (uint256){
        require (owner != address(0), "ERC721 Error: Transfer from the zero address");
        return _balances[owner];
    }

    /**
     * @notice Returns the owner of the `tokenId`.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require (owner != address(0), "ERC721 Error: Token does not exist or has been burned.");
        return owner;
    }

    /**
     * @notice Approves `to` to be able to transfer the `tokenId`.
     * @dev The caller of this function (msg.sender) must be the owner of the token or an approved operator.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ownerOf(tokenId);
        require (to != owner, "ERC721 Error: The approval cannot be for the current owner.");
        require (msg.sender == owner || isApprovedForAll(owner, msg.sender), "ERC721 Error: The caller is not the owner nor an approved operator.");
        _approve(to, tokenId);
    }

    /**
     * @notice Grants or revokes permission for an `operator` to manage all tokens of the `msg.sender`.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require (operator != msg.sender, "ERC721 Error: You cannot approve yourself as an operator.");
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @notice Returns the approved address for a `tokenId`.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address operator) {
        require(_exists(tokenId), "ERC721 Error: Token does not exist.");
        return _tokenApprovals[tokenId];
    }

    /**
     * @notice Queries if an `operator` is approved by an `owner`.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
        return _operatorApprovals[owner][operator];
    }

    /**
     * @notice Safely transfers a token.
     * @dev Implements the logic of `safeTransferFrom` by calling the internal transfer function
     *      and then checking that the recipient can handle the token.
     */
    function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override{
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: The caller is not authorized to transfer this token.");
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, bytes("")), "ERC721: Transfer to a non-ERC721 receiver contract is reverted.");
    }

    /**
     * @notice Safely transfers a token (version with data).
     */
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: The caller is not authorized to transfer this token.");
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: Transfer to a non-ERC721 receiver contract is reverted.");
    }

    /**
     * @notice Transfers a token ("unsafe" version).
     * @dev It is the caller's responsibility to check that the recipient can receive the token.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual override {
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: The caller is not authorized to transfer this token.");
        _transfer(from, to, tokenId);
    }


    // --- Internal Functions (Main Logic) ---

    /**
     * @dev Internal function to safely mint (create) a new token.
     *      "Internal" means it can only be called from within this contract or from contracts that inherit from it.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, bytes(""));
    }

    /**
     * @dev Overload of `_safeMint` that includes data.
     */
    function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
        _mint(to, tokenId);
        require(_checkOnERC721Received(address(0), to, tokenId, data), "ERC721: Cannot mint to a contract that does not implement onERC721Received.");
    }

    /**
     * @dev Internal function to mint a new token.
     *      Updates balances and assigns the owner.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: Cannot mint to the zero address.");
        require(!_exists(tokenId), "ERC721: The token has already been minted.");

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId); // The `from` is the zero address on minting.
    }

    /**
     * @dev Internal function to transfer a token.
     *      It is the core of all transfer functions.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual{
        require (ownerOf(tokenId) == from, "ERC721: The transfer does not originate from the owner.");
        require (to != address(0), "ERC721: Cannot transfer to the zero address.");

        // Hook that can be overridden by child contracts to execute logic before the transfer.
        _beforeTokenTransfer(from, to, tokenId);

        // Clears the previous approval for the token.
        _approve(address(0), tokenId);

        // Updates the balances.
        _balances[from] -= 1;
        _balances[to] += 1;
        // Transfers ownership.
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Hook that is called before any token transfer.
     *      It is empty here, but contracts that inherit from this one can override it
     *      to add custom logic (e.g., checking a whitelist).
     */
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}

    /**
     * @dev Internal function to set the approval for a token.
     */
    function _approve (address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Checks if a token exists.
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Checks if an address (`spender`) is authorized to transfer a token.
     *      A `spender` can be the owner, an approved operator, or have approval for that specific token.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool){
        require (_exists(tokenId), "ERC721: Token does not exist.");
        address owner = ownerOf(tokenId);
        return(spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Calls `onERC721Received` on a recipient contract.
     */
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) internal virtual returns(bool) {
        if(isContract(to)){
            try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            }
            catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: Transfer to a non-ERC721 receiver contract reverted.");
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        }
        else {
            return true; // If it's not a contract, the check passes.
        }
    }

    /**
     * @dev Checks if an address is a smart contract.
     * @return `true` if the address has code, `false` otherwise.
     */
    function isContract (address addr) private view returns (bool){
        uint32 size;
        assembly {
            size := extcodesize(addr)
        }
        return (size > 0);
    }
}
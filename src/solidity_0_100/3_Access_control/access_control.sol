// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title c1_AccessControl
 * This contract implements a very simple role-based access control (RBAC) mechanism.
 * There are two roles defined: ADMIN and USER.
 * - ADMIN accounts can assign or revoke roles to other accounts.
 * - USER role is just an example; you can expand with more roles.
 * 
 * Notes for beginners:
 * - A "role" is represented here by a hash (bytes32) created with keccak256().
 * - A mapping is used to keep track of which address has which role.
 * - Events are emitted every time a role is granted or revoked.
 */
contract c1_AccessControl {

  // Events are used to log when a role is assigned or revoked.
  // Dapps and off-chain systems can "listen" to these events.
  event AssingRole (bytes32 indexed role, address indexed account);
  event RevokeRole (bytes32 indexed role, address indexed account);

  // Mapping structure to store roles:
  // role (bytes32, the hash) => (account address => boolean true/false)
  // If roles[role][account] == true, it means that account has that role.
  mapping (bytes32 => mapping (address => bool)) public roles;

  // Definition of an ADMIN role.
  // keccak256 is a hashing function used to create a unique identifier for the string "ADMIN".
  // Using a hash (instead of plain strings) is a common Solidity practice to improve efficiency.
  bytes32 private constant ADMIN = keccak256(abi.encodePacked("ADMIN"));
  //byte32 public constant ADMIN = keccak256(abi.encodePacked("ADMIN"));

  // Definition of a USER role (same logic as ADMIN, but for a different type of user).
  bytes32 private constant USER = keccak256(abi.encodePacked("USER"));
  //byte32 public constant USER = keccak256(abi.encodePacked("USER"));

  // Modifier restricts function access to only accounts with ADMIN role.
  // If msg.sender (the caller) does not have the ADMIN role, transaction fails.
  modifier onlyAdmin(bytes32 _role) {
     require(roles[_role][msg.sender], "Error. You are not authorized");
    _;
  }

  // Internal function to assign a role.
  // Can only be called by contract itself or functions inside the contract.
  function _assignRole (bytes32 _role, address _account) internal { 
     roles[_role][_account]= true;
     emit AssingRole(_role, _account);
  }

  // Internal function to revoke a role.
  function _revokeRole (bytes32 _role, address _account) internal { 
     roles[_role][_account]= false;
     emit RevokeRole(_role, _account);
  }

  // Public function to assign a role, restricted to ADMIN accounts.
  // External means it can be called from outside the contract.
  function assignRole (bytes32 _role, address _account) external onlyAdmin(ADMIN) { 
     _assignRole(_role, _account);
  }

  // Public function to revoke a role, restricted to ADMIN accounts.
  function revokeRole (bytes32 _role, address _account) external onlyAdmin(ADMIN) { 
    _revokeRole(_role, _account);
  }

  // Constructor of the contract.
  // When deployed, it will automatically give the deployer (msg.sender)
  // the ADMIN role. This ensures at least one admin exists.
  constructor () {
     _assignRole(ADMIN, msg.sender); 
  }
}

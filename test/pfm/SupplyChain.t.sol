// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "../../src/pfm/SupplyChain.sol";

contract SupplyChainTest is Test {
    SupplyChain public supplyChain;
    address owner;
    address producer_address;
    address factory_address;
    address retailer_address;
    address consumer_address;

    function setUp() public {
        owner = address(this);
        producer_address = makeAddr("producer");
        factory_address = makeAddr("factory");
        retailer_address = makeAddr("retailer");
        consumer_address = makeAddr("consumer");
        
        vm.prank(owner);
        supplyChain = new SupplyChain();
    }

    // --- Helper Functions ---
    function _registerAndApproveUser(address userAddr, SupplyChain.UserRole role) internal {
        vm.prank(userAddr);
        supplyChain.requestUserRole(role);
        vm.prank(owner);
        supplyChain.changeStatusUser(userAddr, SupplyChain.UserStatus.Approved);
    }

    // --- Tests de gestión de usuarios ---
    function testUserRegistration() public {
        SupplyChain.UserRole roleToRequest = SupplyChain.UserRole.Producer;

        vm.prank(producer_address);
        supplyChain.requestUserRole(roleToRequest);

        uint256 userId = supplyChain.addressToUserId(producer_address);
        assertTrue(userId > 0, "User ID should be greater than 0 after registration");

        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(user.id, userId, "User ID mismatch");
        assertEq(user.userAddress, producer_address, "User address mismatch");
        assertEq(uint(user.role), uint(roleToRequest), "User role mismatch");
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Pending), "User status should be Pending");
        assertEq(supplyChain.nextUserId(), 2, "nextUserId should be incremented to 2");
    }

    function testAdminApproveUser() public {
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        uint256 userId = supplyChain.addressToUserId(producer_address);
        assertTrue(userId > 0, "Setup failed: User should be registered");

        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);

        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Approved), "User status should be Approved");
    }

    function testAdminRejectUser() public {
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        uint256 userId = supplyChain.addressToUserId(producer_address);
        assertTrue(userId > 0, "Setup failed: User should be registered");

        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Rejected);

        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Rejected), "User status should be Rejected");
    }

    function testOnlyApprovedUsersCanOperate() public {
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);

        // User with Pending status cannot create a token
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        // Approve user and try again
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        assertEq(supplyChain.nextTokenId(), 2, "nextTokenId should be incremented after token creation");
    }

    function testGetUserInfo() public {
        SupplyChain.UserRole roleToRequest = SupplyChain.UserRole.Producer;
        vm.prank(producer_address);
        supplyChain.requestUserRole(roleToRequest);
        uint256 userId = supplyChain.addressToUserId(producer_address);

        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(user.id, userId, "Returned user ID mismatch");
        assertEq(user.userAddress, producer_address, "Returned user address mismatch");
        assertEq(uint(user.role), uint(roleToRequest), "Returned user role mismatch");
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Pending), "Returned user status should be Pending");
    }

    function testIsAdmin() public {
        assertTrue(supplyChain.isAdmin(owner), "Owner should be admin");
        assertFalse(supplyChain.isAdmin(producer_address), "Producer should not be admin");
        assertFalse(supplyChain.isAdmin(address(1)), "Random address should not be admin");
    }

    function testUserStatusChanges() public {
        // Purpose: Test the various status changes a user can undergo (Pending, Approved, Rejected, Canceled).

        // 1. Setup: Register a user (producer_address) with a Producer role.
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        uint256 userId = supplyChain.addressToUserId(producer_address);

        // 2. Assert initial status is 'Pending'.
        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Pending), "Initial status should be Pending");

        // 3. Action & Assert: Change status to 'Approved' and verify.
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Approved), "Status should be Approved");

        // 4. Action & Assert: Change status to 'Rejected' and verify.
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Rejected);
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Rejected), "Status should be Rejected");

        // 5. Action & Assert: Change status to 'Canceled' and verify.
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Canceled);
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Canceled), "Status should be Canceled");
        
        // 6. Action & Assert: Change status back to 'Pending' and verify.
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Pending);
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Pending), "Status should be back to Pending");
    }

    // --- Tests de creación de tokens ---
    function testCreateTokenByProducer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(1);
        assertEq(id, 1, "Token ID should be 1");
        assertEq(creator, producer_address, "Token creator should be producer");
        assertEq(name, "Wood", "Token name should be Wood");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.RowMaterial), "Token type should be RowMaterial");
        assertEq(totalSupply, 100, "Token total supply should be 100");
        assertEq(parentId, 0, "Raw material should have parentId 0");
        assertEq(supplyChain.getTokenBalance(1, producer_address), 100, "Producer should have full balance");
    }

    function testGetToken() public {
        // Setup: Create a token first
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "High quality oak wood", 0);

        // Test: Get token information
        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(1);
        
        // Assertions
        assertEq(id, 1, "Token ID should be 1");
        assertEq(creator, producer_address, "Creator should be producer");
        assertEq(name, "Wood", "Name should be Wood");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.RowMaterial), "Type should be RowMaterial");
        assertEq(totalSupply, 100, "Total supply should be 100");
        assertEq(features, "High quality oak wood", "Features should match");
        assertEq(parentId, 0, "Parent ID should be 0 for raw material");
        assertTrue(dateCreated > 0, "Date created should be greater than 0");
    }

    function testTokenBalance() public {
        // Setup: Create users and token
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Create a token
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Test initial balances
        assertEq(supplyChain.getTokenBalance(1, producer_address), 100, "Producer should have initial balance of 100");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0, "Factory should have initial balance of 0");
        assertEq(supplyChain.getTokenBalance(1, owner), 0, "Owner should have balance of 0");
        
        // Transfer some tokens and test balances
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 30);
        
        // After transfer (before acceptance)
        assertEq(supplyChain.getTokenBalance(1, producer_address), 70, "Producer balance should be 70 after transfer");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0, "Factory balance should still be 0 before acceptance");
        
        // Accept transfer
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // After acceptance
        assertEq(supplyChain.getTokenBalance(1, producer_address), 70, "Producer balance should remain 70");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 30, "Factory balance should be 30 after acceptance");
    }

    function testCreateTokenByFactory() public {
        // First create a raw material token (parentId will be 1)
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        // Now factory can create finished product with parentId 1
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        vm.prank(factory_address);
        supplyChain.createToken("Chair", SupplyChain.TokenType.FinishedProduct, 50, "", 1);

        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(2);
        assertEq(creator, factory_address, "Token creator should be factory");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.FinishedProduct), "Token type should be FinishedProduct");
        assertEq(parentId, 1, "Finished product should have parentId");
    }

    function testUnapprovedUserCannotCreateToken() public {
        vm.prank(consumer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Consumer);
        
        vm.prank(owner);
        supplyChain.changeStatusUser(consumer_address, SupplyChain.UserStatus.Approved);

        vm.prank(consumer_address);
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        supplyChain.createToken("Illegal Token", SupplyChain.TokenType.RowMaterial, 100, "", 0);
    }

    // --- Tests de transferencias básicas ---
    function testTransferFromProducerToFactory() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        // Create token
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        // Transfer
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(1);
        assertEq(transferItem.from, producer_address, "Transfer from should be producer");
        assertEq(transferItem.to, factory_address, "Transfer to should be factory");
        assertEq(transferItem.tokenId, 1, "Transfer token ID should be 1");
        assertEq(transferItem.amount, 50, "Transfer amount should be 50");
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Pending), "Transfer should be pending");

        // Verify balances after transfer
        assertEq(supplyChain.getTokenBalance(1, producer_address), 50, "Producer balance should be 50 after transfer");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0, "Factory balance should be 0 before acceptance");
    }

    function testTransferFromFactoryToRetailer() public {
        // Setup complete chain: Producer → Factory → Retailer
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);

        // 1. Producer creates raw material
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        // 2. Producer transfers to Factory
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 80);
        
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);

        // 3. Factory creates finished product
        vm.prank(factory_address);
        supplyChain.createToken("Chair", SupplyChain.TokenType.FinishedProduct, 40, "", 1);

        // 4. Factory transfers finished product to Retailer
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 2, 25);

        // Test transfer details
        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(2);
        assertEq(transferItem.from, factory_address, "Transfer from should be factory");
        assertEq(transferItem.to, retailer_address, "Transfer to should be retailer");
        assertEq(transferItem.tokenId, 2, "Transfer token ID should be 2 (finished product)");
        assertEq(transferItem.amount, 25, "Transfer amount should be 25");
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Pending), "Transfer should be pending");

        // Test balances before acceptance
        assertEq(supplyChain.getTokenBalance(2, factory_address), 15, "Factory should have 15 chairs left");
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 0, "Retailer should have 0 before acceptance");

        // Accept transfer
        vm.prank(retailer_address);
        supplyChain.acceptTransfer(2);

        // Test final balances
        assertEq(supplyChain.getTokenBalance(2, factory_address), 15, "Factory should have 15 chairs");
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 25, "Retailer should have 25 chairs");
    }

    function testTransferFromRetailerToConsumer() public {
        // Setup complete chain: Producer → Factory → Retailer → Consumer
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        _registerAndApproveUser(consumer_address, SupplyChain.UserRole.Consumer);

        // 1. Producer creates and transfers raw material to Factory
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);

        // 2. Factory creates finished product and transfers to Retailer
        vm.prank(factory_address);
        supplyChain.createToken("Chair", SupplyChain.TokenType.FinishedProduct, 20, "", 1);
        
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 2, 15);
        vm.prank(retailer_address);
        supplyChain.acceptTransfer(2);

        // 3. Retailer transfers to Consumer (final step)
        vm.prank(retailer_address);
        supplyChain.transfer(consumer_address, 2, 8);

        // Test transfer details
        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(3);
        assertEq(transferItem.from, retailer_address, "Transfer from should be retailer");
        assertEq(transferItem.to, consumer_address, "Transfer to should be consumer");
        assertEq(transferItem.tokenId, 2, "Transfer token ID should be 2 (finished product)");
        assertEq(transferItem.amount, 8, "Transfer amount should be 8");
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Pending), "Transfer should be pending");

        // Test balances before acceptance
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 7, "Retailer should have 7 chairs left");
        assertEq(supplyChain.getTokenBalance(2, consumer_address), 0, "Consumer should have 0 before acceptance");

        // Accept transfer (Consumer receives final product)
        vm.prank(consumer_address);
        supplyChain.acceptTransfer(3);

        // Test final balances - chain completed
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 7, "Retailer should have 7 chairs");
        assertEq(supplyChain.getTokenBalance(2, consumer_address), 8, "Consumer should have 8 chairs");
        
        // Verify transfer status
        transferItem = supplyChain.getTransfer(3);
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer should be accepted");
    }

    function testGetTransfer() public {
        // Setup: Create transfer scenario
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        // Test: Get transfer information
        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(1);
        
        // Assertions
        assertEq(transferItem.id, 1, "Transfer ID should be 1");
        assertEq(transferItem.from, producer_address, "Transfer from should be producer");
        assertEq(transferItem.to, factory_address, "Transfer to should be factory");
        assertEq(transferItem.tokenId, 1, "Transfer token ID should be 1");
        assertEq(transferItem.amount, 50, "Transfer amount should be 50");
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Pending), "Transfer should be pending");
        assertTrue(transferItem.dateCreated > 0, "Date created should be greater than 0");

        // Test with accepted transfer
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);

        transferItem = supplyChain.getTransfer(1);
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer should be accepted after acceptance");
    }

    function testOnlyAdminCanChangeStatus() public {
        // Setup: Register a user
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);

        // Test: Only admin (owner) can change status
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);

        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Approved), "Status should be approved by admin");

        // Test: Non-admin cannot change status
        vm.prank(factory_address);
        vm.expectRevert(SupplyChain.NoOwner.selector);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Rejected);

        // Test: Producer cannot change their own status
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.NoOwner.selector);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Pending);

        // Test: Random user cannot change status
        address randomUser = makeAddr("randomUser");
        vm.prank(randomUser);
        vm.expectRevert(SupplyChain.NoOwner.selector);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Canceled);

        // Verify status hasn't changed
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Approved), "Status should remain approved");
    }

    function testCompleteSupplyChainFlow() public {
        // Complete integration test: Raw material → Finished product → Consumer
        
        // 1. Setup all participants
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        _registerAndApproveUser(consumer_address, SupplyChain.UserRole.Consumer);

        // 2. Producer creates raw material
        vm.prank(producer_address);
        supplyChain.createToken("Oak Wood", SupplyChain.TokenType.RowMaterial, 1000, "Premium quality oak", 0);
        assertEq(supplyChain.getTokenBalance(1, producer_address), 1000, "Producer should have 1000 oak wood");

        // 3. Producer → Factory: Raw material transfer
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 500);
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        assertEq(supplyChain.getTokenBalance(1, producer_address), 500, "Producer should have 500 oak left");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 500, "Factory should have 500 oak");

        // 4. Factory creates finished product from raw material
        vm.prank(factory_address);
        supplyChain.createToken("Oak Chair", SupplyChain.TokenType.FinishedProduct, 100, "Handcrafted oak chair", 1);
        assertEq(supplyChain.getTokenBalance(2, factory_address), 100, "Factory should have 100 chairs");

        // 5. Factory → Retailer: Finished product transfer
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 2, 75);
        vm.prank(retailer_address);
        supplyChain.acceptTransfer(2);
        
        assertEq(supplyChain.getTokenBalance(2, factory_address), 25, "Factory should have 25 chairs left");
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 75, "Retailer should have 75 chairs");

        // 6. Retailer → Consumer: Final sale
        vm.prank(retailer_address);
        supplyChain.transfer(consumer_address, 2, 20);
        vm.prank(consumer_address);
        supplyChain.acceptTransfer(3);
        
        assertEq(supplyChain.getTokenBalance(2, retailer_address), 55, "Retailer should have 55 chairs left");
        assertEq(supplyChain.getTokenBalance(2, consumer_address), 20, "Consumer should have 20 chairs");

        // 7. Verify traceability - check token parent relationship
        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(2);
        assertEq(parentId, 1, "Chair should trace back to oak wood");
        assertEq(creator, factory_address, "Chair should be created by factory");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.FinishedProduct), "Should be finished product");

        // 8. Verify total transfers in the system
        assertEq(supplyChain.getTotalTransfers(), 3, "Should have 3 total transfers");

        // 9. Test that consumer cannot transfer further (end of chain)
        vm.prank(consumer_address);
        vm.expectRevert(SupplyChain.NoTransfersAllowed.selector);
        supplyChain.transfer(producer_address, 2, 5);
    }

    function testCreateTokenByRetailer() public {
        // Note: Retailers typically don't create tokens but can in some supply chains
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        
        // Retailer cannot create tokens (only Producer and Factory can)
        vm.prank(retailer_address);
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        supplyChain.createToken("Retail Product", SupplyChain.TokenType.FinishedProduct, 50, "", 0);
    }

    function testGetUserTokens() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Create multiple tokens
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.createToken("Steel", SupplyChain.TokenType.RowMaterial, 200, "", 0);
        
        vm.prank(factory_address);
        supplyChain.createToken("Chair", SupplyChain.TokenType.FinishedProduct, 50, "", 1);
        
        // Test getUserTokens function exists and can be called
        // Note: This is a gas-expensive function, mainly for off-chain use
        uint[] memory producerTokens = supplyChain.getUserTokens(producer_address);
        uint[] memory factoryTokens = supplyChain.getUserTokens(factory_address);
        
        assertEq(producerTokens.length, 2, "Producer should have 2 tokens");
        assertEq(factoryTokens.length, 1, "Factory should have 1 token");
    }

    function testGetUserTransfers() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Create multiple transfers
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 30);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 20);
        
        // Test getUserTransfers function exists and can be called
        uint[] memory producerTransfers = supplyChain.getUserTransfers(producer_address);
        uint[] memory factoryTransfers = supplyChain.getUserTransfers(factory_address);
        
        assertEq(producerTransfers.length, 2, "Producer should have 2 transfers");
        assertEq(factoryTransfers.length, 2, "Factory should have 2 transfers");
    }

    function testTransferNonExistentToken() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Try to transfer non-existent token
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.TokenDoesNotExist.selector);
        supplyChain.transfer(factory_address, 999, 50);
    }

    function testTokenWithParentId() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Create parent token
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Create child token with parent
        vm.prank(factory_address);
        supplyChain.createToken("Chair", SupplyChain.TokenType.FinishedProduct, 25, "", 1);
        
        // Verify parent relationship
        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(2);
        assertEq(parentId, 1, "Child token should have correct parent ID");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.FinishedProduct), "Child should be finished product");
    }

    function testTokenMetadata() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        
        string memory features = "High quality oak wood, sustainably sourced";
        vm.prank(producer_address);
        supplyChain.createToken("Oak Wood", SupplyChain.TokenType.RowMaterial, 100, features, 0);
        
        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory returnedFeatures, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(1);
        
        assertEq(name, "Oak Wood", "Token name should match");
        assertEq(returnedFeatures, features, "Token features should match");
        assertEq(creator, producer_address, "Creator should match");
        assertEq(totalSupply, 100, "Total supply should match");
    }

    function testUnapprovedUserCannotTransfer() public {
        // Register but don't approve producer
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(factory_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Unapproved producer cannot initiate transfers
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.NoTransfersAllowed.selector);
        supplyChain.transfer(factory_address, 1, 50);
    }

    function testInvalidRoleTransfer() public {
        _registerAndApproveUser(consumer_address, SupplyChain.UserRole.Consumer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Create a raw material token first
        vm.prank(factory_address);
        supplyChain.createToken("Raw Material", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Consumer cannot initiate transfers (only can receive)
        vm.prank(consumer_address);
        vm.expectRevert(SupplyChain.NoTransfersAllowed.selector);
        supplyChain.transfer(factory_address, 1, 50);
    }

    function testTransferToSameAddress() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Transfer to same address is allowed - creates pending transfer to self
        vm.prank(producer_address);
        supplyChain.transfer(producer_address, 1, 50);
        
        // Check that transfer was created
        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(1);
        assertEq(transferItem.from, producer_address, "Transfer from should be producer");
        assertEq(transferItem.to, producer_address, "Transfer to should be producer");
        assertEq(transferItem.amount, 50, "Transfer amount should be 50");
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Pending), "Transfer should be pending");
    }

    function testAcceptNonExistentTransfer() public {
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        // Try to accept non-existent transfer
        vm.prank(factory_address);
        vm.expectRevert(SupplyChain.TransferDoesNotExist.selector);
        supplyChain.acceptTransfer(999);
    }

    function testTransferAfterRejection() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        // Create and reject transfer
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
        
        vm.prank(factory_address);
        supplyChain.rejectTransfer(1);
        
        // Verify tokens returned to producer
        assertEq(supplyChain.getTokenBalance(1, producer_address), 100, "Tokens should return to producer");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0, "Factory should have 0 tokens");
        
        // Producer can create new transfer after rejection
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 30);
        
        // Verify new transfer
        SupplyChain.Transfer memory transfer = supplyChain.getTransfer(2);
        assertEq(transfer.amount, 30, "New transfer amount should be 30");
        assertEq(uint(transfer.status), uint(SupplyChain.TransferStatus.Pending), "New transfer should be pending");
    }

    function testAcceptTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);

        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(1);
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer should be accepted");
        
        assertEq(supplyChain.getTokenBalance(1, producer_address), 50, "Producer balance should be 50");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 50, "Factory balance should be 50 after acceptance");
    }

    function testRejectTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        vm.prank(factory_address);
        supplyChain.rejectTransfer(1);

        SupplyChain.Transfer memory transferItem = supplyChain.getTransfer(1);
        assertEq(uint(transferItem.status), uint(SupplyChain.TransferStatus.Rejected), "Transfer should be rejected");
        
        // Tokens should return to sender
        assertEq(supplyChain.getTokenBalance(1, producer_address), 100, "Producer should have original balance back");
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0, "Factory should have 0 balance");
    }

    function testTransferInsufficientBalance() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InsufficientBalance.selector, 100, 150));
        supplyChain.transfer(factory_address, 1, 150);
    }

    // --- Test de pausa ---
    function testPauseFunctionality() public {
        // Only owner can pause
        vm.prank(owner);
        supplyChain.pause();
        
        assertTrue(supplyChain.isPaused(), "Contract should be paused");

        // Functions should fail when paused
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.ContractPaused.selector);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);

        // Only owner can unpause
        vm.prank(owner);
        supplyChain.unpause();
        
        assertFalse(supplyChain.isPaused(), "Contract should not be paused");
    }

    // --- Test de ownership transfer ---
    function testOwnershipTransfer() public {
        address newOwner = makeAddr("newOwner");
        
        // Initiate transfer
        vm.prank(owner);
        supplyChain.initiateOwnershipTransfer(newOwner);
        
        assertEq(supplyChain.getPendingOwner(), newOwner, "Pending owner should be set");
        
        // Accept ownership
        vm.prank(newOwner);
        supplyChain.acceptOwnership();
        
        assertEq(supplyChain.owner(), newOwner, "New owner should be set");
        assertEq(supplyChain.getPendingOwner(), address(0), "Pending owner should be reset");
    }

    // --- Tests adicionales de seguridad ---
    function testOnlyOwnerCanInitiateTransfer() public {
        address newOwner = makeAddr("newOwner");
        
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.NoOwner.selector);
        supplyChain.initiateOwnershipTransfer(newOwner);
    }

    function testCannotTransferToZeroAddress() public {
        vm.prank(owner);
        vm.expectRevert(SupplyChain.InvalidAddress.selector);
        supplyChain.initiateOwnershipTransfer(address(0));
    }

    function testOnlyPendingOwnerCanAccept() public {
        address newOwner = makeAddr("newOwner");
        address randomUser = makeAddr("randomUser");
        
        vm.prank(owner);
        supplyChain.initiateOwnershipTransfer(newOwner);
        
        vm.prank(randomUser);
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        supplyChain.acceptOwnership();
    }

    function testUnauthorizedUserCannotPause() public {
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.Unauthorized.selector);
        supplyChain.pause();
    }

    function testCannotPauseWhenAlreadyPaused() public {
        vm.prank(owner);
        supplyChain.pause();
        
        vm.prank(owner);
        vm.expectRevert(SupplyChain.ContractPaused.selector);
        supplyChain.pause();
    }

    function testCannotUnpauseWhenNotPaused() public {
        vm.prank(owner);
        vm.expectRevert(SupplyChain.ContractNotPaused.selector);
        supplyChain.unpause();
    }

    function testOnlyReceiverCanAcceptTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        // Random user cannot accept transfer
        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.NoReceiverAllowed.selector);
        supplyChain.acceptTransfer(1);
    }

    function testCannotAcceptNonPendingTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);

        // Accept once
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);

        // Cannot accept again
        vm.prank(factory_address);
        vm.expectRevert(SupplyChain.TransferNotPending.selector);
        supplyChain.acceptTransfer(1);
    }

    function testCannotTransferMoreThanBalance() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InsufficientBalance.selector, 100, 150));
        supplyChain.transfer(factory_address, 1, 150);
    }

    function testTransferZeroAmount() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.InvalidAmount.selector);
        supplyChain.transfer(factory_address, 1, 0);
    }

    function testCannotTransferToZeroAddressInTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        vm.prank(producer_address);
        vm.expectRevert(SupplyChain.InvalidAddress.selector);
        supplyChain.transfer(address(0), 1, 50);
    }

    function testConsumerCannotTransfer() public {
        _registerAndApproveUser(consumer_address, SupplyChain.UserRole.Consumer);
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);

        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);

        // Transfer some tokens to consumer first (through factory/retailer)
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        vm.prank(producer_address);
        supplyChain.transfer(retailer_address, 1, 50);
        vm.prank(retailer_address);
        supplyChain.acceptTransfer(1);
        
        vm.prank(retailer_address);
        supplyChain.transfer(consumer_address, 1, 25);
        vm.prank(consumer_address);
        supplyChain.acceptTransfer(2);

        // Consumer cannot transfer to anyone
        vm.prank(consumer_address);
        vm.expectRevert(SupplyChain.NoTransfersAllowed.selector);
        supplyChain.transfer(producer_address, 1, 10);
    }

    // --- Tests de eventos ---
    function testUserRegisteredEvent() public {
        vm.expectEmit(true, false, false, true);
        emit SupplyChain.UserRoleRequested(producer_address, SupplyChain.UserRole.Producer);
        
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
    }

    function testUserStatusChangedEvent() public {
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        vm.expectEmit(true, false, false, true);
        emit SupplyChain.UserStatusChanged(producer_address, SupplyChain.UserStatus.Pending, SupplyChain.UserStatus.Approved);
        
        vm.prank(owner);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
    }

    function testTokenCreatedEvent() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        
        vm.expectEmit(true, true, false, true);
        emit SupplyChain.TokenCreated(1, producer_address, "Wood", SupplyChain.TokenType.RowMaterial, 100, 0);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
    }

    function testTransferInitiatedEvent() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.expectEmit(true, true, true, true);
        emit SupplyChain.TransferRequested(1, producer_address, factory_address, 1, 50);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
    }

    function testTransferAcceptedEvent() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
        
        vm.expectEmit(true, false, false, true);
        emit SupplyChain.TransferAccepted(1);
        
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
    }

    function testTransferRejectedEvent() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
        
        vm.expectEmit(true, false, false, true);
        emit SupplyChain.TransferRejected(1);
        
        vm.prank(factory_address);
        supplyChain.rejectTransfer(1);
    }

    // --- Tests de casos edge adicionales ---
    function testDoubleAcceptTransfer() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 50);
        
        // First acceptance should work
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // Second acceptance should fail
        vm.prank(factory_address);
        vm.expectRevert(SupplyChain.TransferNotPending.selector);
        supplyChain.acceptTransfer(1);
    }

    // --- Tests de flujo completo adicionales ---
    function testMultipleTokensFlow() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        
        // Producer creates multiple raw materials
        vm.prank(producer_address);
        supplyChain.createToken("Wood", SupplyChain.TokenType.RowMaterial, 100, "", 0);
        
        vm.prank(producer_address);
        supplyChain.createToken("Metal", SupplyChain.TokenType.RowMaterial, 200, "", 0);
        
        // Transfer different amounts to factory
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 30); // Wood
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 2, 50); // Metal
        
        // Factory accepts both transfers
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        vm.prank(factory_address);
        supplyChain.acceptTransfer(2);
        
        // Factory creates finished products from both materials
        vm.prank(factory_address);
        supplyChain.createToken("WoodChair", SupplyChain.TokenType.FinishedProduct, 15, "", 1);
        
        vm.prank(factory_address);
        supplyChain.createToken("MetalTable", SupplyChain.TokenType.FinishedProduct, 10, "", 2);
        
        // Transfer products to retailer
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 3, 10); // WoodChair
        
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 4, 5); // MetalTable
        
        // Verify final balances
        assertEq(supplyChain.getTokenBalance(1, producer_address), 70, "Producer should have remaining wood");
        assertEq(supplyChain.getTokenBalance(2, producer_address), 150, "Producer should have remaining metal");
        assertEq(supplyChain.getTokenBalance(3, factory_address), 5, "Factory should have remaining wood chairs");
        assertEq(supplyChain.getTokenBalance(4, factory_address), 5, "Factory should have remaining metal tables");
    }

    function testTraceabilityFlow() public {
        _registerAndApproveUser(producer_address, SupplyChain.UserRole.Producer);
        _registerAndApproveUser(factory_address, SupplyChain.UserRole.Factory);
        _registerAndApproveUser(retailer_address, SupplyChain.UserRole.Retailer);
        _registerAndApproveUser(consumer_address, SupplyChain.UserRole.Consumer);
        
        // 1. Producer creates raw material
        vm.prank(producer_address);
        supplyChain.createToken("RawWood", SupplyChain.TokenType.RowMaterial, 1000, "Oak wood from sustainable forest", 0);
        
        // 2. Producer → Factory transfer
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 100);
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // 3. Factory creates finished product with traceability
        vm.prank(factory_address);
        supplyChain.createToken("OakChair", SupplyChain.TokenType.FinishedProduct, 25, "Handcrafted oak chair, batch #001", 1);
        
        // 4. Factory → Retailer transfer
        vm.prank(factory_address);
        supplyChain.transfer(retailer_address, 2, 20);
        vm.prank(retailer_address);
        supplyChain.acceptTransfer(2);
        
        // 5. Retailer → Consumer transfer
        vm.prank(retailer_address);
        supplyChain.transfer(consumer_address, 2, 1);
        vm.prank(consumer_address);
        supplyChain.acceptTransfer(3);
        
        // 6. Verify full traceability
        (uint256 id, address creator, string memory name, SupplyChain.TokenType tokenType, uint256 totalSupply, string memory features, uint256 parentId, uint256 dateCreated) = supplyChain.getToken(2);
        
        assertEq(id, 2, "Product ID should be 2");
        assertEq(creator, factory_address, "Product creator should be factory");
        assertEq(name, "OakChair", "Product name should be OakChair");
        assertEq(uint(tokenType), uint(SupplyChain.TokenType.FinishedProduct), "Should be finished product");
        assertEq(parentId, 1, "Should trace back to raw material token 1");
        
        // Verify raw material traceability
        (uint256 rawId, address rawCreator, string memory rawName, SupplyChain.TokenType rawType, , string memory rawFeatures, uint256 rawParentId, ) = supplyChain.getToken(1);
        
        assertEq(rawId, 1, "Raw material ID should be 1");
        assertEq(rawCreator, producer_address, "Raw material creator should be producer");
        assertEq(rawName, "RawWood", "Raw material name should be RawWood");
        assertEq(uint(rawType), uint(SupplyChain.TokenType.RowMaterial), "Should be raw material");
        assertEq(rawParentId, 0, "Raw material should have no parent");
        
        // Verify consumer received the product
        assertEq(supplyChain.getTokenBalance(2, consumer_address), 1, "Consumer should have 1 chair");
        
        // Verify transfer history
        SupplyChain.Transfer memory transfer1 = supplyChain.getTransfer(1); // Producer → Factory
        SupplyChain.Transfer memory transfer2 = supplyChain.getTransfer(2); // Factory → Retailer  
        SupplyChain.Transfer memory transfer3 = supplyChain.getTransfer(3); // Retailer → Consumer
        
        assertEq(transfer1.from, producer_address, "First transfer from producer");
        assertEq(transfer1.to, factory_address, "First transfer to factory");
        assertEq(transfer2.from, factory_address, "Second transfer from factory");
        assertEq(transfer2.to, retailer_address, "Second transfer to retailer");
        assertEq(transfer3.from, retailer_address, "Third transfer from retailer");
        assertEq(transfer3.to, consumer_address, "Third transfer to consumer");
        
        // All transfers should be accepted
        assertEq(uint(transfer1.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer 1 should be accepted");
        assertEq(uint(transfer2.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer 2 should be accepted");
        assertEq(uint(transfer3.status), uint(SupplyChain.TransferStatus.Accepted), "Transfer 3 should be accepted");
    }
}
// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../../src/pfm/SupplyChain.sol";

/**
 * @title FASE 3 Edge Cases - Branches Dirigidos
 * @notice Tests específicos para cubrir branches no cubiertos y alcanzar 65%+ coverage
 * @dev Edge cases identificados mediante análisis sistemático del código
 */
contract EdgeCasesFase3Test is Test {
    SupplyChain public supplyChain;
    
    address public owner;
    address public producer_address;
    address public factory_address;
    address public retailer_address;
    address public consumer_address;

    function setUp() public {
        owner = address(this);
        producer_address = makeAddr("producer");
        factory_address = makeAddr("factory");
        retailer_address = makeAddr("retailer");
        consumer_address = makeAddr("consumer");
        
        supplyChain = new SupplyChain();
    }

    // ============================================================================
    // 🛠️ HELPER FUNCTIONS
    // ============================================================================

    /// @notice Helper function para setup común de usuarios y token
    function _setupUserAndToken() internal {
        // Registrar y aprobar producer
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
        
        // Registrar y aprobar factory
        vm.prank(factory_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Factory);
        supplyChain.changeStatusUser(factory_address, SupplyChain.UserStatus.Approved);
        
        // Crear token
        vm.prank(producer_address);
        supplyChain.createToken("Test Token", SupplyChain.TokenType.RowMaterial, 1000, "test", 0);
    }

    // ============================================================================
    // 🔑 FASE 3.1: OWNERSHIP TRANSFER EDGE CASES
    // ============================================================================

    /// @notice Edge Case 17: Transfer ownership a address(0)
    /// @dev Branch objetivo: if (newOwner == address(0)) revert InvalidAddress();
    function testTransferOwnershipToZeroAddress() public {
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
        supplyChain.initiateOwnershipTransfer(address(0));
    }

    /// @notice Edge Case 18: Accept ownership sin pending transfer
    /// @dev Branch objetivo: if (msg.sender != pendingOwner) revert Unauthorized();
    function testAcceptOwnershipWithoutPending() public {
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
        vm.prank(producer_address);
        supplyChain.acceptOwnership();
    }

    /// @notice Edge Case 19: Ownership transfer mientras pausado
    /// @dev Branch objetivo: whenNotPaused en initiateOwnershipTransfer
    function testOwnershipTransferWhilePaused() public {
        supplyChain.pause();
        
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
        supplyChain.initiateOwnershipTransfer(producer_address);
    }

    /// @notice Edge Case 19b: Accept ownership mientras pausado
    /// @dev Branch objetivo: whenNotPaused en acceptOwnership
    function testAcceptOwnershipWhilePaused() public {
        // Setup pending ownership
        supplyChain.initiateOwnershipTransfer(producer_address);
        
        // Pause contract
        supplyChain.pause();
        
        // Try to accept while paused
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
        vm.prank(producer_address);
        supplyChain.acceptOwnership();
    }

    // ============================================================================
    // 🔄 FASE 3.2: USER STATUS COMPLEX EDGE CASES  
    // ============================================================================

    /// @notice Edge Case 20: User status transition edge case
    /// @dev Branch objetivo: if (user.status != UserStatus.Pending) user.status = UserStatus.Pending;
    function testUserStatusNotPendingToRoleChange() public {
        // Registrar usuario
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        // Cambiar a Approved
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
        
        // Cambiar a Rejected
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Rejected);
        
        // Verificar que status es Rejected (no Pending)
        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Rejected));
        
        // Cambiar rol - debe pasar por el branch: if (user.status != UserStatus.Pending)
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Factory);
        
        // Verificar que status cambió a Pending
        user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Pending));
        assertEq(uint(user.role), uint(SupplyChain.UserRole.Factory));
    }

    /// @notice Edge Case 21: Role validation boundary testing
    /// @dev Branch objetivo: Validar boundary del role máximo
    function testValidRoleBoundaryConsumer() public {
        // Test role Consumer (3) que es el máximo válido
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Consumer);
        
        assertTrue(supplyChain.addressToUserId(producer_address) != 0);
        
        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.role), uint(SupplyChain.UserRole.Consumer));
    }

    // ============================================================================
    // 📦 FASE 3.3: TOKEN BALANCE EDGE CASES
    // ============================================================================

    /// @notice Edge Case 22: Token balance zero after transfer
    /// @dev Branch objetivo: if (token.balance[transferItem.from] == 0 && userTokenCount[transferItem.from] > 0)
    function testTokenBalanceZeroAfterTransfer() public {
        _setupUserAndToken();
        
        // Transfer todo el balance
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 1000); // All tokens
        
        // Accept transfer
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // Verificar que sender tiene balance 0
        assertEq(supplyChain.getTokenBalance(1, producer_address), 0);
        
        // Verificar que receiver tiene todo
        assertEq(supplyChain.getTokenBalance(1, factory_address), 1000);
    }

    /// @notice Edge Case 23: First token receipt
    /// @dev Branch objetivo: if (token.balance[transferItem.to] == transferItem.amount)
    function testFirstTokenReceipt() public {
        _setupUserAndToken();
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 100);
        
        // Factory inicialmente debería tener 0
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0);
        
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // Después del accept, debería tener exactamente lo transferido
        assertEq(supplyChain.getTokenBalance(1, factory_address), 100);
    }

    // ============================================================================
    // 🔄 FASE 3.4: TRANSFER STATUS COMPLEX SCENARIOS
    // ============================================================================

    /// @notice Edge Case 24: Cancel transfer sender balance restoration
    /// @dev Branch objetivo: balance restoration logic en cancelTransfer
    function testCancelTransferSenderBalanceRestoration() public {
        _setupUserAndToken();
        
        uint256 initialBalance = supplyChain.getTokenBalance(1, producer_address);
        
        // Transfer parcial
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 100);
        
        // Verificar que balance se redujo
        assertEq(supplyChain.getTokenBalance(1, producer_address), initialBalance - 100);
        
        // Cancel transfer - debería restaurar balance
        vm.prank(producer_address); 
        supplyChain.cancelTransfer(1);
        
        // Verificar que balance se restauró
        assertEq(supplyChain.getTokenBalance(1, producer_address), initialBalance);
    }

    /// @notice Edge Case 25: Reject transfer balance logic
    /// @dev Branch objetivo: balance restoration en rejectTransfer
    function testRejectTransferBalanceLogic() public {
        _setupUserAndToken();
        
        uint256 initialBalance = supplyChain.getTokenBalance(1, producer_address);
        
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 100);
        
        // Verificar balance reducido
        assertEq(supplyChain.getTokenBalance(1, producer_address), initialBalance - 100);
        
        // Reject as receiver
        vm.prank(factory_address);
        supplyChain.rejectTransfer(1);
        
        // Verificar que balance se restauró al sender
        assertEq(supplyChain.getTokenBalance(1, producer_address), initialBalance);
        assertEq(supplyChain.getTokenBalance(1, factory_address), 0);
    }

    // ============================================================================
    // 📋 FASE 3.5: ARRAY FILTERING EDGE CASES
    // ============================================================================

    /// @notice Edge Case 26: getUserTokens con balance zero
    /// @dev Branch objetivo: if (tokens[i].balance[userAddress] > 0) filtering logic
    function testGetUserTokensWithZeroBalance() public {
        _setupUserAndToken();
        
        // Crear un segundo token
        vm.prank(producer_address);
        supplyChain.createToken("Second Token", SupplyChain.TokenType.FinishedProduct, 500, "second", 0);
        
        // Transfer todo el primer token
        vm.prank(producer_address);
        supplyChain.transfer(factory_address, 1, 1000);
        
        vm.prank(factory_address);
        supplyChain.acceptTransfer(1);
        
        // Producer debería tener solo el segundo token
        uint256[] memory tokens = supplyChain.getUserTokens(producer_address);
        assertEq(tokens.length, 1);
        assertEq(tokens[0], 2); // Solo el segundo token
        
        // Factory debería tener el primer token
        uint256[] memory factoryTokens = supplyChain.getUserTokens(factory_address);
        assertEq(factoryTokens.length, 1);
        assertEq(factoryTokens[0], 1);
    }
}
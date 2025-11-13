// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import "forge-std/Test.sol";
import "../../src/pfm/SupplyChain.sol";

/**
 * @title Edge Cases Test Suite for SupplyChain (LIMPIO)
 * @notice Tests únicos específicos para mejorar branch coverage
 * @dev Solo edge cases NO duplicados de SupplyChain.t.sol
 */
contract EdgeCasesTest is Test {
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
    // 🔴 EDGE CASES ÚNICOS (NO DUPLICADOS)
    // ============================================================================

    /// @notice Edge Case 1: Owner intenta registrarse como usuario
    /// @dev Cubre branch: if (owner == msg.sender) revert InvalidAddress();
    function testOwnerCannotRegisterAsUser() public {
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
    }

    /// @notice Edge Case 2: Uso de rol Consumer (máximo válido)
    /// @dev Test que funciona - usar rol Consumer (3) que es el máximo válido
    function testValidRoleMax() public {
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Consumer);
        
        // Verificar que se registró correctamente
        assertTrue(supplyChain.addressToUserId(producer_address) != 0);
    }

    /// @notice Edge Case 3: Usuario ya approved intenta re-registrarse
    /// @dev Cubre branch: if (user.status == UserStatus.Approved) revert ExistingUserWithApprovedRole();
    function testApprovedUserCannotReregister() public {
        // Registrar usuario
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        // Aprobar usuario
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
        
        // Intentar registrarse de nuevo (debe fallar)
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.ExistingUserWithApprovedRole.selector));
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Factory);
    }

    /// @notice Edge Case 4: Usuario con mismo rol intenta re-registrarse
    /// @dev Cubre branch: if (uint(role) == uint(user.role)) revert UserWithExistingRole();
    function testSameRoleReregistration() public {
        // Registrar usuario
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        
        // Intentar registrarse con el mismo rol
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.UserWithExistingRole.selector));
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
    }

    /// @notice Edge Case 5: Crear token con nombre vacío
    /// @dev Cubre branch: if (bytes(name).length == 0) revert InvalidName();
    function testCreateTokenEmptyName() public {
        _setupUserAndToken();
        
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidName.selector));
        vm.prank(producer_address);
        supplyChain.createToken("", SupplyChain.TokenType.RowMaterial, 1000, "", 0);
    }

    /// @notice Edge Case 6: Crear token con supply cero
    /// @dev Cubre branch: if (totalSupply == 0) revert InvalidTotalSupply();
    function testCreateTokenZeroSupply() public {
        _setupUserAndToken();
        
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidTotalSupply.selector));
        vm.prank(producer_address);
        supplyChain.createToken("Test", SupplyChain.TokenType.RowMaterial, 0, "", 0);
    }

    /// @notice Edge Case 7: Crear token con parent inexistente
    /// @dev Cubre branch: if (parentId != 0 && parentId >= nextTokenId) revert ParentTokenDoesNotExist();
    function testCreateTokenInvalidParent() public {
        _setupUserAndToken();
        
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.ParentTokenDoesNotExist.selector));
        vm.prank(producer_address);
        supplyChain.createToken("Child", SupplyChain.TokenType.FinishedProduct, 100, "", 999);
    }

    /// @notice Edge Case 8: Owner intenta crear token
    /// @dev Cubre branch: validación de usuario aprobado en createToken
    function testOwnerCannotCreateToken() public {
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.Unauthorized.selector));
        supplyChain.createToken("Test", SupplyChain.TokenType.RowMaterial, 1000, "", 0);
    }

    /// @notice Edge Case 9: Transfer a address(0)
    /// @dev Cubre branch: if (to == address(0)) revert InvalidAddress();
    function testTransferToZeroAddress() public {
        _setupUserAndToken();
        
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.InvalidAddress.selector));
        vm.prank(producer_address);
        supplyChain.transfer(address(0), 1, 10);
    }

    /// @notice Edge Case 10: ÚNICO de FASE 2 - Operations fail when paused
    /// @dev Cubre branch: whenNotPaused en requestUserRole
    function testOperationsFailWhenPaused() public {
        // Pausar contrato
        supplyChain.pause();
        
        // Intentar registrar usuario durante pausa
        vm.expectRevert(abi.encodeWithSelector(SupplyChain.ContractPaused.selector));
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
    }

    // ============================================================================
    // 📊 TESTS DE COVERAGE VERIFICATION
    // ============================================================================

    /// @notice Helper test para verificar setup
    function testSetupFunctions() public {
        _setupUserAndToken();
        
        // Verificar que setup funcionó correctamente
        assertTrue(supplyChain.addressToUserId(producer_address) != 0);
        assertTrue(supplyChain.addressToUserId(factory_address) != 0);
    }

    /// @notice Test que verifica múltiples branches en una sola función
    function testMultipleBranches() public {
        // Branch 1: Usuario no registrado
        assertEq(supplyChain.addressToUserId(producer_address), 0);
        
        // Branch 2: Usuario registrado
        vm.prank(producer_address);
        supplyChain.requestUserRole(SupplyChain.UserRole.Producer);
        assertTrue(supplyChain.addressToUserId(producer_address) != 0);
        
        // Branch 3: Usuario aprobado
        supplyChain.changeStatusUser(producer_address, SupplyChain.UserStatus.Approved);
        SupplyChain.User memory user = supplyChain.getUserInfo(producer_address);
        assertEq(uint(user.status), uint(SupplyChain.UserStatus.Approved));
    }
}
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "forge-std/Test.sol";
import { eCommerce } from "../../src/ethereum_as_db/e-commerce.sol";

contract EcommerceTest is Test {
    eCommerce internal ecommerce;
    address internal empresaOwner = address(0xA11CE);
    address internal cliente = address(0xB0B);

    function setUp() public {
        vm.startPrank(empresaOwner);
        ecommerce = new eCommerce();
        ecommerce.empresaCrear(empresaOwner, "Tienda");
        vm.stopPrank();
    }

    function testCrearProductoAutoIdYExistsYListadoYEliminar() public {
        vm.startPrank(empresaOwner);
        uint256 id = ecommerce.productoCrear(empresaOwner, "NFT Gato", 1000, bytes32(0));
        assertEq(id, 1);
        assertTrue(ecommerce.productoExiste(empresaOwner, id));

        (string memory nombre, uint256 precio, bytes32 imagen, bool existe) = ecommerce.productoObtener(empresaOwner, id);
        assertEq(nombre, "NFT Gato");
        assertEq(precio, 1000);
        assertEq(uint256(imagen), 0);
        assertTrue(existe);

        uint256[] memory ids = ecommerce.productosListarIds(empresaOwner);
        assertEq(ids.length, 1);
        assertEq(ids[0], 1);

        ecommerce.productoEliminar(empresaOwner, id);
        assertFalse(ecommerce.productoExiste(empresaOwner, id));
        uint256[] memory idsAfter = ecommerce.productosListarIds(empresaOwner);
        assertEq(idsAfter.length, 0);
        vm.stopPrank();
    }

    function testCrearFacturaAutoIdYExistsYListadoYEliminar() public {
        vm.startPrank(empresaOwner);
        uint256 idF = ecommerce.facturaCrear(empresaOwner, cliente, 1234);
        assertEq(idF, 1);
        assertTrue(ecommerce.facturaExiste(empresaOwner, idF));

        (uint64 fecha, address cli, uint256 importe, bool existe) = ecommerce.facturaObtener(empresaOwner, idF);
        assertEq(cli, cliente);
        assertEq(importe, 1234);
        assertTrue(existe);
        assertGt(fecha, 0);

        uint256[] memory fids = ecommerce.facturasListarIds(empresaOwner);
        assertEq(fids.length, 1);
        assertEq(fids[0], 1);

        ecommerce.facturaEliminar(empresaOwner, idF);
        assertFalse(ecommerce.facturaExiste(empresaOwner, idF));
        uint256[] memory fidsAfter = ecommerce.facturasListarIds(empresaOwner);
        assertEq(fidsAfter.length, 0);
        vm.stopPrank();
    }

    function testSoloOwnerPuedeAdministrar() public {
        vm.prank(address(0xDEAD));
        vm.expectRevert(eCommerce.NoAutorizado.selector);
        ecommerce.productoCrear(empresaOwner, "X", 1, bytes32(0));
    }
}



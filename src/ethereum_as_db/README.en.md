# E-Commerce Smart Contract

## Overview

This contract, `eCommerce.sol`, simulates an e-commerce platform on the blockchain, serving as an advanced educational project. It demonstrates how to structure a multi-entity system (companies, products, invoices) securely and efficiently in Solidity.

The current contract has been refactored to include best practices for smart contract development, such as a robust access control model, custom errors, automatic ID generation, and a clear and consistent API written in Spanish.

## Key Features

- **Dual Ownership Model**: A global `propietarioContracto` (contract owner) and an `adminEmpresa` (company admin) for each company.
- **Modifier-Based Access Control**: Use of `soloPropierarioContracto` and `soloAdminEmpresa`.
- **Advanced Data Structures**: `structs` for `Empresa`, `Producto`, `Factura` and `enums` to manage their states (`Activa`, `Anulada`, etc.).
- **Input Validation & Custom Errors**: Gas-efficient and descriptive error handling (e.g., `NoAutorizado`, `ProductoExistente`).
- **Auto-Incrementing IDs**: Per-company counters to generate unique IDs for products and invoices.
- **Logical Deletion (Soft Deletes)**: Data is marked as inactive to preserve history instead of being deleted.
- **Efficient Lookups (O(1))**: Indexing mappings allow for fast searches and deletions.

## Solidity Concepts Demonstrated

- **Structs and Enums (`struct`, `enum`)**: To define complex data entities and their states.
- **Nested Mappings**: To create hierarchical relationships (company -> products).
- **Advanced Access Control**: Using `modifiers` and a dual ownership model.
- **Custom Errors**: `error` for efficient failure reporting.
- **Events (`event`)**: To notify external applications about state changes.
- **Indexing Patterns**: Mappings that act as indexes for efficient lookups and deletions (`O(1)`).
- **Memory Management**: Use of `storage`, `memory`, and `calldata` to optimize gas.

## Contract Structure

### Data Structures (`structs`)
- `Empresa`: Stores a company's name, administrator (`adminEmpresa`), status, and ID counters. **Its counters are now `uint128` to save space.**
- `Producto`: Contains item details (`nombre`, `precio`, `imagen` as `bytes32`) and its status. **Its fields are optimally packed given their types; `precio` (uint256) and `imagen` (bytes32) each occupy a full slot, while `existeProducto` (bool) and `estatus` (enum) are packed together in a third slot.**
- `Factura`: Saves sale information (`fecha`, `direccionCliente`, `importeTotal`) and its status.**Its fields have been reordered and `fecha` adjusted to `uint64` to optimize storage.**

### Data Storage and Mapping Examples

#### 1. `mapping(address => Empresa) private empresas;`
Associates a wallet address with a complete `Empresa` struct.
- **Purpose**: To store all of a company's information, using its address as an identifier.
- **JSON-like Visualization**:
  ```json
  {
    "0xAb...cb2": {
      "nombre": "Crypto Store",
      "adminEmpresa": "0xAb...cb2",
      "contadorProductos": 2,
      "contadorFacturas": 1,
      "existeEmpresa": true,
      "estatus": 0 
    }
  }
  ```

#### 2. `mapping(address => mapping(uint256 => Producto)) private productos;`
A nested mapping where a company address maps to its product catalog.
- **Purpose**: To allow each company to have its own isolated product catalog.
- **JSON-like Visualization**:
  ```json
  {
    "0xAb...cb2": {
      "1": {
        "nombre": "Cat NFT",
        "precio": 1000,
        "imagen": "0x1a2b3c...",
        "existeProducto": true,
        "estatus": 0 
      }
    }
  }
  ```

#### 3. `mapping(address => mapping(uint256 => Factura)) private facturas;`
- **Purpose**: To give each company its own invoice ledger.
- **JSON-like Visualization**:
  ```json
  {
    "0xAb...cb2": {
      "101": {
        "fecha": 1678886400,
        "direccionCliente": "0x5B...dC4",
        "importeTotal": 1000,
        "existeFactura": true,
        "estatus": 0 
      }
    }
  }
  ```

#### 4. `mapping(address => mapping(address => uint256)) private comprasPorCliente;`
- **Purpose**: To allow each company to track how many purchases each customer has made.
- **JSON-like Visualization**:
  ```json
  {
    "0xAb...cb2": {
      "0x5B...dC4": 1,
      "0x78...aB": 5
    }
  }
  ```

## Contract API (Main Functions)

### Company Management
- `empresaCrear(address, string)`
- `empresaObtenerInformacion(address)`: Returns counters as `uint128`.
- `empresaActualizaNombre(address, string)`
- `empresaActualizaEstatus(address, EstatusEmpresa)`

### Product Management
- `productoCrear(address, string, uint256, bytes32)`
- `productoActualizar(address, uint256, string, uint256, bytes32)`
- `productoEliminar(address, uint256)`
- `productoObtener(address, uint256)`

### Invoice Management
- `facturaCrear(address, address, uint256)`
- `facturaEliminar(address, uint256)`
- `facturaRestaurar(address, uint256)`
- `facturaObtener(address, uint256)`: Returns `fecha` as `uint64`.

## How to Use
1.  **Deploy**: The deploying address becomes the `propietarioContracto`.
2.  **Register Company**: The `propietarioContracto` calls `empresaCrear`.
3.  **Add Products**: The respective `adminEmpresa` calls `productoCrear`.
4.  **Record Sale**: The `adminEmpresa` calls `facturaCrear`.

### Usage Example (Solidity)
```solidity
// Assuming `contrato` is an instance of `eCommerce`
address adminTienda = 0x...; 

// 1. The contract owner registers a new company
contrato.empresaCrear(adminTienda, "My Web3 Store");

// 2. The store admin adds a product
// (this call must be made by `adminTienda`)
bytes32 imagenHash = 0x...; // 32-byte hash of the image
contrato.productoCrear(adminTienda, "Loyalty Token", 100, imagenHash);

// 3. The admin records an invoice
address cliente = 0x...;
contrato.facturaCrear(adminTienda, cliente, 100);
```
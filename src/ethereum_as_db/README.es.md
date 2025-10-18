# Contrato Inteligente de E-Commerce

## Descripción General

Este contrato, `eCommerce.sol`, simula una plataforma de comercio electrónico sobre la blockchain, sirviendo como un proyecto educativo avanzado. Demuestra cómo estructurar un sistema multi-entidad (empresas, productos, facturas) de manera segura y eficiente en Solidity.

El contrato actual ha sido refactorizado para incluir las mejores prácticas de desarrollo de smart contracts, como un modelo de control de acceso robusto, errores personalizados, generación de IDs automáticos y una API de funciones clara y consistente en español.

## Características Principales

- **Modelo de Propiedad Dual**: Un `propietarioContracto` global y un `adminEmpresa` para cada empresa.
- **Control de Acceso por Modificadores**: Uso de `soloPropierarioContracto` y `soloAdminEmpresa`.
- **Estructuras de Datos y Estados**: `structs` para `Empresa`, `Producto`, `Factura` y `enums` para gestionar sus estados (`Activa`, `Anulada`, etc.).
- **Validación y Errores Personalizados**: Manejo de fallos eficiente y descriptivo (ej. `NoAutorizado`, `ProductoExistente`).
- **IDs Autoincrementales**: Contadores por empresa para generar IDs únicos de productos y facturas.
- **Eliminación Lógica (Soft Deletes)**: Los datos no se borran, sino que se marcan como inactivos para preservar el historial.
- **Búsquedas Eficientes (O(1))**: Mapeos adicionales que actúan como índices para búsquedas y eliminaciones rápidas.

## Conceptos de Solidity Demostrados

- **Estructuras y Enumeraciones (`struct`, `enum`)**: Para definir entidades de datos complejas y sus estados.
- **Mappings Anidados**: Para crear relaciones jerárquicas (empresa -> productos).
- **Control de Acceso Avanzado**: Con `modifiers` y un modelo de propiedad dual.
- **Errores Personalizados**: `error` para un manejo de fallos eficiente.
- **Eventos (`event`)**: Para notificar a aplicaciones externas sobre cambios en el contrato.
- **Patrones de Indexación**: Mappings que funcionan como índices para búsquedas y eliminaciones eficientes (`O(1)`).
- **Gestión de Memoria**: Uso de `storage`, `memory` y `calldata` para optimizar gas.

## Estructura del Contrato

### Estructuras de Datos (`structs`)
- `Empresa`: Almacena los datos de una empresa. **Sus contadores ahora son `uint128` para ahorrar espacio.**
- `Producto`: Contiene los detalles de un artículo (`nombre`, `precio`, `imagen` como `bytes32`) y su estado. **Sus campos están óptimamente empaquetados dadas sus definiciones de tipo; `precio` (uint256) e `imagen` (bytes32) ocupan cada uno un slot completo, mientras que `existeProducto` (bool) y `estatus` (enum) se empaquetan juntos en un tercer slot.**
- `Factura`: Guarda la información de una venta. **Sus campos han sido reorganizados y `fecha` ajustado a `uint64` para optimizar el almacenamiento.**

### Almacenamiento de Datos y Ejemplos de Mappings

#### 1. `mapping(address => Empresa) private empresas;`
Asocia la dirección de una billetera con una estructura `Empresa` completa.
- **Propósito**: Guardar toda la información de una empresa, usando su dirección como identificador.
- **Visualización como JSON**:
  ```json
  {
    "0xAb...cb2": {
      "nombre": "Tienda Cripto",
      "adminEmpresa": "0xAb...cb2",
      "contadorProductos": 2,
      "contadorFacturas": 1,
      "existeEmpresa": true,
      "estatus": 0 
    }
  }
  ```

#### 2. `mapping(address => mapping(uint256 => Producto)) private productos;`
Un **mapping anidado** donde una dirección de empresa mapea a su catálogo de productos.
- **Propósito**: Permitir que cada empresa tenga su propio catálogo de productos aislado.
- **Visualización como JSON**:
  ```json
  {
    "0xAb...cb2": {
      "1": {
        "nombre": "NFT Gato",
        "precio": 1000,
        "imagen": "0x1a2b3c...",
        "existeProducto": true,
        "estatus": 0 
      }
    }
  }
  ```

#### 3. `mapping(address => mapping(uint256 => Factura)) private facturas;`
Idéntico al de productos, pero para registrar ventas.
- **Propósito**: Dar a cada empresa su propio libro de contabilidad de facturas.
- **Visualización como JSON**:
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
- **Propósito**: Permitir a cada empresa saber cuántas compras ha realizado cada cliente.
- **Visualización como JSON**:
  ```json
  {
    "0xAb...cb2": {
      "0x5B...dC4": 1,
      "0x78...aB": 5
    }
  }
  ```

## API del Contrato (Funciones Principales)

### Gestión de Empresa
- `empresaCrear(address, string)`
- `empresaObtenerInformacion(address)`: Devuelve contadores como `uint128`.
- `empresaActualizaNombre(address, string)`
- `empresaActualizaEstatus(address, EstatusEmpresa)`

### Gestión de Productos
- `productoCrear(address, string, uint256, bytes32)`: Crea un producto con ID automático.
- `productoActualizar(address, uint256, string, uint256, bytes32)`: Actualiza un producto.
- `productoEliminar(address, uint256)`: Desactiva un producto (soft delete).
- `productoObtener(address, uint256)`: Devuelve los detalles de un producto, incluyendo la imagen como `bytes32`.

### Gestión de Facturas
- `facturaCrear(address, address, uint256)`: Recibe `importeTotal` como `uint256`.
- `facturaEliminar(address, uint256)`
- `facturaRestaurar(address, uint256)`
- `facturaObtener(address, uint256)`: Devuelve `fecha` como `uint64` e `importeTotal` como `uint256`.

## Cómo Usar
1.  **Desplegar**: La dirección que despliega es el `propietarioContracto`.
2.  **Registrar Empresa**: El `propietarioContracto` llama a `empresaCrear`.
3.  **Añadir Productos**: El `adminEmpresa` llama a `productoCrear`.
4.  **Registrar Venta**: El `adminEmpresa` llama a `facturaCrear`.

### Ejemplo de Uso (Solidity)
```solidity
// Asumimos que `contrato` es una instancia de `eCommerce`
address adminTienda = 0x...; 

// 1. El propietario del contrato registra una nueva empresa
contrato.empresaCrear(adminTienda, "Mi Tienda Web3");

// 2. El administrador de la tienda añade un producto
// (esta llamada debe ser hecha por `adminTienda`)
bytes32 imagenHash = 0x...; // Hash de 32 bytes de la imagen
contrato.productoCrear(adminTienda, "Token de Lealtad", 100, imagenHash);

// 3. El administrador registra una factura
address cliente = 0x...;
contrato.facturaCrear(adminTienda, cliente, 100);
```
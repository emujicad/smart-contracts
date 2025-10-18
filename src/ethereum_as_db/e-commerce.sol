// SPDX-License-Identifier: GPL-3.0

// Define la versión del compilador de Solidity a utilizar.
// En este caso, es compatible con versiones desde 0.8.2 hasta antes de 0.9.0.
pragma solidity >=0.8.2 <0.9.0;

/**
 * @title eCommerce
 * @notice Plataforma eCommerce para uso educativo: modelo de empresas, productos y facturas.
 * @notice Este contrato inteligente simula una plataforma de comercio electrónico básica en la blockchain.
 * @dev Incluye control de acceso por empresa, validaciones, errores personalizados, contadores para IDs automáticos,
 *      eventos para la comunicación con el exterior y funciones de consulta (getters) completas.
 * @dev IMPORTANTE: Este contrato no maneja transferencias de fondos (criptomonedas), solo registra datos.
 *      Está diseñado con fines educativos para mostrar cómo se pueden anidar mappings y estructurar
 *      datos complejos en Solidity, una práctica común para simular bases de datos en la blockchain.
 */
contract eCommerce {
    // --- Errores Personalizados ---
    // Los errores personalizados son una forma moderna y más eficiente (en consumo de gas) de
    // gestionar y reportar fallos en las transacciones, en lugar de usar `require("mensaje de error")`.
    error NoAutorizado(); // Se emite cuando una dirección no autorizada intenta ejecutar una función protegida.
    error EntradaInvalida(string campo); // Para entradas de datos no válidas, como un nombre o precio vacíos.

    error EmpresaExistente(address direccionEmpresa); // Si se intenta registrar una empresa con una dirección que ya existe.
    error EmpresNoActiva(address direccionEmpresa); // Si se intenta operar con una empresa que está deshabilitada.
    error EmpresaNoEncontrada(address direccionEmpresa); // Si la empresa consultada no existe.

    error ProductoNoEncontrado(uint256 id); // Si el producto consultado no existe.
    error ProductoExistente(uint256 idProductoExistente); // Si se intenta crear un producto con un nombre que ya existe en la misma empresa.
    error IdProductoExiste(uint256 id); // Si se intenta crear un producto con un ID manual que ya está en uso.
    error PrecioProductoDebeSerPositivo(uint256 precio); // El precio de un producto no puede ser cero.

    error IdFacturaExiste(uint256 id); // Si se intenta crear una factura con un ID manual que ya está en uso.
    error FacturaNoEncontrada(uint256 id); // Si la factura consultada no existe.

    // --- Estructuras de Datos (Structs) ---
    // Las estructuras permiten definir tipos de datos complejos y personalizados, agrupando variables.

    // Un `enum` (enumerador) define un tipo con un conjunto de constantes predefinidas.
    // Aquí se usa para representar los posibles estados de una empresa de forma legible.
    enum EstatusEmpresa {
        Activa,         // Valor 0
        Deshabilitada   // Valor 1
    }

    // Define la estructura para almacenar la información de una Empresa.
    struct Empresa {
        string nombre;              // Nombre comercial de la empresa.
        uint128 contadorProductos;  // Contador para generar IDs únicos para los productos de esta empresa.
        uint128 contadorFacturas;   // Contador para generar IDs únicos para las facturas de esta empresa.
        address adminEmpresa;       // Dirección del administrador de la empresa.
        bool existeEmpresa;         // Bandera (flag) para verificar si la empresa ha sido registrada.
        EstatusEmpresa estatus;     // Estado actual de la empresa (Activa/Deshabilitada).
    }

    // Enum para los posibles estados de un producto.
    enum EstatusProducto {
        Activo,         // Valor 0
        Deshabilitado   // Valor 1
    }

    /**
     * @notice Define la estructura de un Producto.
     * @param nombre El nombre del producto.
     * @param precio El precio del producto en la unidad más pequeña de la criptomoneda (ej. wei para Ether).
     * @param imagen Hash de 32 bytes de la imagen del producto (ej. de un CID de IPFS).
     */
    struct Producto {
        string nombre;                // Nombre del producto.
        uint256 precio;             // Precio (se asume en la unidad más pequeña, como wei).
        bytes32 imagen;              // Hash de 32 bytes del contenido de la imagen (ej. IPFS).
        bool existeProducto;        // Bandera para saber si el producto existe (incluso si está deshabilitado).
        EstatusProducto estatus;    // Estado actual del producto (Activo/Deshabilitado).
    }

    // Enum para los posibles estados de una factura.
    enum EstatusFactura {
        Activa,     // Valor 0
        Anulada     // Valor 1
    }

    /**
     * @notice Define la estructura de una Factura.
     * @param fecha La marca de tiempo (timestamp) de cuándo se creó la factura.
     * @param direccionCliente La dirección de la billetera del cliente que realizó la compra.
     */
    struct Factura {
        uint256 importeTotal;       // Monto total de la factura.
        uint64 fecha;              // Timestamp (momento de la creación, obtenido de `block.timestamp`).
        address direccionCliente;   // Dirección de la billetera del cliente.
        bool existeFactura;         // Bandera para saber si la factura existe (para mantener el historial).
        EstatusFactura estatus;     // Estado actual de la factura (Activa o Anulada).
    }

    // --- Almacenamiento (Storage) ---
    // --- VARIABLES DE ESTADO (MAPPINGS) ---
    // Estas variables persisten en la blockchain. Los mappings son tablas hash clave-valor.

    /**
     * @notice Almacena todas las empresas registradas.
     * @dev `mapping(address => Empresa)`: Asocia una dirección de billetera (la clave)
     *      con la estructura de datos `Empresa` (el valor). Es `private` para controlar el acceso.
     */
    mapping(address => Empresa) private empresas;

    /**
     * @notice Almacena los productos de cada empresa.
     * @dev Mapping anidado: `direccion de empresa => (id de producto => struct Producto)`.
     *      La primera clave es la dirección de la empresa. El valor es otro mapping donde
     *      la clave es el ID del producto y el valor es el `Producto`.
     *      Esto permite que cada empresa tenga su propio catálogo de productos aislado.
     */
    // El acceso por ID a un mapping es en tiempo constante O(1), lo que es muy eficiente.
    mapping(address => mapping(uint256 => Producto)) private productos;

    // --- Índices para Búsquedas y Listados Eficientes ---
    // Guardar arrays de IDs permite listar elementos sin tener que iterar sobre todo el mapping (lo cual es muy costoso).
    mapping(address => uint256[]) private IdsProductosActivos; // Guarda solo los IDs de productos activos por empresa.
    // Mapa para obtener el índice de un producto en el array de activos, usando su ID.
    mapping(address => mapping(uint256 => uint256)) private idProductoAIndiceActivo; // Permite encontrar y eliminar un ID del array de activos en tiempo O(1).
    mapping(address => uint256[]) private IdsTodosLosProductos; // Histórico completo de IDs de productos por empresa (incluye activos y eliminados).
    // Mapa para obtener el ID de un producto a partir del hash de su nombre.
    mapping(address => mapping(bytes32 => uint256)) private idProductoPorHashNombre; // Índice para buscar un producto por su nombre (hasheado) y evitar duplicados. La búsqueda es O(1).

    /*
    // El siguiente código para manejar strings en minúsculas se deja comentado porque
    // realizar estas operaciones en la blockchain consume mucho gas.
    // Es una mejor práctica que la aplicación cliente (dApp) se encargue de normalizar los strings.
    function _toLower(string memory s) internal pure returns (string memory) { ... }
    function _equalsIgnoreCase(string memory a, string memory b) internal pure returns (bool) { ... }
    */

    /**
     * @notice Almacena las facturas de cada empresa.
     * @dev Mapping anidado similar al de productos, pero para facturas.
     */
    mapping(address => mapping(uint256 => Factura)) private facturas;

    // Índices para facturas, con la misma lógica que los de productos para optimizar listados y eliminaciones.
    mapping(address => uint256[]) private facturasActivasIds;
    // Mapa para obtener el índice de una factura en el array de activas, usando su ID.
    mapping(address => mapping(uint256 => uint256)) private idFacturaAIndiceActivo;
    mapping(address => uint256[]) private facturaIdsTodas;

    /**
     * @notice Rastrea el número total de compras de un cliente en una empresa.
     * @dev Mapping anidado: `direccion de empresa => (direccion de cliente => totalCompras)`.
     */
    mapping(address => mapping(address => uint256)) private comprasPorCliente;

    // Dirección del propietario del contrato. Esta persona tiene permisos especiales.
    address private propietarioContracto;

    // --- Eventos ---
    // Los eventos son una forma de que el contrato se comunique con el mundo exterior (aplicaciones, UIs).
    // Emiten logs que pueden ser escuchados para reaccionar a cambios en el contrato.
    // `indexed` permite filtrar eventos por los parámetros marcados.
    event asignaPropietarioContrato(address indexed anteriorPropietarioContrato, address indexed nuevoPropietarioContrato);
    event EmpresaCreada(address indexed direccionEmpresa, address indexed propietarioContracto, string nombre);
    event EmpresaActualizada(address indexed direccionEmpresa, string nombre, EstatusEmpresa estatus);
    event ProductoCreado(address indexed direccionEmpresa, uint256 indexed idProducto, string nombre, uint256 precio);
    event ProductoActualizado(address indexed direccionEmpresa, uint256 indexed idProducto, string nombre, uint256 precio);
    event ProductoEliminado(address indexed direccionEmpresa, uint256 indexed idProducto);
    event FacturaCreada(address indexed direccionEmpresa, uint256 indexed idFactura, address indexed direccionCliente, uint256 importeTotal);
    event FacturaAnulada(address indexed direccionEmpresa, uint256 indexed idFactura);
    event FacturaRestaurada(address indexed direccionEmpresa, uint256 indexed idFactura);

    /**
     * @notice El constructor es una función especial que se ejecuta solo una vez, cuando el contrato es desplegado.
     * @dev Aquí se asigna la dirección que despliega el contrato (`msg.sender`) como el `propietarioContracto`.
     */
    constructor() {
        propietarioContracto = msg.sender;
        emit asignaPropietarioContrato(address(0), propietarioContracto);
    }

    // --- Modificadores (Modifiers) ---
    // Los modificadores son código reutilizable que se puede añadir a las funciones para
    // verificar condiciones (permisos, estados, etc.) antes de que se ejecuten.

    /**
     * @dev Verifica que quien llama a la función (`msg.sender`) es el administrador de la empresa
     *      o el propietario del contrato. Si no, revierte la transacción.
     */
    modifier soloAdminEmpresa(address _direccionEmpresa) {
        if (propietarioContracto != msg.sender && empresas[_direccionEmpresa].adminEmpresa != msg.sender) {
            revert NoAutorizado();
        }
        _; // Este símbolo especial indica que se debe ejecutar el cuerpo de la función que usa el modificador.
    }

    /**
     * @dev Verifica que quien llama a la función es el propietario del contrato.
     */
    modifier soloPropierarioContracto() {
        if (propietarioContracto != msg.sender) revert NoAutorizado();
        _;
    }

    /**
     * @dev Verifica que la empresa esté activa antes de permitir una operación.
     */
    modifier empresaActiva(address _direccionEmpresa) {
        if (empresas[_direccionEmpresa].estatus != EstatusEmpresa.Activa) {
            revert EmpresNoActiva(_direccionEmpresa);
        }
        _;
    }

    // --- Gestión de Empresas ---

    /**
     * @notice Registra una nueva empresa en la plataforma. Solo el propietario del contrato puede hacerlo.
     * @param _direccionEmpresa La dirección de la billetera que administrará la empresa.
     * @param _nombreEmpresa El nombre comercial de la empresa (no puede ser vacío).
     */
    function empresaCrear(address _direccionEmpresa, string calldata _nombreEmpresa)
        external
        soloPropierarioContracto
    {
        if (bytes(_nombreEmpresa).length == 0) revert EntradaInvalida("nombre");
        // `storage` crea una referencia a la variable en el almacenamiento de la blockchain.
        // Modificar `e` modifica directamente el estado del contrato.
        Empresa storage e = empresas[_direccionEmpresa];
        if (e.adminEmpresa != address(0)) revert EmpresaExistente(_direccionEmpresa);

        e.nombre = _nombreEmpresa;
        e.adminEmpresa = _direccionEmpresa;
        e.existeEmpresa = true;
        e.estatus = EstatusEmpresa.Activa;
        emit EmpresaCreada(_direccionEmpresa, propietarioContracto, _nombreEmpresa);
    }

    /**
     * @notice Obtiene la información de una empresa a partir de su dirección.
     * @param _direccionEmpresa La dirección de la empresa a consultar.
     * @return nombre El nombre de la empresa.
     * @return adminEmpresa El administrador de la empresa.
     * @return EstatusEmpresa El estado actual de la empresa.
     * @return contadorProductos La cantidad de productos creados por la empresa.
     * @return contadorFacturas La cantidad de facturas creadas por la empresa.
     */
    function empresaObtenerInformacion(address _direccionEmpresa)
        external
        view // `view` indica que la función no modifica el estado del contrato (solo lee datos).
        soloAdminEmpresa(_direccionEmpresa)
        returns (
            string memory nombre,
            address adminEmpresa,
            EstatusEmpresa,
            uint128 contadorProductos,
            uint128 contadorFacturas
        )
    {
        Empresa storage e = empresas[_direccionEmpresa];
        if (e.adminEmpresa == address(0)) {
            revert EmpresaNoEncontrada(_direccionEmpresa);
        }
        return (
            e.nombre,
            e.adminEmpresa,
            e.estatus,
            e.contadorProductos,
            e.contadorFacturas
        );
    }

    /**
     * @notice Cambia el nombre de una empresa.
     * @param _direccionEmpresa La dirección de la empresa a modificar.
     * @param _nombreEmpresa El nuevo nombre para la empresa.
     */
    function empresaActualizaNombre(address _direccionEmpresa, string calldata _nombreEmpresa)
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
    {
        if (bytes(_nombreEmpresa).length == 0) revert EntradaInvalida("nombre");
        empresas[_direccionEmpresa].nombre = _nombreEmpresa;
        emit EmpresaActualizada(
            _direccionEmpresa,
            _nombreEmpresa,
            empresas[_direccionEmpresa].estatus
        );
    }

    /**
     * @notice Activa o Desactiva una empresa.
     * @param _direccionEmpresa La dirección de la empresa a modificar.
     * @param _estatus El nuevo estado para la empresa.
     */
    function empresaActualizaEstatus(address _direccionEmpresa, EstatusEmpresa _estatus)
        external
        soloAdminEmpresa(_direccionEmpresa)
    {
        // Revertir si no hay un cambio real de estado para evitar transacciones inútiles.
        if (empresas[_direccionEmpresa].estatus == _estatus) {
            revert EntradaInvalida("estatus_sin_cambio");
        }
        empresas[_direccionEmpresa].estatus = _estatus;
        emit EmpresaActualizada(
            _direccionEmpresa,
            empresas[_direccionEmpresa].nombre,
            _estatus
        );
    }

    // --- Gestión de Productos ---

    /**
     * @notice Crea o agrega un nuevo producto al catálogo de una empresa con ID autogenerado.
     * @param _direccionEmpresa La dirección de la empresa propietaria del producto.
     * @param _nombreProducto El nombre del producto.
     * @param _precioProducto El precio del producto.
     * @param _imagenProducto // Hash de 32 bytes del contenido de la imagen (ej. IPFS).
     * @return nuevoIdProducto El ID asignado o identificador único para el nuevo producto.
     */
    function productoCrear(
        address _direccionEmpresa,
        string calldata _nombreProducto, // `calldata` es como `memory` pero para parámetros de funciones `external`. Es más eficiente.
        uint256 _precioProducto,
        bytes32 _imagenProducto
    )
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
        returns (uint256 nuevoIdProducto)
    {
        if (bytes(_nombreProducto).length == 0) revert EntradaInvalida("nombre");
        if (_precioProducto == 0) revert PrecioProductoDebeSerPositivo(_precioProducto);

        // Se usa el hash del nombre para verificar unicidad de forma eficiente (O(1)).
        bytes32 hashClaveNombreProducto = keccak256(bytes(_nombreProducto));
        uint256 idExistentePorNombreEmpresa = idProductoPorHashNombre[_direccionEmpresa][hashClaveNombreProducto];
        if (idExistentePorNombreEmpresa != 0) revert ProductoExistente(idExistentePorNombreEmpresa);

        Empresa storage e = empresas[_direccionEmpresa];
        // Usar un contador monótono asegura que los IDs nunca se reutilicen, incluso si se eliminan productos.
        e.contadorProductos += 1;
        nuevoIdProducto = e.contadorProductos; // El primer ID será 1.

        Producto storage p = productos[_direccionEmpresa][nuevoIdProducto];
        p.nombre = _nombreProducto;
        p.precio = _precioProducto;
        p.imagen = _imagenProducto;
        p.existeProducto = true;
        p.estatus = EstatusProducto.Activo;

        // Se actualizan los índices para facilitar listados y búsquedas.
        IdsTodosLosProductos[_direccionEmpresa].push(nuevoIdProducto);
        IdsProductosActivos[_direccionEmpresa].push(nuevoIdProducto);
        idProductoAIndiceActivo[_direccionEmpresa][nuevoIdProducto] = IdsProductosActivos[_direccionEmpresa].length - 1;
        idProductoPorHashNombre[_direccionEmpresa][hashClaveNombreProducto] = nuevoIdProducto;

        emit ProductoCreado(_direccionEmpresa, nuevoIdProducto, _nombreProducto, _precioProducto);
    }

    /**
     * @notice Actualiza un producto existente.
     */
    function productoActualizar(
        address _direccionEmpresa,
        uint256 _idProducto,
        string calldata _nombreProducto,
        uint256 _precioProducto,
        bytes32 _imagenProducto
    )
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
    {
        Producto storage p = productos[_direccionEmpresa][_idProducto];
        if (!p.existeProducto) revert ProductoNoEncontrado(_idProducto);
        if (bytes(_nombreProducto).length == 0) revert EntradaInvalida("nombre");
        if (_precioProducto == 0) revert PrecioProductoDebeSerPositivo(_precioProducto);

        // Lógica para actualizar el índice de nombres y evitar duplicados al cambiar el nombre.
        bytes32 nuevoHashNombreProducto = keccak256(bytes(_nombreProducto));
        uint256 idExistentePorNombreProducto = idProductoPorHashNombre[_direccionEmpresa][nuevoHashNombreProducto];
        if (idExistentePorNombreProducto != 0 && idExistentePorNombreProducto != _idProducto) {
            revert ProductoExistente(idExistentePorNombreProducto);
        }

        // Se borra la clave del nombre anterior si apuntaba a este ID.
        bytes32 anteriorHashNombreProducto = keccak256(bytes(p.nombre));
        if (idProductoPorHashNombre[_direccionEmpresa][anteriorHashNombreProducto] == _idProducto) {
            delete idProductoPorHashNombre[_direccionEmpresa][anteriorHashNombreProducto];
        }

        p.nombre = _nombreProducto;
        p.precio = _precioProducto;
        p.imagen = _imagenProducto;
        idProductoPorHashNombre[_direccionEmpresa][nuevoHashNombreProducto] = _idProducto;
        emit ProductoActualizado(_direccionEmpresa, _idProducto, _nombreProducto, _precioProducto);
    }

    /**
     * @notice “Elimina” lógicamente un producto (lo marca como `existeProducto = false`).
     * @dev Esto es un "soft delete". El producto no se borra de la blockchain, solo se marca
     *      como no existente y se quita de la lista de activos. Esto preserva el historial.
     */
    function productoEliminar(address _direccionEmpresa, uint256 _idProducto)
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
    {
        Producto storage p = productos[_direccionEmpresa][_idProducto];
        if (!p.existeProducto) revert ProductoNoEncontrado(_idProducto);
        p.existeProducto = false;

        // Si estaba activo, se quita del array de activos de forma eficiente (O(1)).
        if (p.estatus == EstatusProducto.Activo) {
            // Técnica de eliminación O(1): mover el último elemento a la posición del que se elimina.
            uint256 indice = idProductoAIndiceActivo[_direccionEmpresa][_idProducto];
            uint256 ultimoIndice = IdsProductosActivos[_direccionEmpresa].length - 1;
            if (indice != ultimoIndice) {
                uint256 ultimoId = IdsProductosActivos[_direccionEmpresa][ultimoIndice];
                IdsProductosActivos[_direccionEmpresa][indice] = ultimoId;
                idProductoAIndiceActivo[_direccionEmpresa][ultimoId] = indice;
            }
            IdsProductosActivos[_direccionEmpresa].pop();
            delete idProductoAIndiceActivo[_direccionEmpresa][_idProducto];
            p.estatus = EstatusProducto.Deshabilitado;
        }

        // Se limpia el índice de nombre si apunta a este ID.
        bytes32 hashClaveNombreProducto = keccak256(bytes(p.nombre));
        if (idProductoPorHashNombre[_direccionEmpresa][hashClaveNombreProducto] == _idProducto) {
            delete idProductoPorHashNombre[_direccionEmpresa][hashClaveNombreProducto];
        }

        emit ProductoEliminado(_direccionEmpresa, _idProducto);
    }

    /**
     * @notice Obtiene los detalles de un producto específico de una empresa.
     * @param _direccionEmpresa La dirección de la empresa.
     * @param _idProducto El ID del producto a consultar.
     * @return nombreProducto El nombre del producto.
     * @return precioProducto El precio del producto.
     * @return imagenProducto El hash de 32 bytes de la imagen del producto.
     * @return existeProducto Indica si el producto existe.
     */
    function productoObtener(address _direccionEmpresa, uint256 _idProducto)
        external
        view
        returns (
            string memory nombreProducto,
            uint256 precioProducto,
            bytes32 imagenProducto,
            bool existeProducto
        )
    {
        Producto storage p = productos[_direccionEmpresa][_idProducto];
        if (!p.existeProducto) revert ProductoNoEncontrado(_idProducto);
        return (p.nombre, p.precio, p.imagen, p.existeProducto);
    }

    /**
     * @notice Devuelve el número total de productos activos (no eliminados) de una empresa.
     */
    function totalProductos(address _direccionEmpresa) external view returns (uint256) {
        return IdsProductosActivos[_direccionEmpresa].length;
    }

    /**
     * @notice Devuelve el último ID emitido para productos de la empresa (no equivale al total de productos activos).
     */
    function productoUltimoId(address _direccionEmpresa) external view returns (uint256) {
        return empresas[_direccionEmpresa].contadorProductos;
    }

    /**
     * @notice Indica si un producto existe (ha sido creado y no eliminado lógicamente).
     */
    function productoExiste(address _direccionEmpresa, uint256 _idProducto) external view returns (bool) {
        return productos[_direccionEmpresa][_idProducto].existeProducto;
    }

    /**
     * @notice Lista todos los IDs de productos activos de una empresa.
     * @dev Puede ser costoso en gas si la lista es muy grande. Usar con precaución.
     */
    function productosListarIds(address _direccionEmpresa) external view returns (uint256[] memory) {
        return IdsProductosActivos[_direccionEmpresa];
    }

    /**
     * @notice Lista paginada de IDs de productos activos.
     * @dev Es la forma recomendada de obtener listas grandes para evitar agotar el gas.
     * @param _inicio El índice desde el cual empezar a listar.
     * @param _limite El número máximo de IDs a devolver.
     */
    function productosActivosListarIds(
        address _direccionEmpresa,
        uint256 _inicio,
        uint256 _limite
    ) external view returns (uint256[] memory) {
        uint256 cantidad = IdsProductosActivos[_direccionEmpresa].length;
        if (_inicio >= cantidad) return new uint256[](0); // Devuelve array vacío si el inicio está fuera de rango.
        uint256 fin = _inicio + _limite;
        if (fin > cantidad) fin = cantidad;
        uint256 longitudListaProductos = fin - _inicio;
        uint256[] memory listaIdsProductosActivos = new uint256[](longitudListaProductos);
        for (uint256 i = 0; i < longitudListaProductos; i++) {
            listaIdsProductosActivos[i] = IdsProductosActivos[_direccionEmpresa][_inicio + i];
        }
        return listaIdsProductosActivos;
    }

    // --- Gestión de Facturas ---

    /**
     * @notice Crea una factura para registrar una venta con ID autogenerado.
     * @dev Esta función no maneja la transferencia de fondos, solo el registro de la transacción.
     * @param _direccionEmpresa La dirección de la empresa que realizó la venta.
     * @param _direccionCliente La dirección del cliente que compró.
     * @param _importeTotal El total del valor de la factura.
     * @return nuevoIdFactura El ID asignado.
     */
    function facturaCrear(
        address _direccionEmpresa,
        address _direccionCliente,
        uint256 _importeTotal
    )
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
        returns (uint256 nuevoIdFactura)
    {
        if (_direccionCliente == address(0)) revert EntradaInvalida("cliente");
        if (_importeTotal == 0) revert EntradaInvalida("importeTotal");

        Empresa storage e = empresas[_direccionEmpresa];
        nuevoIdFactura = ++e.contadorFacturas;
        Factura storage f = facturas[_direccionEmpresa][nuevoIdFactura];
        f.fecha = uint64(block.timestamp); // `block.timestamp` es una variable global que da el tiempo del bloque actual.
        f.direccionCliente = _direccionCliente;
        f.importeTotal = _importeTotal;
        f.existeFactura = true;
        f.estatus = EstatusFactura.Activa;

        comprasPorCliente[_direccionEmpresa][_direccionCliente] += 1;

        // Se actualizan los índices de facturas.
        facturaIdsTodas[_direccionEmpresa].push(nuevoIdFactura);
        facturasActivasIds[_direccionEmpresa].push(nuevoIdFactura);
        idFacturaAIndiceActivo[_direccionEmpresa][nuevoIdFactura] = facturasActivasIds[_direccionEmpresa].length - 1;

        emit FacturaCreada(_direccionEmpresa, nuevoIdFactura, _direccionCliente, _importeTotal);
    }

    /**
     * @notice Obtiene los detalles de una factura específica de una empresa.
     * @param _direccionEmpresa La dirección de la empresa.
     * @param _idFactura El ID de la factura a consultar.
     * @return fecha La fecha de creación de la factura.
     * @return direccionCliente La dirección del cliente.
     * @return importeTotal El importe total de la factura.
     * @return existeFactura Indica si la factura existe.
     */
    function facturaObtener(address _direccionEmpresa, uint256 _idFactura)
        external
        view
        returns (
            uint64 fecha,
            address direccionCliente,
            uint256 importeTotal,
            bool existeFactura
        )
    {
        Factura storage f = facturas[_direccionEmpresa][_idFactura];
        if (!f.existeFactura) revert FacturaNoEncontrada(_idFactura);
        return (f.fecha, f.direccionCliente, f.importeTotal, f.existeFactura);
    }

    /**
     * @notice Devuelve el número total de facturas activas de una empresa.
     */
    function facturasTotal(address _direccionEmpresa) external view returns (uint256) {
        return facturasActivasIds[_direccionEmpresa].length;
    }

    /**
     * @notice Devuelve el número total de compras realizadas por un cliente en una empresa.
     */
    function clienteTotalCompras(address _direccionEmpresa, address _direccionCliente) external view returns (uint256) {
        return comprasPorCliente[_direccionEmpresa][_direccionCliente];
    }

    /**
     * @notice Devuelve el último ID emitido para facturas de la empresa.
     */
    function facturaUltimoId(address _direccionEmpresa) external view returns (uint256) {
        return empresas[_direccionEmpresa].contadorFacturas;
    }

    /**
     * @notice Indica si una factura existe (ha sido creada).
     */
    function facturaExiste(address _direccionEmpresa, uint256 _idFactura) external view returns (bool) {
        return facturas[_direccionEmpresa][_idFactura].existeFactura;
    }

    /**
     * @notice Lista todos los IDs de facturas activas de una empresa.
     */
    function facturasListarIds(address _direccionEmpresa) external view returns (uint256[] memory) {
        return facturasActivasIds[_direccionEmpresa];
    }

    /**
     * @notice Lista paginada de IDs de facturas activas.
     */
    function facturasActivasListarIds(
        address _direccionEmpresa,
        uint256 _inicio,
        uint256 _limite
    ) external view returns (uint256[] memory) {
        uint256 cantidadFacturaActivas = facturasActivasIds[_direccionEmpresa].length;
        if (_inicio >= cantidadFacturaActivas) return new uint256[](0);
        uint256 fin = _inicio + _limite;
        if (fin > cantidadFacturaActivas) fin = cantidadFacturaActivas;
        uint256 longitudListaFacturas = fin - _inicio;
        uint256[] memory listafacturasActivasIds = new uint256[](longitudListaFacturas);
        for (uint256 i = 0; i < longitudListaFacturas; i++) {
            listafacturasActivasIds[i] = facturasActivasIds[_direccionEmpresa][_inicio + i];
        }
        return listafacturasActivasIds;
    }

    /**
     * @notice Anula una factura (eliminación lógica) y la retira del índice de activas en O(1).
     */
    function facturaEliminar(address _direccionEmpresa, uint256 _idFactura)
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
    {
        Factura storage f = facturas[_direccionEmpresa][_idFactura];
        if (!f.existeFactura) revert FacturaNoEncontrada(_idFactura);
        
        // Solo se puede anular una factura que está activa.
        if (f.estatus == EstatusFactura.Activa) {
            f.estatus = EstatusFactura.Anulada;
            // Se elimina la factura del array de activas usando la técnica O(1).
            uint256 indice = idFacturaAIndiceActivo[_direccionEmpresa][_idFactura];
            uint256 ultimoIndice = facturasActivasIds[_direccionEmpresa].length - 1;
            if (indice != ultimoIndice) {
                uint256 ultimoId = facturasActivasIds[_direccionEmpresa][ultimoIndice];
                facturasActivasIds[_direccionEmpresa][indice] = ultimoId;
                idFacturaAIndiceActivo[_direccionEmpresa][ultimoId] = indice;
            }
            facturasActivasIds[_direccionEmpresa].pop();
            delete idFacturaAIndiceActivo[_direccionEmpresa][_idFactura];
            emit FacturaAnulada(_direccionEmpresa, _idFactura);
        }
    }

    /**
     * @notice Restaura una factura previamente anulada, regresándola al listado de activas.
     */
    function facturaRestaurar(address _direccionEmpresa, uint256 _idFactura)
        external
        soloAdminEmpresa(_direccionEmpresa)
        empresaActiva(_direccionEmpresa)
    {
        Factura storage f = facturas[_direccionEmpresa][_idFactura];
        if (!f.existeFactura) revert FacturaNoEncontrada(_idFactura);
        if (f.estatus == EstatusFactura.Activa) return; // No hacer nada si ya está activa.
        
        f.estatus = EstatusFactura.Activa;
        facturasActivasIds[_direccionEmpresa].push(_idFactura);
        idFacturaAIndiceActivo[_direccionEmpresa][_idFactura] = facturasActivasIds[_direccionEmpresa].length - 1;
        emit FacturaRestaurada(_direccionEmpresa, _idFactura);
    }

    /**
     * @notice Lista todas las facturas históricas (activas y anuladas) de una empresa.
     */
    function facturasListarHistorico(address _direccionEmpresa) external view returns (uint256[] memory) {
        return facturaIdsTodas[_direccionEmpresa];
    }

    /**
     * @notice Devuelve el número total de facturas históricas de una empresa.
     */
    function facturasTotalHistorico(address _direccionEmpresa) external view returns (uint256) {
        return facturaIdsTodas[_direccionEmpresa].length;
    }

    /**
     * @notice Verifica si una factura está actualmente activa.
     */
    function facturaEsActiva(address _direccionEmpresa, uint256 _idFactura) external view returns (bool) {
        return facturas[_direccionEmpresa][_idFactura].estatus == EstatusFactura.Activa && facturas[_direccionEmpresa][_idFactura].existeFactura;
    }
}
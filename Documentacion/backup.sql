/*
 Navicat Premium Dump SQL

 Source Server         : Cuitlahuac
 Source Server Type    : MySQL
 Source Server Version : 100428 (10.4.28-MariaDB)
 Source Host           : localhost
 Source Schema         : magiccookies2

 Target Server Type    : MySQL
 Target Server Version : 100428 (10.4.28-MariaDB)
 File Encoding         : 65001

 Date: 11/04/2025 16:40:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tbl_carrito
-- ----------------------------
DROP TABLE IF EXISTS `tbl_carrito`;
CREATE TABLE `tbl_carrito`  (
  `idCarrito` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NOT NULL,
  `idProducto` int NOT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `nombre_producto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `presentacion` enum('Pieza','700g','1kg') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` int NOT NULL,
  `precio_unitario` decimal(10, 2) NOT NULL,
  `subtotal` decimal(10, 2) NOT NULL,
  `fecha_pedido` datetime NULL DEFAULT current_timestamp(),
  `fecha_entrega` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`idCarrito`) USING BTREE,
  INDEX `idUsuario`(`idUsuario` ASC) USING BTREE,
  INDEX `idProducto`(`idProducto` ASC) USING BTREE,
  CONSTRAINT `tbl_carrito_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `tbl_usuarios` (`idUsuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_carrito_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `tbl_productos` (`idProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_carrito
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_detalle_ventas
-- ----------------------------
DROP TABLE IF EXISTS `tbl_detalle_ventas`;
CREATE TABLE `tbl_detalle_ventas`  (
  `idDetalle` int NOT NULL AUTO_INCREMENT,
  `idVenta` int NULL DEFAULT NULL,
  `idProducto` int NULL DEFAULT NULL,
  `cantidad` decimal(10, 2) NULL DEFAULT NULL,
  `subtotal` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`idDetalle`) USING BTREE,
  INDEX `idVenta`(`idVenta` ASC) USING BTREE,
  INDEX `idProducto`(`idProducto` ASC) USING BTREE,
  CONSTRAINT `tbl_detalle_ventas_ibfk_1` FOREIGN KEY (`idVenta`) REFERENCES `tbl_ventas` (`idVenta`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_detalle_ventas_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `tbl_productos` (`idProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_detalle_ventas
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_detalles_pedido
-- ----------------------------
DROP TABLE IF EXISTS `tbl_detalles_pedido`;
CREATE TABLE `tbl_detalles_pedido`  (
  `idDetalle` int NOT NULL AUTO_INCREMENT,
  `idPedidos` int NULL DEFAULT NULL,
  `idProducto` int NULL DEFAULT NULL,
  `cantidad` int NULL DEFAULT NULL,
  `subtotal` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`idDetalle`) USING BTREE,
  INDEX `idPedidos`(`idPedidos` ASC) USING BTREE,
  INDEX `idProducto`(`idProducto` ASC) USING BTREE,
  CONSTRAINT `tbl_detalles_pedido_ibfk_1` FOREIGN KEY (`idPedidos`) REFERENCES `tbl_pedidos` (`idPedidos`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_detalles_pedido_ibfk_2` FOREIGN KEY (`idProducto`) REFERENCES `tbl_productos` (`idProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_detalles_pedido
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_ganancias
-- ----------------------------
DROP TABLE IF EXISTS `tbl_ganancias`;
CREATE TABLE `tbl_ganancias`  (
  `idGanancia` int NOT NULL AUTO_INCREMENT,
  `fecha` date NULL DEFAULT NULL,
  `ventas_totales` decimal(10, 2) NULL DEFAULT NULL,
  `costos_totales` decimal(10, 2) NULL DEFAULT NULL,
  `utilidad_bruta` decimal(10, 2) NULL DEFAULT NULL,
  `gastos_operativos` decimal(10, 2) NULL DEFAULT NULL,
  `utilidad_neta` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`idGanancia`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_ganancias
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_materia_prima
-- ----------------------------
DROP TABLE IF EXISTS `tbl_materia_prima`;
CREATE TABLE `tbl_materia_prima`  (
  `idIngrediente` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('Piezas','Mililitros','Gramos') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` decimal(10, 2) NULL DEFAULT NULL,
  `cantidad_original` decimal(10, 2) NULL DEFAULT NULL,
  `presentacion` enum('Kilos','Litros','Gramos','Mililitros','Piezas') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `precio_unitario` decimal(10, 2) NULL DEFAULT NULL,
  `fecha_compra` date NULL DEFAULT NULL,
  `fecha_caducidad` date NULL DEFAULT NULL,
  `idProveedores` int NULL DEFAULT NULL,
  PRIMARY KEY (`idIngrediente`) USING BTREE,
  INDEX `idProveedores`(`idProveedores` ASC) USING BTREE,
  CONSTRAINT `tbl_materia_prima_ibfk_1` FOREIGN KEY (`idProveedores`) REFERENCES `tbl_proveedores` (`idProveedores`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_materia_prima
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_mermas
-- ----------------------------
DROP TABLE IF EXISTS `tbl_mermas`;
CREATE TABLE `tbl_mermas`  (
  `idMerma` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('Productos','Insumos') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` decimal(10, 2) NULL DEFAULT NULL,
  `motivo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL,
  `fecha` date NULL DEFAULT NULL,
  `idProducto` int NULL DEFAULT NULL,
  `idIngrediente` int NULL DEFAULT NULL,
  PRIMARY KEY (`idMerma`) USING BTREE,
  INDEX `idProducto`(`idProducto` ASC) USING BTREE,
  INDEX `idIngrediente`(`idIngrediente` ASC) USING BTREE,
  CONSTRAINT `tbl_mermas_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `tbl_productos` (`idProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_mermas_ibfk_2` FOREIGN KEY (`idIngrediente`) REFERENCES `tbl_materia_prima` (`idIngrediente`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_mermas
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_orden_productos
-- ----------------------------
DROP TABLE IF EXISTS `tbl_orden_productos`;
CREATE TABLE `tbl_orden_productos`  (
  `idOrdenProducto` int NOT NULL AUTO_INCREMENT,
  `idOrdenes` int NULL DEFAULT NULL,
  `idProveedorProducto` int NULL DEFAULT NULL,
  `cantidad_solicitada` decimal(10, 2) NOT NULL,
  `costo_unitario` decimal(10, 2) NOT NULL,
  `presentacion` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idOrdenProducto`) USING BTREE,
  INDEX `idOrdenes`(`idOrdenes` ASC) USING BTREE,
  INDEX `idProveedorProducto`(`idProveedorProducto` ASC) USING BTREE,
  CONSTRAINT `tbl_orden_productos_ibfk_1` FOREIGN KEY (`idOrdenes`) REFERENCES `tbl_ordenes` (`idOrdenes`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_orden_productos_ibfk_2` FOREIGN KEY (`idProveedorProducto`) REFERENCES `tbl_proveedor_productos` (`idProveedorProducto`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_orden_productos
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_ordenes
-- ----------------------------
DROP TABLE IF EXISTS `tbl_ordenes`;
CREATE TABLE `tbl_ordenes`  (
  `idOrdenes` int NOT NULL AUTO_INCREMENT,
  `idProveedores` int NULL DEFAULT NULL,
  `costo` decimal(10, 2) NULL DEFAULT NULL,
  `estatus` enum('Entregada','En Proceso') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_orden` datetime NULL DEFAULT current_timestamp(),
  `fecha_entrega` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`idOrdenes`) USING BTREE,
  INDEX `idProveedores`(`idProveedores` ASC) USING BTREE,
  CONSTRAINT `tbl_ordenes_ibfk_1` FOREIGN KEY (`idProveedores`) REFERENCES `tbl_proveedores` (`idProveedores`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_ordenes
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_pedidos
-- ----------------------------
DROP TABLE IF EXISTS `tbl_pedidos`;
CREATE TABLE `tbl_pedidos`  (
  `idPedidos` int NOT NULL AUTO_INCREMENT,
  `idUsuario` int NULL DEFAULT NULL,
  `fecha_pedido` datetime NOT NULL,
  `fecha_entrega` datetime NULL DEFAULT NULL,
  `estatus` enum('Pendiente','Entregado','Cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idPedidos`) USING BTREE,
  INDEX `idUsuario`(`idUsuario` ASC) USING BTREE,
  CONSTRAINT `tbl_pedidos_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `tbl_usuarios` (`idUsuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_pedidos
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_productos
-- ----------------------------
DROP TABLE IF EXISTS `tbl_productos`;
CREATE TABLE `tbl_productos`  (
  `idProducto` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `tipo` enum('Piezas','Pre-empacada 700 gr','Pre-empacada 1Kg') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `precio` decimal(12, 2) NOT NULL,
  `cantidad_stock` int NOT NULL,
  `fecha_caducidad` datetime NULL DEFAULT NULL,
  `peso` decimal(10, 2) NULL DEFAULT NULL,
  `imagen` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `fecha_produccion` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`idProducto`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_productos
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_proveedor_productos
-- ----------------------------
DROP TABLE IF EXISTS `tbl_proveedor_productos`;
CREATE TABLE `tbl_proveedor_productos`  (
  `idProveedorProducto` int NOT NULL AUTO_INCREMENT,
  `idProveedores` int NOT NULL,
  `nombre_producto` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `cantidad` decimal(10, 2) NULL DEFAULT NULL,
  `presentacion` enum('Kilos','Litros','Gramos','Mililitros','Piezas') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `precio_unitario` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`idProveedorProducto`) USING BTREE,
  INDEX `idProveedores`(`idProveedores` ASC) USING BTREE,
  CONSTRAINT `tbl_proveedor_productos_ibfk_1` FOREIGN KEY (`idProveedores`) REFERENCES `tbl_proveedores` (`idProveedores`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_proveedor_productos
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_proveedores
-- ----------------------------
DROP TABLE IF EXISTS `tbl_proveedores`;
CREATE TABLE `tbl_proveedores`  (
  `idProveedores` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `direccion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`idProveedores`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_proveedores
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_receta_ingredientes
-- ----------------------------
DROP TABLE IF EXISTS `tbl_receta_ingredientes`;
CREATE TABLE `tbl_receta_ingredientes`  (
  `idDetalle` int NOT NULL AUTO_INCREMENT,
  `idReceta` int NULL DEFAULT NULL,
  `idIngrediente` int NULL DEFAULT NULL,
  `cantidad` decimal(10, 2) NULL DEFAULT NULL,
  PRIMARY KEY (`idDetalle`) USING BTREE,
  INDEX `idReceta`(`idReceta` ASC) USING BTREE,
  INDEX `idIngrediente`(`idIngrediente` ASC) USING BTREE,
  CONSTRAINT `tbl_receta_ingredientes_ibfk_1` FOREIGN KEY (`idReceta`) REFERENCES `tbl_recetas` (`idReceta`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `tbl_receta_ingredientes_ibfk_2` FOREIGN KEY (`idIngrediente`) REFERENCES `tbl_materia_prima` (`idIngrediente`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_receta_ingredientes
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_recetas
-- ----------------------------
DROP TABLE IF EXISTS `tbl_recetas`;
CREATE TABLE `tbl_recetas`  (
  `idReceta` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `precioProduccion` decimal(10, 2) NULL DEFAULT NULL,
  `cantidad_produccion` int NULL DEFAULT NULL,
  PRIMARY KEY (`idReceta`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_recetas
-- ----------------------------

-- ----------------------------
-- Table structure for tbl_usuarios
-- ----------------------------
DROP TABLE IF EXISTS `tbl_usuarios`;
CREATE TABLE `tbl_usuarios`  (
  `idUsuario` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apellido` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `email` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rol` enum('Administrador','Vendedor','Cocinero','Cliente') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`idUsuario`) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_usuarios
-- ----------------------------
INSERT INTO `tbl_usuarios` VALUES (1, 'Doña', 'Cuca', 'admin@gmail.com', 'scrypt:32768:8:1$62AlrKIvwPiHqoqT$175e14aa2800b09c73fb630a42a801aa541b0f2027c3bf9e1d5c64f7cd1e606c3ed22d436590f90a1827427880650e0482ea74b73bee7d989bae3f3aa036968f', 'Administrador');
INSERT INTO `tbl_usuarios` VALUES (2, 'Tristan', 'Torres', 'tris@gmail.com', 'scrypt:32768:8:1$UfW7azzUCOxWDJDS$4c808ffaa852fcfed73c9ffa785a002386ed9c9ca311e70e8429cc2fa0e4f4a0344a39fa792274584f9ae3ab7967eeb2632765bcf16ce0d10159c96265774fbb', 'Vendedor');
INSERT INTO `tbl_usuarios` VALUES (3, 'Jorge', 'Cruz', 'jorge@gmail.com', 'scrypt:32768:8:1$keGgQExE5ni7Cj6f$11e36f6825c3b2e079fc14fa1c66972011ec2ff2a4fc5f573b382e16be06b6948b75f0a534f7ddbcd671bd7b40f3c3f33b17f651f835265a56fa9f5d6e837627', 'Cocinero');
INSERT INTO `tbl_usuarios` VALUES (4, 'Doña', 'Petra', 'cliente@gmail.com', 'scrypt:32768:8:1$9U7Z8OCovKb4aAWh$6719662cd1416e804602c5374b0048eb58f0e9e45a401045ca95f5bee51a6434a0c0fb34cd116eecbff5148a6682063c754bb0a8fcd0ae5b71cf029a39576b62', 'Cliente');

-- ----------------------------
-- Table structure for tbl_ventas
-- ----------------------------
DROP TABLE IF EXISTS `tbl_ventas`;
CREATE TABLE `tbl_ventas`  (
  `idVenta` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  PRIMARY KEY (`idVenta`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of tbl_ventas
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;

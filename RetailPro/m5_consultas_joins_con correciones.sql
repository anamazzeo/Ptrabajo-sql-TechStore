-- Pre-entrega 5 - RetailPro

USE retailpro;


-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: juntar la información de las ventas con los datos de los clientes, productos y categorías para analizarla en Power BI.

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.ciudad,
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta, v.id_venta;

-- Hallazgo: En marzo de 2024 hubo 10 ventas por un total de $6.444.
-- La categoría que más facturó fue Computación, con $4.950.


-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: buscar los clientes que están registrados pero todavía no hicieron ninguna compra.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Hallazgo: No aparecieron clientes sin compras
-- Los 5 clientes registrados ya compraron al menos una vez, por lo que por ahora CRM no tiene clientes pendientes de su primera compra.


-- Consulta 3: Productos sin ventas (LEFT JOIN) 
-- Propósito: revisar si hay productos del catálogo que todavía no se vendieron.

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY cat.nombre_categoria, p.nombre_producto;

-- Hallazgo: No aparecieron productos sin ventas. Los 6 productos del catálogo se vendieron al menos una vez, así que por ahora no hay artículos sin movimiento para revisar.


-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar cuánto se vendió en dos períodos de marzo de 2024, teniendo en cuenta todas las ventas registradas.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        '1 al 10 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-01'
      AND fecha_venta < '2024-03-11'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        '11 al 31 de marzo' AS canal
    FROM ventas
    WHERE fecha_venta >= '2024-03-11'
      AND fecha_venta < '2024-04-01'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;

-- Hallazgo: Del 1 al 10 de marzo se facturaron $3.620 y del 11 al 31 de marzo, $2.824. En el primer período se vendió más, con una diferencia de $796.


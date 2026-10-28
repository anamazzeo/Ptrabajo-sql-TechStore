Pre-entrega 5 - RetailPro

-- Consulta 1: Vista base del proyecto (INNER JOIN)
-- Propósito: reunir las ventas con los datos de clientes y productos para Power BI

SELECT
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    p.id_producto,
    p.nombre_producto,
    p.categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p ON v.id_producto = p.id_producto
ORDER BY v.fecha_venta, v.id_venta;

-- Hallazgo: En marzo de 2024 se registraron 10 ventas, con una facturación total de $6.444. La categoría Computación fue la que más facturó, con $4.950.

-- Consulta 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: identificar clientes que todavía no compraron para que CRM pueda contactarlos

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL
ORDER BY c.fecha_registro;

-- Hallazgo: De los 5 clientes registrados, ninguno quedó sin realizar compras. Esto indica que todos los clientes realizaron al menos una compra y que CRM no tiene clientes pendientes de una primera compra.

-- Consulta 3: Productos sin ventas (LEFT JOIN)
-- Propósito: encontrar productos del catálogo que todavía no registran ventas

SELECT
    p.nombre_producto,
    p.categoria,
    p.precio
FROM productos AS p
LEFT JOIN ventas AS v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
ORDER BY p.categoria, p.nombre_producto;

-- Hallazgo: Los 6 productos del catálogo registraron al menos una venta. Esto significa que no hay productos sin movimiento en los datos analizados.

-- Consulta 4: Consolidado por canal (UNION ALL)
-- Propósito: comparar las ventas de dos períodos sin descartar operaciones repetidas.

SELECT
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primer semestre' AS canal
    FROM ventas
    WHERE fecha_venta >= '2026-01-01' AND fecha_venta < '2026-07-01'

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segundo semestre' AS canal
    FROM ventas
    WHERE fecha_venta >= '2026-07-01' AND fecha_venta < '2027-01-01'
) AS consolidado
GROUP BY canal
ORDER BY total_canal DESC;

-- Hallazgo: Del 1 al 10 de marzo se facturaron $3.620, mientras que del 11 al 31 de marzo se registraron $2.824. El primer período tuvo una facturación mayor, con una diferencia de $796.

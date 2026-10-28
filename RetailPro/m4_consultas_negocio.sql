-- RetailPro - Pre-entrega 4
-- Consultas de negocio sobre Ventas_Tech_DB
-- Motor: SQL Server

USE Ventas_Tech_DB;
GO

-- 1. Resumen mensual de ventas
-- Calculo la facturacion, los pedidos y el importe promedio por pedido.
SELECT
    YEAR(fecha_venta) AS anio,
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
ORDER BY anio, mes;

-- 2. Los 5 productos que mas facturaron
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- 3. Clientes que compraron mas de una vez
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;

-- 4. Comparacion de cada mes con el promedio mensual general
-- Primero calculo el total de cada mes y despues lo comparo con el promedio.
WITH ventas_mensuales AS (
    SELECT
        YEAR(fecha_venta) AS anio,
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY YEAR(fecha_venta), MONTH(fecha_venta)
)
SELECT
    anio,
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM ventas_mensuales)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END AS comparacion_promedio
FROM ventas_mensuales
ORDER BY anio, mes;

-- Hallazgos
-- 1. El mes con mayor facturacion fue marzo de 2024, con un total de $6444.
-- 2. El producto que mas facturo fue el ID 1, con 3 unidades vendidas y un total de $3600.
-- 3. Todos los clientes realizaron 2 compras, por lo que no hubo uno con mas pedidos que los demas.

-- ══════════════════════════════════════════
-- MiniStore — Soluciones con Outer JOINs
-- Autor: Cristian Berlingieri
-- Fecha: 2026-11-07
-- ══════════════════════════════════════════
-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostrá todos los productos y sus ventas asociadas.
-- Los productos sin ventas aparecerán con NULL en las columnas de ventas.
SELECT p.producto_id,
       v.venta_id
FROM   productos AS p
       LEFT OUTER JOIN
       ventas AS v
       ON p.producto_id = v.producto_id
WHERE  v.venta_id IS NULL;

-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Los registros huérfanos aparecerán con NULL en las columnas de productos.
SELECT p.producto_id,
       v.venta_id,
       v.producto_id
FROM   productos AS p
       RIGHT OUTER JOIN
       ventas AS v
       ON p.producto_id = v.producto_id
WHERE  p.producto_id IS NULL;

-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.
SELECT p.producto_id,
       v.venta_id
FROM   productos AS p
       FULL OUTER JOIN
       ventas AS v
       ON p.producto_id = v.producto_id;
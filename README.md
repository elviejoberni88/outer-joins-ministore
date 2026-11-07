# MiniStore — LEFT, RIGHT y FULL OUTER JOIN

Práctica de joins externos. El catálogo tiene 9 productos (101 a 109) y 10 ventas. Nunca se vendieron el 108 y el 109, y la venta 10 tiene un `producto_id = 999` que no existe en el catálogo.

## Archivos

- `schema.sql`: tablas y datos.
- `soluciones.sql`: las tres consultas.
- `README.md`: este archivo.

## 1. ¿Por qué LEFT JOIN y no INNER en la primera?

Porque el INNER solo devuelve las filas que coinciden en las dos tablas. Los productos sin venta no tienen coincidencia, así que desaparecerían. Con LEFT JOIN aparecen todos los productos, y los que no se vendieron quedan con NULL en `ventas`. Después filtro con `WHERE v.venta_id IS NULL` y salen el 108 y el 109.

## 2. ¿Por qué RIGHT JOIN en la segunda?

Porque quiero todas las ventas, incluso las que no tienen producto válido. En `productos p RIGHT JOIN ventas v`, la izquierda es `productos` y la derecha es `ventas`. Las ventas sin producto quedan con NULL en las columnas de `productos`, y con `WHERE p.producto_id IS NULL` aparece la venta 10 (producto 999).

## 3. ¿Qué significa NULL en cada resultado?

En la primera, `venta_id` NULL significa que el producto no tiene ventas (108 y 109). En la segunda, `productos.producto_id` NULL significa que la venta existe pero el producto no está en el catálogo (venta 10, producto 999). En la tercera aparecen los dos casos juntos.

## 4. ¿Cuándo usaría FULL OUTER JOIN?

Para auditar o conciliar dos tablas sin perder registros de ningún lado. Por ejemplo, comparar el catálogo con las ventas y detectar productos que no se venden y ventas con códigos inexistentes. En esta práctica devuelve 12 filas: 9 ventas que coinciden, 2 productos sin venta y 1 venta huérfana.

## Resultados

- C1: 2 filas (108 y 109, `venta_id` NULL).
- C2: 1 fila (venta 10, `producto_id` NULL, `v.producto_id = 999`).
- C3: 12 filas, sin perder registros.

## Cómo correrlo

Ejecutar `schema.sql` en una base (por ejemplo `MiniStore`) y después las consultas de `soluciones.sql` en esa misma base.

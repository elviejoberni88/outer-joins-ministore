# MiniStore — LEFT, RIGHT y FULL OUTER JOIN

Práctica de joins externos sobre una base chica de una tienda. La idea era ver qué pasa cuando una tabla tiene registros que no tienen pareja en la otra: productos que nunca se vendieron y ventas cargadas con un producto que no existe en el catálogo.

## Archivos

- `schema.sql`: crea las tablas y carga los datos.
- `soluciones.sql`: las tres consultas (LEFT, RIGHT y FULL OUTER JOIN).
- `README.md`: este archivo.

## Los datos

El catálogo tiene 9 productos (101 a 109) y hay 10 ventas. Dos productos nunca se vendieron: el 108 (Hub USB-C 7p) y el 109 (Parlante Bluetooth). Además, la venta 10 tiene un `producto_id = 999` que no existe en el catálogo. Esos son los casos que buscan las consultas.

## 1. ¿Por qué LEFT JOIN y no INNER JOIN en la primera consulta?

Porque el INNER JOIN solo devuelve las filas que coinciden en las dos tablas. Si lo usaba para buscar productos que nunca se vendieron, esos productos justamente desaparecían del resultado: al no tener venta, no hay coincidencia y el INNER los descarta.

Con LEFT JOIN tomo todos los productos (la tabla de la izquierda) y le pego las ventas cuando existen. Los que no tienen venta quedan con NULL en las columnas de `ventas`. Ahí sí puedo filtrar con `WHERE v.venta_id IS NULL` y me quedo con el 108 y el 109. Con INNER no habría forma de encontrarlos, porque no hay fila de venta que coincida.

## 2. ¿Por qué RIGHT JOIN en la segunda consulta?

Porque acá la tabla que manda es `ventas`: quiero todas las ventas, incluso las que no tienen un producto válido. El RIGHT JOIN conserva todas las filas de la tabla de la derecha.

En mi consulta puse `productos AS p RIGHT OUTER JOIN ventas AS v`, así que la izquierda es `productos` (p) y la derecha es `ventas` (v). Las ventas que no encuentran producto quedan con NULL en las columnas de `productos`. Con `WHERE p.producto_id IS NULL` aparece la venta 10, que tiene `producto_id = 999` y no está en el catálogo.

## 3. ¿Qué significa NULL en cada resultado?

En la primera consulta, `venta_id` NULL significa que ese producto no tiene ninguna venta. Por ejemplo, el 108 y el 109 aparecen con `venta_id` NULL porque nunca se vendieron.

En la segunda, `productos.producto_id` NULL significa que la venta existe pero el producto no está en el catálogo. Es el caso de la venta 10: el `producto_id` real es 999, pero como no hay un producto 999, la columna del producto queda NULL. Es una venta huérfana, probablemente un error de carga.

En la tercera aparecen los dos tipos de NULL juntos, porque el FULL OUTER JOIN muestra todo: productos sin venta y ventas sin producto.

## 4. ¿Cuándo usaría FULL OUTER JOIN en un caso real?

Lo usaría cuando necesito una auditoría o un control cruzado entre dos tablas y no quiero perder registros de ninguno de los dos lados. Por ejemplo, para comparar el catálogo contra las ventas y detectar tanto productos que no se están vendiendo como ventas cargadas con códigos que no existen.

También sirve para conciliar dos sistemas: el maestro de productos de un sistema contra la tabla de ventas de otro. El FULL OUTER JOIN muestra las diferencias en las dos direcciones: lo que está en uno y no en el otro, y viceversa. En esta práctica, la tercera consulta devuelve 12 filas: las 9 ventas que coinciden con un producto, los 2 productos sin venta y la venta huérfana.

## Resultado de las consultas

- Consulta 1: 2 filas (108 y 109, con `venta_id` NULL).
- Consulta 2: 1 fila (venta 10, con `producto_id` NULL y `v.producto_id = 999`).
- Consulta 3: 12 filas, sin perder ningún registro.

## Cómo correrlo

Ejecutar `schema.sql` en una base (por ejemplo `MiniStore`) y después las consultas de `soluciones.sql` en esa misma base.

Nota: en SQL Server el FULL OUTER JOIN existe; en MySQL habría que simularlo con un UNION entre el LEFT y el RIGHT.

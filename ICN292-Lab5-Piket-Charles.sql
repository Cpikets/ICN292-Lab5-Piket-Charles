-- Activar comprobacion de claves foraneas para esta conexion.
PRAGMA foreign_keys = ON;

-- ============================================================
-- CREACION DE LAS CUATRO TABLAS
-- ============================================================
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS vendedores;
DROP TABLE IF EXISTS bicicletas;
DROP TABLE IF EXISTS tiendas;


CREATE TABLE tiendas (
    id_tienda INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    comuna TEXT NOT NULL
);

CREATE TABLE vendedores (
    id_vendedor INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    id_tienda INTEGER,
    fecha_ingreso TEXT NOT NULL,
    FOREIGN KEY (id_tienda) REFERENCES tiendas(id_tienda)
);

CREATE TABLE bicicletas (
    id_bicicleta INTEGER PRIMARY KEY,
    modelo TEXT NOT NULL,
    categoria TEXT NOT NULL
        CHECK (categoria IN ('Eléctrica', 'Infantil', 'Montaña', 'Ruta', 'Urbana')),
    precio NUMERIC NOT NULL CHECK (precio >= 0)
);

CREATE TABLE ventas (
    id_venta INTEGER PRIMARY KEY,
    id_vendedor INTEGER NOT NULL,
    id_bicicleta INTEGER NOT NULL,
    fecha TEXT NOT NULL,
    unidades INTEGER NOT NULL CHECK (unidades > 0),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_bicicleta) REFERENCES bicicletas(id_bicicleta)
);


INSERT INTO tiendas (id_tienda, nombre, comuna) VALUES
    (1, 'Andes Providencia', 'Providencia'),
    (2, 'Andes Maipú', 'Maipú'),
    (3, 'Andes Concepción', 'Concepción'),
    (4, 'Andes La Serena', 'La Serena');

INSERT INTO vendedores (id_vendedor, nombre, id_tienda, fecha_ingreso) VALUES
    (1, 'Camila Ortiz', 1, '2024-06-20'),
    (2, 'Diego Fuentes', 1, '2024-01-15'),
    (3, 'Javiera Soto', 2, '2023-07-24'),
    (4, 'Matías Herrera', 2, '2024-01-15'),
    (5, 'Paula Riquelme', 3, '2022-11-02'),
    (6, 'Ignacio Vera', 3, '2024-08-19'),
    (7, 'Fernanda Lillo', 1, '2025-02-03'),
    (8, 'Rubén Castro', NULL, '2025-06-10');

INSERT INTO bicicletas (id_bicicleta, modelo, categoria, precio) VALUES
    (1, 'Cordillera 29', 'Montaña', '549990.00'),
    (2, 'Ruta Austral', 'Ruta', '899990.00'),
    (3, 'Urbana Pro', 'Urbana', '329990.00'),
    (4, 'Pequeño Andes', 'Infantil', '149990.00'),
    (5, 'Volt City', 'Eléctrica', '1249990.00'),
    (6, 'Trail Master', 'Montaña', '749990.00'),
    (7, 'Urbana Lite', 'Urbana', '229990.00'),
    (8, 'Sprint R7', 'Ruta', '1099990.00');

INSERT INTO ventas (id_vendedor, id_bicicleta, fecha, unidades) VALUES
    (1, 1, '2025-03-04', 2),
    (1, 3, '2025-03-18', 1),
    (1, 5, '2025-04-02', 1),
    (2, 2, '2025-03-04', 1),
    (2, 1, '2025-04-11', 3),
    (2, 7, '2025-05-06', 2),
    (3, 4, '2025-03-21', 4),
    (3, 3, '2025-04-15', 2),
    (3, 6, '2025-05-20', 1),
    (4, 1, '2025-03-27', 1),
    (4, 5, '2025-05-09', 2),
    (5, 2, '2025-04-08', 1),
    (5, 6, '2025-04-23', 2),
    (5, 4, '2025-06-02', 5),
    (6, 3, '2025-05-13', 3),
    (6, 7, '2025-06-17', 1),
    (6, 1, '2025-06-24', 2),
    (1, 6, '2025-06-30', 1);

-- ============================================================
-- DIEZ CONSULTAS DEL ENUNCIADO
-- ============================================================
-- CONSULTA 01: Vendedores con cantidad de ventas, incluidos los que no vendieron
SELECT vd.nombre AS vendedor,
       COUNT(v.id_venta) AS cantidad_ventas
FROM vendedores AS vd
LEFT JOIN ventas AS v ON v.id_vendedor = vd.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre
ORDER BY cantidad_ventas DESC, vd.nombre ASC;

-- CONSULTA 02: Ventas y unidades por tienda, incluidas tiendas sin vendedores
SELECT t.nombre AS tienda,
       COUNT(v.id_venta) AS cantidad_ventas,
       COALESCE(SUM(v.unidades), 0) AS unidades_vendidas
FROM tiendas AS t
LEFT JOIN vendedores AS vd ON vd.id_tienda = t.id_tienda
LEFT JOIN ventas AS v ON v.id_vendedor = vd.id_vendedor
GROUP BY t.id_tienda, t.nombre
ORDER BY unidades_vendidas DESC, t.nombre ASC;

-- CONSULTA 03: Tiendas sin vendedores asignados
SELECT t.nombre AS tienda,
       t.comuna
FROM tiendas AS t
LEFT JOIN vendedores AS vd ON vd.id_tienda = t.id_tienda
WHERE vd.id_vendedor IS NULL
ORDER BY t.nombre ASC;

-- CONSULTA 04: Modelos que no se vendieron ni una vez en junio de 2025
SELECT b.modelo,
       b.categoria
FROM bicicletas AS b
WHERE NOT EXISTS (
    SELECT 1
    FROM ventas AS v
    WHERE v.id_bicicleta = b.id_bicicleta
      AND v.fecha >= '2025-06-01'
      AND v.fecha < '2025-07-01'
)
ORDER BY b.modelo ASC;

-- CONSULTA 05: Vendedores sin ninguna venta, con tienda o ausencia de asignacion
SELECT vd.nombre AS vendedor,
       COALESCE(t.nombre, 'Sin tienda asignada') AS tienda
FROM vendedores AS vd
LEFT JOIN tiendas AS t ON t.id_tienda = vd.id_tienda
WHERE NOT EXISTS (
    SELECT 1
    FROM ventas AS v
    WHERE v.id_vendedor = vd.id_vendedor
)
ORDER BY vd.nombre ASC;

-- CONSULTA 06: Pares de vendedores de la misma tienda: primero ingreso antes
SELECT v1.nombre AS vendedor_primero,
       v2.nombre AS vendedor_despues,
       v1.fecha_ingreso AS fecha_primero,
       v2.fecha_ingreso AS fecha_despues,
       t.nombre AS tienda
FROM vendedores AS v1
INNER JOIN vendedores AS v2
    ON v1.id_tienda = v2.id_tienda
   AND v1.fecha_ingreso < v2.fecha_ingreso
INNER JOIN tiendas AS t ON t.id_tienda = v1.id_tienda
ORDER BY t.nombre ASC, v1.fecha_ingreso ASC,
         v2.fecha_ingreso ASC, v1.nombre ASC, v2.nombre ASC;

-- CONSULTA 07: Tiendas que superaron 2 millones en ventas de Montana y Ruta
SELECT t.nombre AS tienda,
       SUM(v.unidades * b.precio) AS monto_montana_ruta
FROM tiendas AS t
INNER JOIN vendedores AS vd ON vd.id_tienda = t.id_tienda
INNER JOIN ventas AS v ON v.id_vendedor = vd.id_vendedor
INNER JOIN bicicletas AS b ON b.id_bicicleta = v.id_bicicleta
WHERE b.categoria IN ('Montaña', 'Ruta')
GROUP BY t.id_tienda, t.nombre
HAVING SUM(v.unidades * b.precio) > 2000000
ORDER BY monto_montana_ruta DESC, t.nombre ASC;

-- CONSULTA 08: Modelos cuyo precio supera el promedio del catalogo
SELECT b.modelo,
       b.precio
FROM bicicletas AS b
WHERE b.precio > (
    SELECT AVG(b2.precio)
    FROM bicicletas AS b2
)
ORDER BY b.precio DESC, b.modelo ASC;

-- CONSULTA 09: Vendedores con promedio de unidades por venta superior al global
SELECT vd.nombre AS vendedor,
       ROUND(AVG(v.unidades), 2) AS promedio_unidades_por_venta
FROM vendedores AS vd
INNER JOIN ventas AS v ON v.id_vendedor = vd.id_vendedor
GROUP BY vd.id_vendedor, vd.nombre
HAVING AVG(v.unidades) > (
    SELECT AVG(v2.unidades)
    FROM ventas AS v2
)
ORDER BY promedio_unidades_por_venta DESC, vd.nombre ASC;

-- CONSULTA 10: Monto de ventas por vendedor, incluidos los que vendieron cero
SELECT vd.nombre AS vendedor,
       COALESCE(SUM(v.unidades * b.precio), 0) AS monto_total_vendido
FROM vendedores AS vd
LEFT JOIN ventas AS v ON v.id_vendedor = vd.id_vendedor
LEFT JOIN bicicletas AS b ON b.id_bicicleta = v.id_bicicleta
GROUP BY vd.id_vendedor, vd.nombre
ORDER BY monto_total_vendido DESC, vd.nombre ASC;

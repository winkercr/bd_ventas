# bd_ventas
PLANTEAMIENTO DEL PROBLEMA
 
Sistema de Ventas para una Empresa de Consumo Masivo

Contexto del negocio

La empresa Distribuciones Andina S.A. se dedica a la comercialización de productos de consumo masivo (alimentos, bebidas y productos de limpieza) en todo el país. Opera mediante una red de clientes minoristas (bodegas, supermercados, farmacias) atendidos por vendedores que toman pedidos diariamente. Actualmente, la empresa presenta problemas para:
• Analizar sus ventas históricas.
• Evaluar el desempeño comercial por vendedor, producto y zona.
• Tomar decisiones estratégicas basadas en datos confiables.
Por ello, la gerencia ha solicitado el diseño de un sistema de datos que incluya:
1. Una base de datos transaccional (OLTP) para registrar las operaciones diarias.
2. Un modelo dimensional (OLAP / BI) para análisis y toma de decisiones.

Objetivo general

Diseñar una solución integral de datos que permita:
• Registrar eficientemente las ventas diarias.
• Transformar los datos operativos en información analítica.
• Facilitar la generación de reportes e indicadores clave (KPIs).

1️⃣PROBLEMA – BASE DE DATOS TRANSACCIONAL (OLTP)
Requerimientos funcionales
El sistema debe permitir registrar:
• Clientes
• Productos
• Categorías de productos
• Vendedores
• Zonas de venta
• Pedidos de venta
• Detalle de productos vendidos por pedido
Cada pedido puede contener uno o varios productos, y cada producto puede venderse en muchos pedidos.
Reglas del negocio
1. Cada cliente pertenece a una sola zona.
2. Cada vendedor atiende una o varias zonas.
3. Un pedido:
o Es realizado por un solo cliente.
o Es atendido por un solo vendedor.
o Tiene una fecha de emisión.
4. El precio del producto puede variar con el tiempo.
5. El total del pedido se calcula a partir del detalle.
Entidades principales (OLTP)
• Cliente (id_cliente, nombre, tipo, zona)
• Producto (id_producto, nombre, marca, categoría)
• Categoría (id_categoria, nombre)
• Vendedor (id_vendedor, nombre, fecha_ingreso)
• Zona (id_zona, nombre, región)
• Pedido (id_pedido, fecha, id_cliente, id_vendedor)
• Detalle_Pedido (id_pedido, id_producto, cantidad, precio_unitario)
Actividades solicitadas (OLTP)
1. Elaborar el modelo entidad–relación.
2. Normalizar las tablas hasta 3FN.
3. Definir claves primarias y foráneas.
4. Crear el script SQL de la base transaccional.
5. Proponer consultas como:
o Ventas de un cliente en un mes.
o Productos más vendidos.
o Ventas por vendedor.

2️⃣PROBLEMA – MODELO DIMENSIONAL (DATA WAREHOUSE / BI)
Necesidad analítica
La gerencia requiere responder preguntas como:
• ¿Cuánto se vendió por mes, año y trimestre?
• ¿Qué productos generan más ingresos?
• ¿Qué vendedores y zonas tienen mejor desempeño?
• ¿Cómo evolucionan las ventas en el tiempo?
 Grano del modelo
 Una fila por producto vendido en un pedido.

Tabla de hechos

Hecho_Ventas
• id_fecha
• id_producto
• id_cliente
• id_vendedor
• id_zona
• cantidad_vendida
• importe_venta
• costo
• margen

Dimensiones

Dim_Fecha
• id_fecha
• fecha
• día
• mes
• nombre_mes
• trimestre
• año

Dim_Producto
• id_producto
• nombre_producto
• marca
• categoría

Dim_Cliente
• id_cliente
• nombre_cliente
• tipo_cliente

Dim_Vendedor
• id_vendedor
• nombre_vendedor
• antigüedad

Dim_Zona
• id_zona
• nombre_zona
• región

Esquema dimensional

Esquema estrella (Star Schema)

Actividades solicitadas (BI)
1. Diseñar el modelo dimensional.
2. Justificar el tipo de esquema.
3. Definir medidas e indicadores:
o Ventas totales
o Ticket promedio
o Margen por producto
4. Proponer consultas analíticas (SQL / DAX / MDX).
5. Diseñar dashboards:
o Ventas por tiempo
o Top productos
o Ranking de vendedores
o Ventas por zona
 KPIs sugeridos
• Ventas totales
• Crecimiento mensual
• Margen bruto %
• Ventas por vendedor
• Participación por categoría

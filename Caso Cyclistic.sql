/* Use Case - Cyclistic bike - share. 

Una vez descargados los archivos necesarios (en formato csv), los pasos que vamos a seguir son los siguientes: 
	1. Cargar cada archivo como una tabla individual en nuestra base de datos (Cyclistic). 
	2. Unir todas las tablas en una sola (Datos2022). 
	3. Limpiar los datos. 
	4. Analizar los datos. 

*/



/* CREAMOS UNA SOLA TABLA CON NUESTROS DATOS */

SELECT *
--FROM Cyclistic..Ene_2022
--FROM Cyclistic..Feb_2022
--FROM Cyclistic..Mar_2022
--FROM Cyclistic..Abr_2022
--FROM Cyclistic..May_2022
--FROM Cyclistic..Jun_2022
--FROM Cyclistic..Jul_2022
--FROM Cyclistic..Ago_2022
--FROM Cyclistic..Sept_2022
--FROM Cyclistic..Oct_2022
--FROM Cyclistic..Nov_2022
FROM Cyclistic..Dic_2022

--- Vamos a crear una sola tabla que agrupe todos los meses anteriores: 

drop table Datos2022;

SELECT * INTO Datos2022
FROM Cyclistic..Ene_2022
WHERE 1 = 0

INSERT INTO Datos2022 
SELECT * 
FROM Cyclistic..Ene_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Feb_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Mar_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Abr_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..May_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Jun_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Jul_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Ago_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Sept_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Oct_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Nov_2022

INSERT INTO Datos2022 
SELECT *
FROM Cyclistic..Dic_2022

--- Vamos a desglosar las columnas started_at (started_date y started_time) y ended_at (ended_date y ended_time): 

ALTER TABLE Datos2022
ADD started_date Date 

UPDATE Datos2022 
SET started_date = CONVERT(Date, started_at)

ALTER TABLE Datos2022
ADD started_time Time 

UPDATE Datos2022 
SET started_time = CONVERT(Time, started_at)

ALTER TABLE Datos2022
ADD ended_date Date 

UPDATE Datos2022 
SET ended_date = CONVERT(Date, ended_at)

ALTER TABLE Datos2022
ADD ended_time Time 

UPDATE Datos2022 
SET ended_time  = CONVERT(Time, ended_at)

--- Vamos a calcular el tiempo que conlleva cada viaje: 

ALTER TABLE Datos2022
ADD ride_length Time 

UPDATE Datos2022 
SET ride_length  = convert(Time, (ended_at - started_at))


/* LIMPIEZA DE DATOS */

--- Vamos a revisar que solo haya 2 tipos de miembros: 
SELECT DISTINCT(member_casual)
FROM Cyclistic..Datos2022

--- Tenemos que chequear el rango de las latitudes y longitudes:
SELECT MIN(start_lat) AS Min_start_lat, MAX(start_lat) AS Max_start_lat, 
MIN(end_lat) AS Min_end_lat, MAX(end_lat) AS Max_end_lat, 
MIN(start_lng) AS Min_start_lng, MAX(start_lng) AS Max_start_lng, 
MIN(end_lng) AS Min_end_lng, MAX(end_lng) AS Min_end_lng
FROM Cyclistic..Datos2022

--- Determinamos si los ride_id son valores únicos: 
 WITH CTE AS
 (
  SELECT *,
  ROW_NUMBER() OVER (PARTITION BY 
                    ride_id
                    ORDER BY ride_id) AS DUPLICADO
  FROM Cyclistic..Datos2022 
 )
 SELECT * FROM CTE 
 WHERE DUPLICADO > 1

 --- Observamos que hay ride_id repetidos. Vamos a observarlos más de cerca: 

SELECT ride_id, count(*) AS Cantidad
FROM Cyclistic..Datos2022
GROUP BY ride_id
HAVING count(*) > 1

SELECT *
FROM Cyclistic..Datos2022
WHERE ride_id = 'AA95B13191278F95'

SELECT *
FROM Cyclistic..Datos2022
WHERE ride_id = '968A43A024C8A4D9'

SELECT *
FROM Cyclistic..Datos2022
WHERE ride_id = 'B8274167BF354D61'
--- Por lo que se puede ver, son datos duplicados. Se deberá mantener solo uno de ellos. 
DELETE Duplicados
FROM
(
SELECT *
, DupRank = ROW_NUMBER() OVER (
              PARTITION BY ride_id
              ORDER BY (SELECT NULL)
            )
FROM Cyclistic..Datos2022
) AS Duplicados
WHERE DupRank > 1 

--- Vamos a buscar DATOS VACÍOS: 

SELECT *
FROM Cyclistic..Datos2022	
WHERE started_at = '' OR ended_at = ''
--- No hay espacios vacíos en estas columnas. 

SELECT *
FROM Cyclistic..Datos2022	
WHERE start_station_id = '' OR end_station_id = ''
--- Hay espacios vacíos en alguna de las dos columnas. 

SELECT *
FROM Cyclistic..Datos2022	
WHERE start_station_name = '' OR end_station_name = ''
--- Hay espacios vacíos en alguna de las dos columnas. 

SELECT *
FROM Cyclistic..Datos2022	
WHERE start_station_name = '' AND start_station_id = ''

SELECT *
FROM Cyclistic..Datos2022	
WHERE end_station_name = '' AND end_station_id = ''

--- Podemos observar que, en aquellas columnas en donde el start_station_id o end_station_id, el nombre de la estación tampoco está mencionado. 
--- Asimismo, las coordenadas (longitud y latitud) de la estación faltante no se encuentran completas y, por ello, no se podrían relacionar con alguna de las que sí
--- se encuentran en los datos. 

SELECT count(*)
FROM Cyclistic..Datos2022	
WHERE start_station_id = '' OR end_station_id = ''
--- En total son 1.261.974. 
--- El total de datos son 6.005.452
--- El porcentaje de filas que tienen datos vacíos equivale al 21.013%

--- Vamos a eliminar dichas filas ya que, a la hora de analizar los datos, nos las podríamos tomar en cuenta. 

DELETE FROM Cyclistic..Datos2022
WHERE start_station_name = '' AND start_station_id = ''

DELETE FROM Cyclistic..Datos2022
WHERE end_station_name = '' AND end_station_id = ''

--- Vamos a buscar los DATOS NULOS:

SELECT *
FROM Cyclistic..Datos2022	
WHERE started_at IS NULL AND ended_at IS NULL

SELECT *
FROM Cyclistic..Datos2022	
WHERE started_at IS NULL OR ended_at IS NULL
--- No hay vales nulos en ninguna de estas dos columnas. 

SELECT *
FROM Cyclistic..Datos2022	
WHERE start_station_id IS NULL AND end_station_id IS NULL

SELECT *
FROM Cyclistic..Datos2022	
WHERE start_station_id IS NULL OR end_station_id IS NULL
--- Tenemos valores nulos en alguna de ellas. 
--- Además, hay filas en las que la columna de 'end_station_id' se encuentra vacío.

SELECT count(*)
FROM Cyclistic..Datos2022	
WHERE start_station_id IS NULL 
--- No hay valores nulos en esta columna. 

SELECT count(*)
FROM Cyclistic..Datos2022	
WHERE end_station_id IS NULL
--- Hay 749.334 valores nulos en esta columna. 

SELECT count(*)
FROM Cyclistic..Datos2022	
WHERE end_station_id IS NULL AND end_station_name = ''
--- Hay 118.324 datos que no contienen el ID de la estación final, ni su nombre. A los mismos, los vamos a eliminar.

DELETE FROM Cyclistic..Datos2022
WHERE end_station_id IS NULL AND end_station_name = ''

--- A los restantes datos nulos, vamos a ver si los podemos 'matchear', a través de su nombre, con alguna de las estaciones que sí tenemos: 

SELECT *
FROM Cyclistic..Datos2022	
WHERE end_station_id IS NULL

SELECT DA.start_station_id, DA.start_station_name, DB.end_station_id, DB.end_station_name, 
DA.start_lat, DA.start_lng, DB.end_lat, DB.end_lng,
ISNULL(DB.end_station_id, DA.start_station_id) AS Coincidencia
FROM Cyclistic..Datos2022 DA
JOIN Cyclistic..Datos2022 DB
	ON DA.start_lat = DB.end_lat
	AND DA.start_lng = DB.end_lng
	AND DA.ride_id <> DB.ride_id
WHERE DB.end_station_id is null

--- Hay concidencias, entonces las vamos a reemplazar.

SET NOCOUNT ON
UPDATE DB
SET end_station_id = ISNULL(DB.end_station_id, DA.start_station_id)
FROM Cyclistic..Datos2022 DA
JOIN Cyclistic..Datos2022 DB
	ON DA.start_lat = DB.end_lat
	AND DA.start_lng = DB.end_lng
	AND DA.ride_id <> DB.ride_id
WHERE DB.end_station_id is null

--- Spoiler: Mi computadora nunca terminó de ejecutar el comando (claramente, se podría optimizar el comando) y, por cuestiones de tiempo, decidí eliminar los datos nulos.
--- Lo correcto sería ejecutar el comando anterior y, luego, ver que datos nulos restan y analizarlos para determinar qué conviene hacer. 

DELETE FROM Cyclistic..Datos2022
WHERE end_station_id is null

--- Analizamos los datos de las fechas: 

SELECT ride_id, started_date, ended_date, started_time, ended_time
FROM Cyclistic..Datos2022
WHERE (started_time > ended_time) AND (started_date >= ended_date)
--- Vemos que hay 97 viajes en donde la hora de comienzo es posterior a la de finalización. Esto no tiene sentido (puede que haya ocurrido un error 
--- en la carga de datos). Por lo tanto, se decide eliminarlos dado que van a alterar el cálculo del tiempo promedio de viaje. 

DELETE FROM Cyclistic..Datos2022
WHERE (started_time > ended_time) AND (started_date >= ended_date)

--- Por último, vamos a ver si hay datos extraños en las duraciones máximas y mínimas de viaje:
 SELECT MIN(ride_length), MAX(ride_length)
FROM Cyclistic..Datos2022

SELECT *
FROM Cyclistic..Datos2022
WHERE started_at = ended_at
--- Hay 207 viajes en donde la fecha y hora de inicio es igual a la fecha y hora de fin (por ende, la duración del viaje es 0). Esto puede ser un error del usuario, o bien, del sistema al registrar las salidas. 
--- De cualquier forma, vamos a eliminar estos datos
DELETE FROM Cyclistic..Datos2022
WHERE started_at = ended_at

SELECT *
FROM Cyclistic..Datos2022
WHERE ride_length > '23:00:00.0000000'
--- Hay 68 datos en donde la duración del viaje es mayor a 23 horas. Si bien puede ser que se trate de usuarios que 'olvidaron' devolver las bicicletas. 
--- Son casos extraños, los cuales desvían mucho el máximo, mínimo y el promedio de los tiempos de viaje. Por ende, los vamos a eliminar.
DELETE FROM Cyclistic..Datos2022
WHERE ride_length >= '23:00:00.0000000'

/* ANALIZAR LOS DATOS */

--- Contamos la cantidad total de datos:
SELECT COUNT(*) AS Total
FROM Cyclistic..Datos2022
--- Tenemos 3.738. 010 datos.

--- Determinamos los tipos de usarios que existen y la cantidad de paseos de acuerdo a su tipo:
SELECT member_casual, COUNT(*) AS Cantidad
FROM Cyclistic..Datos2022
GROUP BY member_casual
--- Casual: 1.489.054
--- Member: 2.248.956


--- Determinamos los tipos de bicicletas que hay en las estaciones y la cantidad de paseos de acuerdo a su tipo:
SELECT rideable_type, COUNT(1) AS Cantidad
FROM Cyclistic..Datos2022
GROUP BY rideable_type
--- Clasica: 2.196.634
--- Docked: 151.738
--- Eletrica: 1.389.638

--- Determinamos los tipos de bicicletas que hay en las estaciones y la cantidad de paseos de acuerdo a su tipo:
SELECT member_casual, rideable_type, COUNT(1) AS Cantidad
FROM Cyclistic..Datos2022
GROUP BY member_casual, rideable_type
ORDER BY member_casual
--- Usuario casual: Clásica (739.283), Docked (151.738) y Eléctrica (598.033). 
--- Usuario anual: Clásica (1.457.350) y Eléctrica (791.605). 

--- Determinar la cantidad de paseos realizados en cada estación: 

--- Starting stations --- 
SELECT start_station_id, start_station_name, Count(*) AS Paseos
FROM Cyclistic..Datos2022
GROUP BY start_station_id, start_station_name
ORDER BY Paseos DESC

--- Ending Stations ---
SELECT end_station_id, end_station_name, Count(*) AS Paseos
FROM Cyclistic..Datos2022
GROUP BY end_station_id, end_station_name
ORDER BY Paseos DESC

--- Lista de todos los paseos que arrancan y terminan en la misma estación, según el tipo de usuario y bicicleta utilizada: 
SELECT ride_id,start_station_id, start_station_name AS StationName, end_station_id, rideable_type, member_casual
FROM Cyclistic..Datos2022
WHERE start_station_id = end_station_id

--- Calculamos la cantidad:
SELECT start_station_name AS StationName, rideable_type, member_casual, COUNT(*) AS Cant_Paseos 
FROM Cyclistic..Datos2022
WHERE start_station_id = end_station_id
GROUP BY start_station_name, member_casual, rideable_type
ORDER BY member_casual, rideable_type, Cant_Paseos DESC

--- Determinamos la cantidad de paseos que arrancan y terminan en la misma estación, según la estación: 
SELECT start_station_id, start_station_name AS StationName, end_station_id, Count(*) AS Paseos
FROM Cyclistic..Datos2022
WHERE start_station_id = end_station_id
GROUP BY start_station_id, start_station_name, end_station_id
ORDER BY Paseos DESC

--- Determinamos la cantidad total de paseos que arrancan y terminan en la misma estación: 
SELECT Count(*) AS Paseos
FROM Cyclistic..Datos2022
WHERE start_station_id = end_station_id
--- El total es 253.928

--- Vamos a calcular qué mes utilizan más el servicio cada tipo de usuario:
SELECT member_casual, MONTH(started_at) AS Mes, COUNT(*) as Cantidad
FROM Cyclistic..Datos2022
GROUP BY member_casual, MONTH(started_at)
ORDER BY member_casual, Cantidad DESC
--- Podemos observar que no hay casi diferencia entre los meses de uso. 
--- Los meses fuertes son Julio, Agosto, Mayo y Octubre. 

--- Vamos a calcular en qué día de la semana utilizan más el servicio cada tipo de usuario:
SELECT member_casual, datepart(weekday, started_date) AS Dia_Sem, COUNT(*) as Cantidad
FROM Cyclistic..Datos2022
GROUP BY member_casual, datepart(weekday, started_date)
ORDER BY member_casual, Cantidad DESC
--- Podemos observar que el día de la semana que más usan los miembros casuales es el Domingo, seguido por el Lunes. 
--- En cambio, los miembros anuales utilizan más el servicio los días Miércoles y Jueves. 

--- Determinamos la mínima y máxima duración de viaje registrada:
SELECT MIN(ride_length), MAX(ride_length)
FROM Cyclistic..Datos2022

--- Determinamos tiempo promedio de viaje para cada tipo de usuario:
SELECT member_casual, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio
FROM Cyclistic..Datos2022
GROUP BY member_casual
--- Podemos observar que los usuarios casuales suelen utilizar por más tiempo el servicio, cuando lo utilizan. 

--- Calculamos el tiempo promedio de viaje por mes para los miembros casuales:
SELECT MONTH(started_at) AS Mes, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual'
GROUP BY MONTH(started_at) 
ORDER BY MONTH(started_at)

--- Calculamos el tiempo promedio de viaje por mes para los miembros anuales:
SELECT MONTH(started_at) AS Mes, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio
FROM Cyclistic..Datos2022
WHERE member_casual = 'member'
GROUP BY MONTH(started_at) 
ORDER BY MONTH(started_at)


/* CREAMOS TABLAS PARA LAS VISUALIZACIONES */

DROP TABLE Cant_Paseos_Usuarios

--- Tabla 1 ---
SELECT member_casual, COUNT(*) AS Cantidad_Paseos INTO Cant_Paseos_Usuarios
FROM Cyclistic..Datos2022
GROUP BY member_casual
ORDER BY COUNT(*) DESC

SELECT *
FROM Cyclistic..Cant_Paseos_Usuarios

--- Tabla 2 ---
DROP TABLE Cant_Paseos_Bicicletas

SELECT rideable_type, COUNT(1) AS Cantidad_Paseos INTO Cant_Paseos_Bicicletas_Casual
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual' 
GROUP BY rideable_type
ORDER BY COUNT(*) DESC

SELECT *
FROM Cyclistic..Cant_Paseos_Bicicletas_Casual

--- Tabla 3 ---
DROP TABLE Paseos_Usuarios_Bicis

SELECT member_casual, rideable_type, COUNT(1) AS Cant_Paseos INTO Paseos_Usuarios_Bicis
FROM Cyclistic..Datos2022
GROUP BY member_casual, rideable_type
ORDER BY member_casual, COUNT(*) DESC

SELECT *
FROM Cyclistic..Paseos_Usuarios_Bicis

--- Tabla 4 --- 
DROP TABLE Cyclistic..Paseos_Estacion_Inicio

SELECT start_station_id, start_station_name, Count(*) AS Cant_Paseos INTO Paseos_Estacion_Inicio_Casual
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual'
GROUP BY start_station_id, start_station_name
ORDER BY count(*) DESC

SELECT *
FROM Cyclistic..Paseos_Estacion_Inicio_Casual

SELECT start_station_id, start_station_name, Count(*) AS Cant_Paseos INTO Paseos_Estacion_Inicio_Anual
FROM Cyclistic..Datos2022
WHERE member_casual = 'member'
GROUP BY start_station_id, start_station_name
ORDER BY count(*) DESC

SELECT *
FROM Cyclistic..Paseos_Estacion_Inicio_Anual

--- Tabla 5 ---
DROP TABLE Cyclistic..Paseos_Estacion_Fin

SELECT end_station_id, end_station_name, Count(*) AS Cant_Paseos INTO Paseos_Estacion_Fin_Casual
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual'
GROUP BY end_station_id, end_station_name
ORDER BY count(*) DESC

SELECT *
FROM Cyclistic..Paseos_Estacion_Fin_Casual

SELECT end_station_id, end_station_name, Count(*) AS Cant_Paseos INTO Paseos_Estacion_Fin_Anual
FROM Cyclistic..Datos2022
WHERE member_casual = 'member'
GROUP BY end_station_id, end_station_name
ORDER BY count(*) DESC

SELECT *
FROM Cyclistic..Paseos_Estacion_Fin_Anual


--- Tabla 6 ---
SELECT start_station_name AS StationName, rideable_type, member_casual, COUNT(*) AS Cant_Paseos INTO Paseos_Estacion_Usuario_Bici
FROM Cyclistic..Datos2022
WHERE start_station_id = end_station_id
GROUP BY start_station_name, member_casual, rideable_type
ORDER BY member_casual, rideable_type, Cant_Paseos DESC

SELECT *
FROM Cyclistic..Paseos_Estacion_Usuario_Bici

--- Tabla 7 ---
SELECT member_casual, MONTH(started_at) AS Mes, COUNT(*) as Cantidad_Paseos INTO Cant_Paseos_Usuarios_Mes
FROM Cyclistic..Datos2022
GROUP BY member_casual, MONTH(started_at)
ORDER BY member_casual, Cantidad_Paseos DESC

SELECT *
FROM Cyclistic..Cant_Paseos_Usuarios_Mes

ALTER TABLE Cant_Paseos_Usuarios_Mes
ADD Mes_Nombre varchar(255);

UPDATE Cant_Paseos_Usuarios_Mes
SET Mes_Nombre = CASE
	WHEN Mes = 1 THEN 'January'
	WHEN Mes = 2 THEN 'February'
	WHEN Mes = 3 THEN 'March'
	WHEN Mes = 4 THEN 'April'
	WHEN Mes = 5 THEN 'May'
	WHEN Mes = 6 THEN 'June'
	WHEN Mes = 7 THEN 'July'
	WHEN Mes = 8 THEN 'August'
	WHEN Mes = 9 THEN 'September'
	WHEN Mes = 10 THEN 'October'
	WHEN Mes = 11 THEN 'November'
	ELSE 'Dicember'
END

--- Tabla 8 ---
DROP TABLE Cant_Paseos_Sem

SELECT member_casual, datepart(weekday, started_date) AS Sem, COUNT(*) as Cantidad_Paseos INTO Cant_Paseos_Sem
FROM Cyclistic..Datos2022
GROUP BY member_casual, datepart(weekday, started_date)
ORDER BY member_casual, Cantidad_Paseos DESC

SELECT *
FROM Cyclistic..Cant_Paseos_Sem

ALTER TABLE Cant_Paseos_Sem
ADD SemNombre varchar(255);

UPDATE Cant_Paseos_Sem
SET SemNombre = CASE
	WHEN Sem = 1 THEN 'Monday'
	WHEN Sem = 2 THEN 'Tuesday'
	WHEN Sem = 3 THEN 'Wednesday'
	WHEN Sem = 4 THEN 'Thursday'
	WHEN Sem = 5 THEN 'Friday'
	WHEN Sem = 6 THEN 'Saturday'
	ELSE 'Sunday'
END

--- Tabla 9 ---
SELECT member_casual, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio INTO Tiempo_Prom_Usuarios
FROM Cyclistic..Datos2022
GROUP BY member_casual

SELECT *
FROM Cyclistic..Tiempo_Prom_Usuarios

--- Tabla 10 ---
SELECT MONTH(started_at) AS Mes, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio INTO Tiempo_Prom_Casuales_Mes
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual'
GROUP BY MONTH(started_at) 
ORDER BY MONTH(started_at)

SELECT *
FROM Cyclistic..Tiempo_Prom_Casuales_Mes

ALTER TABLE Tiempo_Prom_Casuales_Mes
ADD Mes_Nombre varchar(255);

UPDATE Tiempo_Prom_Casuales_Mes
SET Mes_Nombre = CASE
	WHEN Mes = 1 THEN 'January'
	WHEN Mes = 2 THEN 'February'
	WHEN Mes = 3 THEN 'March'
	WHEN Mes = 4 THEN 'April'
	WHEN Mes = 5 THEN 'May'
	WHEN Mes = 6 THEN 'June'
	WHEN Mes = 7 THEN 'July'
	WHEN Mes = 8 THEN 'August'
	WHEN Mes = 9 THEN 'September'
	WHEN Mes = 10 THEN 'October'
	WHEN Mes = 11 THEN 'November'
	ELSE 'Dicember'
END

--- Tabla 11 ---
DROP TABLE Cyclistic..Tiempo_Prom_Anuales_Mes

SELECT MONTH(started_at) AS Mes, CAST(CAST(AVG(CAST(CAST(ride_length as datetime) as float)) as datetime) as time) TiempoPromedio INTO Tiempo_Prom_Anuales_Mes_Nueva
FROM Cyclistic..Datos2022
WHERE member_casual = 'member'
GROUP BY MONTH(started_at) 
ORDER BY MONTH(started_at)

SELECT *
FROM Cyclistic..Tiempo_Prom_Anuales_Mes_Nueva

ALTER TABLE Cyclistic..Tiempo_Prom_Anuales_Mes_Nueva
ADD Mes_Nombre varchar(255);

UPDATE Cyclistic..Tiempo_Prom_Anuales_Mes_Nueva
SET Mes_Nombre = CASE
	WHEN Mes = 1 THEN 'January'
	WHEN Mes = 2 THEN 'February'
	WHEN Mes = 3 THEN 'March'
	WHEN Mes = 4 THEN 'April'
	WHEN Mes = 5 THEN 'May'
	WHEN Mes = 6 THEN 'June'
	WHEN Mes = 7 THEN 'July'
	WHEN Mes = 8 THEN 'August'
	WHEN Mes = 9 THEN 'September'
	WHEN Mes = 10 THEN 'October'
	WHEN Mes = 11 THEN 'November'
	ELSE 'Dicember'
END

--- Tabla 12 ---
DROP TABLE Cant_Paseos_Bicicletas

SELECT rideable_type, COUNT(1) AS Cantidad_Paseos INTO Cant_Paseos_Bicicletas_Anual
FROM Cyclistic..Datos2022
WHERE member_casual = 'member' 
GROUP BY rideable_type
ORDER BY COUNT(*) DESC

SELECT *
FROM Cyclistic..Cant_Paseos_Bicicletas_Anual

--- Tabla 13 ---
SELECT rideable_type, started_at, COUNT(*) AS Cant_Paseos INTO Frecuencia_Paseos_Casuales_Bici
FROM Cyclistic..Datos2022
WHERE member_casual = 'casual'
GROUP BY rideable_type, started_at
ORDER BY rideable_type, COUNT(*) DESC

SELECT *
FROM Cyclistic..Frecuencia_Paseos_Casuales_Bici

--- Tabla 14 --- 
SELECT rideable_type, started_at, COUNT(*) AS Cant_Paseos INTO Frecuencia_Paseos_Anuales_Bici
FROM Cyclistic..Datos2022
WHERE member_casual = 'member'
GROUP BY rideable_type, started_at
ORDER BY rideable_type, COUNT(*) DESC





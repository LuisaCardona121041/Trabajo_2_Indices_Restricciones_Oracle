
-- =====================================================
-- UNIVERSIDAD INTERNACIONAL DE LA RIOJA (UNIR)
-- ASIGNATURA: BASES DE DATOS AVANZADAS
-- ACTIVIDAD 2: INDICES Y RESTRICCIONES EN ORACLE
-- =====================================================
-- ARCHIVO: 12_diagnostico_archivos_redo.sql
-- DESCRIPCION:
-- Identificar el modo de archivado de Oracle
-- Database y consultar la configuracion de
-- los grupos y archivos REDO en linea.
--
-- Examinar el estado de los grupos REDO,
-- su capacidad, secuencia y archivos asociados.
--
-- ENTORNO: Oracle Database 21c XE
-- CONEXION: SYS_Admin_XE
-- USUARIO: SYS
-- ROL: SYSDBA
-- CONTENEDOR: CDB$ROOT
--
-- TIPO DE OPERACION:
-- Consultas administrativas de solo lectura.
--
-- REQUISITOS PREVIOS:
-- Disponer de una conexion administrativa
-- con privilegios para consultar las vistas
-- dinamicas V$DATABASE, V$LOG y V$LOGFILE.
--
-- IMPORTANTE:
-- Durante el laboratorio, el usuario HR no
-- tenia permisos para consultar V$DATABASE
-- y Oracle devolvio el error ORA-00942.
--
-- Por este motivo, las consultas se ejecutaron
-- mediante la conexion SYS_Admin_XE.
--
-- No modificar el modo de archivado.
-- No eliminar, renombrar ni alterar archivos REDO.
-- No ejecutar instrucciones ALTER DATABASE.
-- =====================================================


-- =====================================================
-- PASO 1. VERIFICAR EL CONTEXTO DE CONEXION
-- =====================================================
-- Comprobar que el procedimiento se ejecuta
-- con el usuario SYS en el contenedor CDB$ROOT.
--
-- RESULTADO OBTENIDO EN EL LABORATORIO:
-- USUARIO: SYS.
-- CONTENEDOR: CDB$ROOT.
--
-- IMPORTANTE:
-- Esta consulta identifica el usuario y
-- contenedor, pero no muestra directamente
-- el rol administrativo de la conexion.

SELECT
    USER AS usuario,
    SYS_CONTEXT('USERENV', 'CON_NAME') AS contenedor
FROM dual;


-- =====================================================
-- PASO 2. CONSULTAR EL MODO DE ARCHIVADO
-- =====================================================
-- Consultar el modo de funcionamiento de
-- la base de datos mediante V$DATABASE.
--
-- V$DATABASE:
-- Proporciona informacion general de la
-- base de datos obtenida del archivo de control.
--
-- CAMPOS CONSULTADOS:
-- NAME:
-- Nombre de la base de datos.
--
-- LOG_MODE:
-- Modo de archivado de los registros REDO.
-- Puede indicar ARCHIVELOG o NOARCHIVELOG.
--
-- OPEN_MODE:
-- Estado de apertura de la base de datos.
--
-- RESULTADO OBTENIDO EN EL LABORATORIO:
-- BASE_DATOS: XE.
-- MODO_ARCHIVADO: NOARCHIVELOG.
-- ESTADO_APERTURA: READ WRITE.

SELECT
    name AS base_datos,
    log_mode AS modo_archivado,
    open_mode AS estado_apertura
FROM v$database;


-- =====================================================
-- PASO 3. CONSULTAR LOS GRUPOS REDO
-- =====================================================
-- Identificar los grupos REDO en linea
-- mediante la vista dinamica V$LOG.
--
-- V$LOG:
-- Contiene informacion sobre los grupos
-- REDO registrados en el archivo de control.
--
-- CAMPOS CONSULTADOS:
-- GROUP#:
-- Identificador del grupo REDO.
--
-- SEQUENCE#:
-- Numero de secuencia del registro REDO.
--
-- BYTES:
-- Capacidad del grupo expresada en bytes.
-- Se convierte a megabytes para facilitar
-- la interpretacion.
--
-- MEMBERS:
-- Cantidad de archivos miembros del grupo.
--
-- ARCHIVED:
-- Indica si el contenido del registro
-- correspondiente fue archivado.
--
-- STATUS:
-- Estado actual del grupo REDO.
--
-- ESTADOS RELEVANTES:
-- CURRENT: Grupo REDO actual.
-- ACTIVE: Necesario para recuperacion de instancia.
-- INACTIVE: Ya no es necesario para esa
-- recuperacion y puede reutilizarse cuando
-- Oracle lo permita.
--
-- IMPORTANTE:
-- El estado y las secuencias pueden cambiar
-- durante el funcionamiento de Oracle.

SELECT
    group# AS grupo,
    sequence# AS secuencia,
    ROUND(bytes / 1024 / 1024, 2) AS tamano_mb,
    members AS miembros,
    archived AS archivado,
    status AS estado
FROM v$log
ORDER BY
    group#;


-- =====================================================
-- PASO 4. CONSULTAR LOS ARCHIVOS FISICOS REDO
-- =====================================================
-- Identificar los archivos miembros de cada
-- grupo REDO mediante la vista V$LOGFILE.
--
-- V$LOGFILE:
-- Proporciona informacion sobre los archivos
-- REDO y su pertenencia a los diferentes grupos.
--
-- CAMPOS CONSULTADOS:
-- GROUP#:
-- Identificador del grupo REDO.
--
-- TYPE:
-- Tipo de archivo REDO.
-- ONLINE: Archivo REDO en linea.
-- STANDBY: Archivo REDO de espera.
--
-- STATUS:
-- Estado del archivo miembro.
--
-- MEMBER:
-- Ubicacion fisica del archivo REDO.
--
-- IMPORTANTE:
-- En V$LOGFILE, un valor NULL en STATUS
-- indica que el archivo esta en uso.
--
-- No se deben modificar manualmente los
-- archivos identificados por esta consulta.

SELECT
    group# AS grupo,
    type AS tipo,
    status AS estado,
    member AS archivo
FROM v$logfile
ORDER BY
    group#,
    member;


-- =====================================================
-- RESULTADO OBTENIDO EN EL LABORATORIO
-- =====================================================
-- BASE DE DATOS:
-- XE.
--
-- MODO DE ARCHIVADO:
-- NOARCHIVELOG.
--
-- ESTADO DE APERTURA:
-- READ WRITE.
--
-- CONFIGURACION REDO OBSERVADA:
--
-- GRUPO 1:
-- Secuencia: 4.
-- Tamano: 200 MB.
-- Miembros: 1.
-- Archivado: NO.
-- Estado: INACTIVE.
-- Archivo: REDO01.LOG.
--
-- GRUPO 2:
-- Secuencia: 5.
-- Tamano: 200 MB.
-- Miembros: 1.
-- Archivado: NO.
-- Estado: INACTIVE.
-- Archivo: REDO02.LOG.
--
-- GRUPO 3:
-- Secuencia: 6.
-- Tamano: 200 MB.
-- Miembros: 1.
-- Archivado: NO.
-- Estado: CURRENT.
-- Archivo: REDO03.LOG.
--
-- RESUMEN:
-- Se identificaron tres grupos REDO.
-- Cada grupo tenia una capacidad de 200 MB.
--
-- Capacidad total observada: 600 MB.
-- Total de archivos miembros: 3.
--
-- Cada grupo tenia un unico miembro, por
-- lo que no se observo multiplexacion de
-- archivos REDO dentro de los grupos.
--
-- Los archivos consultados eran de tipo ONLINE.
-- Su columna STATUS presentaba valores NULL,
-- que indican archivos en uso en V$LOGFILE.
--
-- INTERPRETACION:
-- La base de datos operaba en modo NOARCHIVELOG.
-- Este modo permite reutilizar los archivos REDO
-- sin archivar previamente sus grupos completos,
-- cuando Oracle determina que pueden reutilizarse.
--
-- OBSERVACION:
-- Las secuencias y los estados de los grupos
-- corresponden al momento de la consulta.
-- Pueden cambiar en futuras ejecuciones.
--
-- Las consultas realizadas no modificaron
-- la configuracion ni los archivos REDO.
--
-- ADVERTENCIA:
-- Este archivo es exclusivamente de diagnostico.
-- No ejecutar modificaciones administrativas
-- sobre la instancia o sus archivos REDO.
-- =====================================================
-- FIN DEL ARCHIVO: 12_diagnostico_archivos_redo.sql
-- =====================================================


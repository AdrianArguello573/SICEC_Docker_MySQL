-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital_nom004
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `consentimientos`
--

DROP TABLE IF EXISTS `consentimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `consentimientos` (
  `id_consentimiento` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_medico_informa` int unsigned NOT NULL,
  `titulo_documento` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `acto_autorizado` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `riesgos_beneficios` text COLLATE utf8mb4_unicode_ci,
  `lugar_fecha` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nombre_firmante` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parentesco_firmante` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Si no firma el paciente',
  `huella_hash` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hash de huella digital en lugar de firma',
  `testigo1_nombre` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `testigo2_nombre` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_firma` datetime NOT NULL,
  `revocado` tinyint(1) DEFAULT '0',
  `fecha_revocacion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_consentimiento`),
  KEY `fk_cons_medico` (`id_medico_informa`),
  KEY `idx_cons_paciente` (`id_paciente`),
  CONSTRAINT `fk_cons_medico` FOREIGN KEY (`id_medico_informa`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_cons_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `consentimientos`
--

LOCK TABLES `consentimientos` WRITE;
/*!40000 ALTER TABLE `consentimientos` DISABLE KEYS */;
/*!40000 ALTER TABLE `consentimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `encuentros`
--

DROP TABLE IF EXISTS `encuentros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `encuentros` (
  `id_encuentro` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_servicio` int unsigned NOT NULL,
  `id_medico_responsable` int unsigned NOT NULL,
  `tipo_encuentro` enum('Consulta Externa','Urgencias','Hospitalizaci├│n') COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_hora_inicio` datetime NOT NULL,
  `fecha_hora_fin` datetime DEFAULT NULL,
  `numero_cama` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `motivo_egreso` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id_encuentro`),
  KEY `fk_enc_servicio` (`id_servicio`),
  KEY `fk_enc_medico` (`id_medico_responsable`),
  KEY `idx_enc_paciente` (`id_paciente`),
  KEY `idx_enc_fecha` (`fecha_hora_inicio`),
  CONSTRAINT `fk_enc_medico` FOREIGN KEY (`id_medico_responsable`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enc_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `pacientes` (`id_paciente`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_enc_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id_servicio`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `encuentros`
--

LOCK TABLES `encuentros` WRITE;
/*!40000 ALTER TABLE `encuentros` DISABLE KEYS */;
INSERT INTO `encuentros` VALUES (1,1,1,1,'Hospitalizaci├│n','2025-01-15 08:30:00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `encuentros` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log_auditoria`
--

DROP TABLE IF EXISTS `log_auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log_auditoria` (
  `id_log` bigint unsigned NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `id_registro_afectado` int unsigned DEFAULT NULL,
  `accion` enum('INSERT','UPDATE','DELETE_LOGICO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `usuario_db` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `detalles` json DEFAULT NULL,
  PRIMARY KEY (`id_log`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log_auditoria`
--

LOCK TABLES `log_auditoria` WRITE;
/*!40000 ALTER TABLE `log_auditoria` DISABLE KEYS */;
INSERT INTO `log_auditoria` VALUES (1,'notas_evolucion',3,'INSERT','root@localhost','2026-10-21 00:02:54','{\"id_autor\": 1, \"id_encuentro\": 1}');
/*!40000 ALTER TABLE `log_auditoria` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_log_auditoria_before_insert` BEFORE INSERT ON `log_auditoria` FOR EACH ROW BEGIN
    IF NEW.usuario_db IS NULL THEN
        SET NEW.usuario_db = CURRENT_USER();
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notas_enfermeria`
--

DROP TABLE IF EXISTS `notas_enfermeria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_enfermeria` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_enfermera` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `turno` enum('Matutino','Vespertino','Nocturno') COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Estado del paciente, intervenciones, evaluaci├│n',
  PRIMARY KEY (`id_nota`),
  KEY `fk_nenf_enfermera` (`id_enfermera`),
  KEY `idx_nenf_encuentro` (`id_encuentro`),
  CONSTRAINT `fk_nenf_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_nenf_enfermera` FOREIGN KEY (`id_enfermera`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_enfermeria`
--

LOCK TABLES `notas_enfermeria` WRITE;
/*!40000 ALTER TABLE `notas_enfermeria` DISABLE KEYS */;
/*!40000 ALTER TABLE `notas_enfermeria` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notas_evolucion`
--

DROP TABLE IF EXISTS `notas_evolucion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_evolucion` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_autor` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `evolucion_texto` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `plan_tratamiento` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_nota`),
  KEY `fk_ne_autor` (`id_autor`),
  KEY `idx_ne_encuentro` (`id_encuentro`),
  KEY `idx_ne_fecha` (`fecha_hora_registro`),
  CONSTRAINT `fk_ne_autor` FOREIGN KEY (`id_autor`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ne_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_evolucion`
--

LOCK TABLES `notas_evolucion` WRITE;
/*!40000 ALTER TABLE `notas_evolucion` DISABLE KEYS */;
INSERT INTO `notas_evolucion` VALUES (1,1,1,'2025-01-16 09:00:00','Paciente refiere mejor├¡a del dolor...','Continuar mismo manejo'),(2,1,1,'2025-01-17 09:00:00','Paciente estable, sin dolor. Se programa alta.','Alta m├®dica con seguimiento ambulatorio.'),(3,1,1,'2025-01-19 09:00:00','Prueba final de trigger de auditoria.','Ninguno.');
/*!40000 ALTER TABLE `notas_evolucion` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_notas_evolucion_after_insert` AFTER INSERT ON `notas_evolucion` FOR EACH ROW INSERT INTO log_auditoria (tabla_afectada, id_registro_afectado, accion, detalles)
VALUES ('notas_evolucion', NEW.id_nota, 'INSERT', JSON_OBJECT('id_encuentro', NEW.id_encuentro, 'id_autor', NEW.id_autor)) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_notas_evolucion_before_delete` BEFORE DELETE ON `notas_evolucion` FOR EACH ROW SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las notas clinicas no se pueden eliminar fisicamente. Utilice baja logica o campos de revocacion.' */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `notas_ingreso`
--

DROP TABLE IF EXISTS `notas_ingreso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_ingreso` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_autor` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `resumen_interrogatorio` text COLLATE utf8mb4_unicode_ci,
  `exploracion_fisica` text COLLATE utf8mb4_unicode_ci,
  `resultados_estudios` text COLLATE utf8mb4_unicode_ci,
  `tratamiento` text COLLATE utf8mb4_unicode_ci,
  `pronostico` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_nota`),
  KEY `fk_ning_encuentro` (`id_encuentro`),
  KEY `fk_ning_autor` (`id_autor`),
  CONSTRAINT `fk_ning_autor` FOREIGN KEY (`id_autor`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ning_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_ingreso`
--

LOCK TABLES `notas_ingreso` WRITE;
/*!40000 ALTER TABLE `notas_ingreso` DISABLE KEYS */;
INSERT INTO `notas_ingreso` VALUES (1,1,1,'2025-01-15 09:00:00','Paciente masculino de 44 a├▒os...',NULL,NULL,'Hidrataci├│n, analgesia','Favorable');
/*!40000 ALTER TABLE `notas_ingreso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notas_iniciales`
--

DROP TABLE IF EXISTS `notas_iniciales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_iniciales` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_autor` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `motivo_atencion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `resumen_interrogatorio` text COLLATE utf8mb4_unicode_ci,
  `exploracion_fisica` text COLLATE utf8mb4_unicode_ci,
  `estado_mental` text COLLATE utf8mb4_unicode_ci,
  `diagnosticos` text COLLATE utf8mb4_unicode_ci COMMENT 'Puede registrar c├│digo CIE-10',
  `tratamiento` text COLLATE utf8mb4_unicode_ci,
  `pronostico` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_nota`),
  KEY `fk_ni_autor` (`id_autor`),
  KEY `idx_ni_encuentro` (`id_encuentro`),
  CONSTRAINT `fk_ni_autor` FOREIGN KEY (`id_autor`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ni_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_iniciales`
--

LOCK TABLES `notas_iniciales` WRITE;
/*!40000 ALTER TABLE `notas_iniciales` DISABLE KEYS */;
/*!40000 ALTER TABLE `notas_iniciales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notas_postoperatorias`
--

DROP TABLE IF EXISTS `notas_postoperatorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_postoperatorias` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_autor` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `diagnostico_preoperatorio` text COLLATE utf8mb4_unicode_ci,
  `operacion_planeada` text COLLATE utf8mb4_unicode_ci,
  `hallazgos` text COLLATE utf8mb4_unicode_ci,
  `tecnica_quirurgica` text COLLATE utf8mb4_unicode_ci,
  `pronostico` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_nota`),
  KEY `fk_npost_encuentro` (`id_encuentro`),
  KEY `fk_npost_autor` (`id_autor`),
  CONSTRAINT `fk_npost_autor` FOREIGN KEY (`id_autor`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_npost_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_postoperatorias`
--

LOCK TABLES `notas_postoperatorias` WRITE;
/*!40000 ALTER TABLE `notas_postoperatorias` DISABLE KEYS */;
/*!40000 ALTER TABLE `notas_postoperatorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notas_preoperatorias`
--

DROP TABLE IF EXISTS `notas_preoperatorias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notas_preoperatorias` (
  `id_nota` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_autor` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `fecha_cirugia` date DEFAULT NULL,
  `diagnostico` text COLLATE utf8mb4_unicode_ci,
  `plan_quirurgico` text COLLATE utf8mb4_unicode_ci,
  `tipo_intervencion` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `riesgo_quirurgico` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cuidados_preoperatorios` text COLLATE utf8mb4_unicode_ci,
  `pronostico` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_nota`),
  KEY `fk_npre_encuentro` (`id_encuentro`),
  KEY `fk_npre_autor` (`id_autor`),
  CONSTRAINT `fk_npre_autor` FOREIGN KEY (`id_autor`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_npre_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notas_preoperatorias`
--

LOCK TABLES `notas_preoperatorias` WRITE;
/*!40000 ALTER TABLE `notas_preoperatorias` DISABLE KEYS */;
/*!40000 ALTER TABLE `notas_preoperatorias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacientes`
--

DROP TABLE IF EXISTS `pacientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacientes` (
  `id_paciente` int unsigned NOT NULL AUTO_INCREMENT,
  `numero_expediente` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'N├║mero de expediente institucional',
  `nombre_completo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `sexo` enum('M','F','Otro') COLLATE utf8mb4_unicode_ci NOT NULL,
  `curp` varchar(18) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `familiar_responsable` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) DEFAULT '1' COMMENT 'Baja l├│gica, nunca eliminar',
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `numero_expediente` (`numero_expediente`),
  UNIQUE KEY `curp` (`curp`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacientes`
--

LOCK TABLES `pacientes` WRITE;
/*!40000 ALTER TABLE `pacientes` DISABLE KEYS */;
INSERT INTO `pacientes` VALUES (1,'EXP-2025-001','Juan P├®rez L├│pez','1980-05-15','M','PELJ800515HDFRRN01',NULL,NULL,'2026-10-21 00:00:19',1);
/*!40000 ALTER TABLE `pacientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal_salud`
--

DROP TABLE IF EXISTS `personal_salud`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_salud` (
  `id_personal` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre_completo` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cedula_profesional` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_personal` enum('M├®dico','Enfermera','Anestesi├│logo','Cirujano','Otro') COLLATE utf8mb4_unicode_ci NOT NULL,
  `especialidad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cargo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `firma_hash` varchar(256) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Hash de firma electr├│nica para verificar autor├¡a',
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id_personal`),
  UNIQUE KEY `cedula_profesional` (`cedula_profesional`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal_salud`
--

LOCK TABLES `personal_salud` WRITE;
/*!40000 ALTER TABLE `personal_salud` DISABLE KEYS */;
INSERT INTO `personal_salud` VALUES (1,'Dr. Carlos Mendoza','1234567','M├®dico','Medicina Interna',NULL,'18e295b2dc834acec9ff14430d87ed0e22dd0a817681dde350f4abe0b2abdbe2',1),(2,'Enf. Mar├¡a Gonz├ílez','7654321','Enfermera','General',NULL,'509f8c32d44a8c8270bb525662a4e4ed60bc4a73756112c3bca87437003356a0',1),(3,'Dr. Luis Ram├¡rez','2468135','Anestesi├│logo','Anestesiolog├¡a',NULL,'b0a1cc38c08f29fab40859789b7652cd8b1df9f0d36f84b6ff0074ff23c80b47',1);
/*!40000 ALTER TABLE `personal_salud` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registros_anestesia`
--

DROP TABLE IF EXISTS `registros_anestesia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registros_anestesia` (
  `id_registro` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `id_anestesiologo` int unsigned NOT NULL,
  `fecha_hora_inicio` datetime NOT NULL,
  `fecha_hora_fin` datetime DEFAULT NULL,
  `tipo_anestesia` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `medicamentos` text COLLATE utf8mb4_unicode_ci,
  `monitoreo` text COLLATE utf8mb4_unicode_ci,
  `incidencias` text COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id_registro`),
  KEY `fk_ra_encuentro` (`id_encuentro`),
  KEY `fk_ra_anestesiologo` (`id_anestesiologo`),
  CONSTRAINT `fk_ra_anestesiologo` FOREIGN KEY (`id_anestesiologo`) REFERENCES `personal_salud` (`id_personal`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_ra_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registros_anestesia`
--

LOCK TABLES `registros_anestesia` WRITE;
/*!40000 ALTER TABLE `registros_anestesia` DISABLE KEYS */;
/*!40000 ALTER TABLE `registros_anestesia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicios` (
  `id_servicio` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre_servicio` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id_servicio`),
  UNIQUE KEY `nombre_servicio` (`nombre_servicio`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicios`
--

LOCK TABLES `servicios` WRITE;
/*!40000 ALTER TABLE `servicios` DISABLE KEYS */;
INSERT INTO `servicios` VALUES (2,'Cirug├¡a General'),(1,'Medicina Interna'),(4,'Pediatr├¡a'),(3,'Urgencias');
/*!40000 ALTER TABLE `servicios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signos_vitales`
--

DROP TABLE IF EXISTS `signos_vitales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signos_vitales` (
  `id_signo` int unsigned NOT NULL AUTO_INCREMENT,
  `id_encuentro` int unsigned NOT NULL,
  `fecha_hora_registro` datetime NOT NULL,
  `ta_sistolica` smallint unsigned DEFAULT NULL COMMENT 'Presi├│n arterial sist├│lica',
  `ta_diastolica` smallint unsigned DEFAULT NULL,
  `frecuencia_cardiaca` smallint unsigned DEFAULT NULL,
  `frecuencia_respiratoria` smallint unsigned DEFAULT NULL,
  `temperatura` decimal(4,1) DEFAULT NULL,
  `spo2` tinyint unsigned DEFAULT NULL,
  `peso_kg` decimal(5,2) DEFAULT NULL,
  `talla_cm` decimal(5,1) DEFAULT NULL,
  PRIMARY KEY (`id_signo`),
  KEY `idx_sv_encuentro` (`id_encuentro`),
  CONSTRAINT `fk_sv_encuentro` FOREIGN KEY (`id_encuentro`) REFERENCES `encuentros` (`id_encuentro`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `signos_vitales`
--

LOCK TABLES `signos_vitales` WRITE;
/*!40000 ALTER TABLE `signos_vitales` DISABLE KEYS */;
INSERT INTO `signos_vitales` VALUES (1,1,'2025-01-15 08:35:00',120,80,72,NULL,36.5,98,NULL,NULL);
/*!40000 ALTER TABLE `signos_vitales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'hospital_nom004'
--

--
-- Dumping routines for database 'hospital_nom004'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-21 11:46:01

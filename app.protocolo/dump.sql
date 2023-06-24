--
-- Table structure for table `biddings`
--

DROP SCHEMA IF EXISTS `sisprotocolo` ;

-- -----------------------------------------------------
-- Schema sisprotocolo
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `sisprotocolo` DEFAULT CHARACTER SET utf8 ;
USE `sisprotocolo` ;

--
-- Table structure for table `suppliers`
--

DROP TABLE IF EXISTS `sisprotocolo`.`suppliers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`suppliers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `cnpj` varchar(18) DEFAULT NULL,
  `details` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB 
COMMENT='Fornecedores';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `oms`
--

DROP TABLE IF EXISTS `sisprotocolo`.`oms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`oms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) DEFAULT NULL,
  `naval_indicative` varchar(20) DEFAULT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oms`
--

LOCK TABLES `sisprotocolo`.`oms` WRITE;
/*!40000 ALTER TABLE `oms` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`oms` VALUES (1,'OM PADRAO','OMPADR',1);
/*!40000 ALTER TABLE `oms` ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS `sisprotocolo`.`biddings`;
CREATE TABLE `sisprotocolo`.`biddings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(10) NOT NULL,
  `uasg` int(6) NOT NULL,
  `uasg_name` varchar(100) NOT NULL,
  `description` varchar(30) DEFAULT NULL,
  `validate` date NOT NULL,
  `oms_id` int(11) NOT NULL,
  `created_at` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_biddings_items_has_oms_idx` (`oms_id`),
  UNIQUE KEY `number_UNIQUE` (`number`),
  CONSTRAINT `fk_biddings_has_oms` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`)
);
--
-- Table structure for table `biddings_items`
--

DROP TABLE IF EXISTS `sisprotocolo`.`biddings_items`;
CREATE TABLE `sisprotocolo`.`biddings_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biddings_id` int(11) NOT NULL,
  `suppliers_id` int(11) NOT NULL,
  `number` int(5) NOT NULL,
  `name` varchar(256) NOT NULL,
  `uf` varchar(4) NOT NULL,
  `value` float(9,2) NOT NULL,
  `total_quantity` FLOAT(9,2),
  `active` varchar(3) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  KEY `fk_biddings_items_biddings1_idx` (`biddings_id`),
  KEY `fk_biddings_items_suppliers1_idx` (`suppliers_id`),
  CONSTRAINT `fk_biddings_items_biddings1` FOREIGN KEY (`biddings_id`) REFERENCES `biddings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_biddings_items_suppliers1` FOREIGN KEY (`suppliers_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE
);

--
-- Table structure for table `biddings_items_oms`
--

DROP TABLE IF EXISTS `sisprotocolo`.`biddings_items_oms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`biddings_items_oms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `biddings_items_id` int(11) NOT NULL,
  `oms_id` int(11) NOT NULL,
  `quantity` float(9,3) NOT NULL,
  `quantity_available` float(9,3) DEFAULT NULL,
  PRIMARY KEY (`id`,`biddings_items_id`,`oms_id`),
  KEY `fk_biddings_items_has_oms_idx` (`oms_id`),
  KEY `fk_biddings_items_has_oms_items_idx` (`biddings_items_id`),
  CONSTRAINT `fk_biddings_items_has_oms_biddings1` FOREIGN KEY (`biddings_items_id`) REFERENCES `biddings_items` (`id`),
  CONSTRAINT `fk_biddings_items_has_oms_oms1` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`)
) ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cnae`
--

DROP TABLE IF EXISTS `sisprotocolo`.`cnae`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`cnae` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `description` varchar(60) NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `credit`
--

DROP TABLE IF EXISTS `sisprotocolo`.`credit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`credit` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `credit_note` varchar(50) NOT NULL,
  `value` float(9,2) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `credit`
--

LOCK TABLES `sisprotocolo`.`credit` WRITE;
/*!40000 ALTER TABLE `credit` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`credit` VALUES (1,'Lei nº 8.666/1993',17600.00,'2022-06-15 00:00:00','2022-06-15 00:00:00',1),(2,'Lei nº 14.133/2021',50000.00,'2022-06-15 00:00:00','2022-06-15 00:00:00',1);
/*!40000 ALTER TABLE `credit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credit_historic`
--

DROP TABLE IF EXISTS `sisprotocolo`.`credit_historic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`credit_historic` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operation_type` varchar(20) NOT NULL DEFAULT 'CREDITO',
  `value` float(9,2) NOT NULL,
  `observation` varchar(100) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `credit_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_credit_historic_credit1_idx` (`credit_id`),
  CONSTRAINT `fk_credit_historic_credit1` FOREIGN KEY (`credit_id`) REFERENCES `credit` (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `credit_historic`
--

LOCK TABLES `sisprotocolo`.`credit_historic` WRITE;
/*!40000 ALTER TABLE `credit_historic` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`credit_historic` VALUES (2,'CREDITO',17600.00,'CREDITO','2022-07-19 00:00:00',1),(3,'CREDITO',50000.00,'CREDITO NOVO','2022-07-19 00:00:00',2),(6,'DEBITO',5000.00,'DÉBITO DE R$ 5.000,00; REFERENTE AO DOCUMENTO 123456789','2022-07-19 23:17:54',1),(7,'DEBITO',5000.00,'DÉBITO DE R$ 5.000,00; REFERENTE AO DOCUMENTO 405923','2022-07-22 22:02:33',1);
/*!40000 ALTER TABLE `credit_historic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modality`
--

DROP TABLE IF EXISTS `sisprotocolo`.`modality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`modality` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `modality`
--

LOCK TABLES `sisprotocolo`.`modality` WRITE;
/*!40000 ALTER TABLE `modality` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`modality` VALUES (1,'Dispensa de Licitação',1),(2,'Pregão Eletrônico',1),(3,'Concorrência',1),(4,'Tomada de Preços',1),(5,'TJDL',1),(6,'TJIL',1);
/*!40000 ALTER TABLE `modality` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nature_expense`
--

DROP TABLE IF EXISTS `sisprotocolo`.`nature_expense`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`nature_expense` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `nature_expense`
--

LOCK TABLES `sisprotocolo`.`nature_expense` WRITE;
/*!40000 ALTER TABLE `nature_expense` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`nature_expense` VALUES (1,'339030 - Material Comum',1);
/*!40000 ALTER TABLE `nature_expense` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `process_type`
--

DROP TABLE IF EXISTS `sisprotocolo`.`process_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`process_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `process_type`
--

LOCK TABLES `sisprotocolo`.`process_type` WRITE;
/*!40000 ALTER TABLE `process_type` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`process_type` VALUES (1,'SOLEMP',1),(2,'Dispensa Eletrônica',1);
/*!40000 ALTER TABLE `process_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `sisprotocolo`.`status`;
CREATE TABLE `sisprotocolo`.`status` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(40) NOT NULL,
  `description` varchar(60) DEFAULT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

--
-- Dumping data for table `status`
--
LOCK TABLES `sisprotocolo`.`status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`status` VALUES (1,'PROT. OBT.','PROTOCOLADO NA OBTENÇÃO',1),(2,'PROT. EXE.','PROTOCOLADO NA EXECUÇÃO',1),(3,'ENV. EXE.','ENVIADO PARA EXECUÇÃO',1),(4,'EMPENHADO','DATA EM QUE O DOCUMENTO FOI EMPENHADO',1),(5,'DEV. OBT','DEVOLVIDO À OBTENÇÃO',1),(6,'DEV. EXE.','DEVOLVIDO À EXECUÇÃO FINANCEIRA',1),(7,'ASSINADO','DATA EM QUE O DOCUMENTO FOI ASSINADO',1),(8,'ENV. NE OM','NOTA DE EMPENHO ENVIADO PARA A OM DE ORIGEM',1),(9,'DEV. OM','DEVOLVIDO À OM DE ORIGEM',1),(10,'NF ENT. EXE.','DATA DE ENTREGA DA NOTA FISCAL NA EXECUÇÃO FINANCEIRA',1),(11,'NR DA NF','NÚMERO DA NOTA FISCAL',1),(12,'NF LIQ.','NOTA FISCAL LIQUIDADA',1),(13,'NF SOL. REC.','SOLICITAÇÃO DE RECURSO PARA PAGAMENTO',1),(14,'NR DA PF','NÚMERO DA PROGRAMAÇÃO FINANCEIRA',1),(15,'NF PAGA','NOTA FISCAL PAGA',1),(16,'NR DA OB','NÚMERO DA ORDEM BANCÁRIA',1),(17,'NR DA NE','NÚMERO DA NOTA DE EMPENHO',1),(18,'ASS. CP.','DATA DA ASSINATURA DA CP',1),(19,'ENT. SECOM','DATA DE ENTRADA NA SECOM - CeIMBe',1),(20,'ENT. POSTAL','DATA DE ENTREGA NA POSTAL',1),(21,'ENT. OPERADOR','DATA DE ENTREGA PARA O OPERADOR SIAFI',1),(22,'PARA ASS.','DOCUMENTO ENVIADO PARA ASSINATURA',1);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users_login`
--

DROP TABLE IF EXISTS `sisprotocolo`.`users_login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`users_login` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(88) NOT NULL,
  `password` varchar(60) NOT NULL,
  `name` varchar(60) NOT NULL,
  `email` varchar(108) DEFAULT NULL,
  `level` tinyint(4) NOT NULL,
  `change_password` tinyint(4) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  `oms_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_users_login_oms_idx` (`oms_id`),
  CONSTRAINT `fk_users_login_oms` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`)
) ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users_login`
--
/*!40000 ALTER TABLE `users_login` DISABLE KEYS */;
INSERT INTO `sisprotocolo`.`users_login` VALUES (1,'administrator','$2y$11$gQNC3HGp7t5/Bd7xSY/D0.82OOaEUv2zxSoQeP5TMSNhySs1zAOf6','Administrator','admin1@test.com',1,1,'2022-06-15 00:00:00','2022-07-26 10:30:49',1,1);


--
-- Table structure for table `registers`
--

DROP TABLE IF EXISTS `sisprotocolo`.`registers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`registers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `document_number` varchar(20) NOT NULL,
  `summary_object` varchar(100) DEFAULT NULL,
  `bidding_process_number` varchar(15) DEFAULT NULL,
  `document_value` FLOAT(9,2) NOT NULL,
  `oms_id` int(11) NOT NULL,
  `modality_id` int(11) NOT NULL,
  `credit_id` int(11) DEFAULT NULL,
  `suppliers_id` int(11) NOT NULL,
  `nature_expense_id` int(11) DEFAULT NULL,
  `biddings_id` int(11) DEFAULT NULL,
  `sub_item` int(11) DEFAULT NULL,
  `article` int(11) DEFAULT NULL,
  `incisive` int(11) DEFAULT NULL,
  `observation` varchar(250) DEFAULT NULL,
  `cnae` varchar(30) DEFAULT NULL,
  `cnpj` varchar(20) DEFAULT NULL,
  `status_id` int(11) NOT NULL,
  `number_arp` varchar(50) DEFAULT NULL,
  `item_arp` varchar(50) DEFAULT NULL,
  `nup` VARCHAR(60) NULL DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_registers_oms_idx` (`oms_id`),
  KEY `fk_registers_modality1_idx` (`modality_id`),
  KEY `fk_registers_credit1_idx` (`credit_id`),
  KEY `fk_registers_suppliers1_idx` (`suppliers_id`),
  KEY `fk_registers_nature_expense1_idx` (`nature_expense_id`),
  KEY `fk_registers_status1_idx` (`status_id`),
  KEY `fk_registers_biddings1_idx` (`biddings_id`),
  CONSTRAINT `fk_registers_biddings1` FOREIGN KEY (`biddings_id`) REFERENCES `biddings` (`id`),
  CONSTRAINT `fk_registers_credit1` FOREIGN KEY (`credit_id`) REFERENCES `credit` (`id`),
  CONSTRAINT `fk_registers_modality1` FOREIGN KEY (`modality_id`) REFERENCES `modality` (`id`),
  CONSTRAINT `fk_registers_nature_expense1` FOREIGN KEY (`nature_expense_id`) REFERENCES `nature_expense` (`id`),
  CONSTRAINT `fk_registers_oms` FOREIGN KEY (`oms_id`) REFERENCES `oms` (`id`),
  CONSTRAINT `fk_registers_status1` FOREIGN KEY (`status_id`) REFERENCES `status` (`id`),
  CONSTRAINT `fk_registers_suppliers1` FOREIGN KEY (`suppliers_id`) REFERENCES `suppliers` (`id`)
) ENGINE=InnoDB;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `registers_items`
--

DROP TABLE IF EXISTS `sisprotocolo`.`registers_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`registers_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registers_id` int(11) NOT NULL,
  `number` int(8) DEFAULT NULL,
  `name` varchar(256) NOT NULL,
  `uf` varchar(4) NOT NULL,
  `quantity` float(9,3) NOT NULL COMMENT 'Quantidade solicitada',
  `delivered` float(9,3) NOT NULL COMMENT 'Quantidade entregue',
  `value` float(9,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_requests_items_registers_idx` (`registers_id`),
  CONSTRAINT `fk_requests_items_registers` FOREIGN KEY (`registers_id`) REFERENCES `registers` (`id`)
) ENGINE=InnoDB
COMMENT='Items das solicitações';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `historic_status_registers`
--

DROP TABLE IF EXISTS `sisprotocolo`.`historic_status_registers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`historic_status_registers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registers_id` int(11) NOT NULL,
  `users_id` int(11) NOT NULL,
  `status_id` int(11) NOT NULL,
  `resulting_document` varchar(30) DEFAULT NULL,
  `user_name` varchar(50) NOT NULL,
  `date_action` datetime NOT NULL,
  `observation` text,
  PRIMARY KEY (`id`),
  KEY `fk_historic_status_registers_1_idx` (`registers_id`),
  KEY `fk_historic_status_registers_2_idx` (`users_id`),
  CONSTRAINT `fk_historic_status_registers_1` FOREIGN KEY (`registers_id`) REFERENCES `registers` (`id`),
  CONSTRAINT `fk_historic_status_registers_2` FOREIGN KEY (`users_id`) REFERENCES `users_login` (`id`)
) ENGINE=InnoDB;

--
-- Table structure for table `cat_material_service`
--

DROP TABLE IF EXISTS `cat_material_service`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cat_material_service` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(10) NOT NULL,
  `group_id` int(11) NOT NULL,
  `group_description` varchar(300) NOT NULL,
  `class_id` int(11) NOT NULL,
  `class_description` varchar(300) NOT NULL,
  `pdm_id` int(11) NOT NULL,
  `pdm_description` varchar(100) NOT NULL,
  `item_id` varchar(6) NOT NULL,
  `item_description` varchar(1000) NOT NULL,
  `sustainable` varchar(20) NOT NULL,
  `isActive` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;


DROP TABLE IF EXISTS `sisprotocolo`.`registers_items_cat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`registers_items_cat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `registers_id` int(11) NOT NULL,
  `cat_id` int(8) DEFAULT NULL,
  `value` float(9,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_registers_items_cat_registers_idx` (`registers_id`),
  CONSTRAINT `fk_registers_items_cat_registers` FOREIGN KEY (`registers_id`) REFERENCES `registers` (`id`),
  CONSTRAINT `fk_registers_items_cat_material_service` FOREIGN KEY (`cat_id`) REFERENCES `cat_material_service` (`id`)
) ENGINE=InnoDB
COMMENT='Items das solicitações';
/*!40101 SET character_set_client = @saved_cs_client */;

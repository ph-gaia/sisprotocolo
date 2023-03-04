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


DROP TABLE IF EXISTS `sisprotocolo`.`biddings`;
CREATE TABLE `sisprotocolo`.`biddings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `number` varchar(10) NOT NULL,
  `uasg` int(6) NOT NULL,
  `uasg_name` varchar(100) NOT NULL,
  `description` varchar(30) DEFAULT NULL,
  `validate` date NOT NULL,
  `created_at` date NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `number_UNIQUE` (`number`)
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
  `active` varchar(3) NOT NULL DEFAULT 'yes',
  PRIMARY KEY (`id`),
  KEY `fk_biddings_items_biddings1_idx` (`biddings_id`),
  KEY `fk_biddings_items_suppliers1_idx` (`suppliers_id`),
  CONSTRAINT `fk_biddings_items_biddings1` FOREIGN KEY (`biddings_id`) REFERENCES `biddings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_biddings_items_suppliers1` FOREIGN KEY (`suppliers_id`) REFERENCES `suppliers` (`id`) ON DELETE CASCADE
);

--
-- Table structure for table `oms`
--

DROP TABLE IF EXISTS `sisprotocolo`.`oms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sisprotocolo`.`oms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `naval_indicative` varchar(6) DEFAULT NULL,
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
-- Dumping data for table `cnae`
--

LOCK TABLES `sisprotocolo`.`cnae` WRITE;
/*!40000 ALTER TABLE `cnae` DISABLE KEYS */;
INSERT INTO `cnae` VALUES (1,'111301','Cultivo de arroz',1),(2,'111302','Cultivo de milho',1),(3,'111303','Cultivo de trigo',1),(4,'111399','Cultivo de outros cereais não especificados anteriormente',1),(5,'112101','Cultivo de algodão herbáceo',1),(6,'112102','Cultivo de juta',1),(7,'113000','Cultivo de cana-de-açúcar',1),(8,'114800','Cultivo de fumo',1),(9,'115600','Cultivo de soja',1),(10,'116401','Cultivo de amendoim',1),(11,'116402','Cultivo de girassol',1),(12,'116403','Cultivo de mamona',1),(13,'119901','Cultivo de abacaxi',1),(14,'119902','Cultivo de alho',1),(15,'119903','Cultivo de batata-inglesa',1),(16,'119904','Cultivo de cebola',1),(17,'119905','Cultivo de feijão',1),(18,'119906','Cultivo de mandioca',1),(19,'119907','Cultivo de melão',1),(20,'119908','Cultivo de melancia',1),(21,'119909','Cultivo de tomate rasteiro',1),(22,'121101','Horticultura, exceto morango',1),(23,'121102','Cultivo de morango',1),(24,'122900','Cultivo de flores e plantas ornamentais',1),(25,'122900','- Cultivo de flores e plantas ornamentais',1),(26,'131800','Cultivo de laranja',1),(27,'132600','Cultivo de uva',1),(28,'133401','Cultivo de açaí',1),(29,'133402','Cultivo de banana',1),(30,'133403','Cultivo de caju',1),(31,'133404','Cultivo de cítricos, exceto laranja',1),(32,'133405','Cultivo de coco-da-baía',1),(33,'133406','Cultivo de guaraná',1),(34,'133407','Cultivo de maçã',1),(35,'133408','Cultivo de mamão',1),(36,'133409','Cultivo de maracujá',1),(37,'133410','Cultivo de manga',1),(38,'133411','Cultivo de pêssego',1),(39,'134200','Cultivo de café',1),(40,'135100','Cultivo de cacau',1),(41,'139301','Cultivo de chá-da-índia',1),(42,'139302','Cultivo de erva-mate',1),(43,'139303','Cultivo de pimenta-do-reino',1),(44,'139304','Cultivo de plantas para condimento, exceto pimenta-do-reino',1),(45,'139305','Cultivo de dendê',1),(46,'139306','Cultivo de seringueira',1),(47,'151201','Criação de bovinos para corte',1),(48,'151202','Criação de bovinos para leite',1),(49,'151203','Criação de bovinos, exceto para corte e leite',1),(50,'152101','Criação de bufalinos',1),(51,'152102','Criação de equinos',1),(52,'152103','Criação de asininos e muares',1),(53,'153901','Criação de caprinos',1),(54,'153902','Criação de ovinos, inclusive para produção de lã',1),(55,'154700','Criação de suínos',1),(56,'155501','Criação de frangos para corte',1),(57,'155502','Produção de pintos de um dia',1),(58,'155503','Criação de outros galináceos, exceto para corte',1),(59,'155504','Criação de aves, exceto galináceos',1),(60,'155505','Produção de ovos',1),(61,'159801','Apicultura',1),(62,'159802','Criação de animais de estimação',1),(63,'159803','Criação de escargô',1),(64,'159804','Criação de bicho-da-seda',1),(65,'159899','Criação de outros animais não especificados anteriormente',1),(66,'161001','Serviço de pulverização e controle de pragas agrícolas',1),(67,'161002','Serviço de poda de árvores para lavouras',1),(68,'161003','Serviço de preparação de terreno, cultivo e colheita',1),(69,'162801','Serviço de inseminação artificial em animais',1),(70,'162802','Serviço de tosquiamento de ovinos',1),(71,'162803','Serviço de manejo de animais',1),(72,'163600','Atividades de pós-colheita',1),(73,'170900','Caça e serviços relacionados',1),(74,'111302','Cultivo de milho - errado',1),(75,'210101','Cultivo de eucalipto',1),(76,'210102','Cultivo de acácia-negra',1),(77,'210103','Cultivo de pinus',1),(78,'210104','Cultivo de teca',1),(79,'210106','Cultivo de mudas em viveiros florestais',1),(80,'210107','Extração de madeira em florestas plantadas',1),(81,'210108','Produção de carvão vegetal - florestas plantadas',1),(82,'210109','Produção de casca de acácia-negra - florestas plantadas',1),(83,'220901','Extração de madeira em florestas nativas',1),(84,'220902','Produção de carvão vegetal - florestas nativas',1),(85,'220903','Coleta de castanha-do-pará em florestas nativas',1),(86,'220904','Coleta de látex em florestas nativas',1),(87,'220905','Coleta de palmito em florestas nativas',1),(88,'220906','Conservação de florestas nativas',1),(89,'230600','Atividades de apoio à produção florestal',1),(90,'311601','Pesca de peixes em água salgada',1),(91,'311602','Pesca de crustáceos e moluscos em água salgada',1),(92,'311603','Coleta de outros produtos marinhos',1),(93,'311604','Atividades de apoio à pesca em água salgada',1),(94,'312401','Pesca de peixes em água doce',1),(95,'312402','Pesca de crustáceos e moluscos em água doce',1),(96,'312403','Coleta de outros produtos aquáticos de água doce',1),(97,'312404','Atividades de apoio à pesca em água doce',1),(98,'321301','Criação de peixes em água salgada e salobra',1),(99,'321302','Criação de camarões em água salgada e salobra',1),(100,'321303','Criação de ostras e mexilhões em água salgada e salobra',1),(101,'321304','Criação de peixes ornamentais em água salgada e salobra',1),(102,'321305','Atividades de apoio à aquicultura em água salgada e salobra',1),(103,'322101','Criação de peixes em água doce',1),(104,'322102','Criação de camarões em água doce',1),(105,'322103','Criação de ostras e mexilhões em água doce',1),(106,'322104','Criação de peixes ornamentais em água doce',1),(107,'322105','Ranicultura',1),(108,'322106','Criação de jacaré',1),(109,'322107','Atividades de apoio à aquicultura em água doce',1),(110,'500301','Extração de carvão mineral',1),(111,'500302','Beneficiamento de carvão mineral',1),(112,'600001','Extração de petróleo e gás natural',1),(113,'600002','Extração e beneficiamento de xisto',1),(114,'600003','Extração e beneficiamento de areias betuminosas',1),(115,'710301','Extração de minério de ferro',1),(116,'721901','Extração de minério de alumínio',1),(117,'721902','Beneficiamento de minério de alumínio',1),(118,'722701','Extração de minério de estanho',1),(119,'722702','Beneficiamento de minério de estanho',1),(120,'723501','Extração de minério de manganês',1),(121,'723502','Beneficiamento de minério de manganês',1),(122,'724301','Extração de minério de metais preciosos',1),(123,'724302','Beneficiamento de minério de metais preciosos',1),(124,'725100','Extração de minerais radioativos',1),(125,'729401','Extração de minérios de nióbio e titânio',1),(126,'729402','Extração de minério de tungstênio',1),(127,'729403','Extração de minério de níquel',1),(128,'810001','Extração de ardósia e beneficiamento associado',1),(129,'810002','Extração de granito e beneficiamento associado',1),(130,'810003','Extração de mármore e beneficiamento associado',1),(131,'810004','Extração de calcário e dolomita e beneficiamento associado',1),(132,'810005','Extração de gesso e caulim',1),(133,'810007','Extração de argila e beneficiamento associado',1),(134,'810008','Extração de saibro e beneficiamento associado',1),(135,'810009','Extração de basalto e beneficiamento associado',1),(136,'810010','Beneficiamento de gesso e caulim associado à extração',1),(137,'892401','Extração de sal marinho',1),(138,'892402','Extração de sal-gema',1),(139,'892403','Refino e outros tratamentos do sal',1),(140,'893200','Extração de gemas (pedras preciosas e semipreciosas)',1),(141,'899101','Extração de grafita',1),(142,'899102','Extração de quartzo',1),(143,'899103','Extração de amianto',1),(144,'910600','Atividades de apoio à extração de petróleo e gás natural',1),(145,'990401','Atividades de apoio à extração de minério de ferro',1),(146,'990403','Atividades de apoio à extração de minerais não metálicos',1),(147,'1011201','Frigorífico - abate de bovinos',1),(148,'1011202','Frigorífico - abate de equinos',1),(149,'1011203','Frigorífico - abate de ovinos e caprinos',1),(150,'1011204','Frigorífico - abate de bufalinos',1),(151,'1012101','Abate de aves',1),(152,'1012102','Abate de pequenos animais',1),(153,'1012103','Frigorífico - abate de suínos',1),(154,'1012104','Matadouro - abate de suínos sob contrato',1),(155,'1013901','Fabricação de produtos de carne',1),(156,'1013902','Preparação de subprodutos do abate',1),(157,'1020101','Preservação de peixes, crustáceos e moluscos',1),(158,'1020102','Fabricação de conservas de peixes, crustáceos e moluscos',1),(159,'1031700','Fabricação de conservas de frutas',1),(160,'1032501','Fabricação de conservas de palmito',1),(161,'1041400','Fabricação de óleos vegetais em bruto, exceto óleo de milho',1),(162,'1042200','Fabricação de óleos vegetais refinados, exceto óleo de milho',1),(163,'1051100','Preparação do leite',1),(164,'1051100','Preparação do leite',1),(165,'1052000','Fabricação de laticínios',1),(166,'1053800','Fabricação de sorvetes e outros gelados comestíveis',1),(167,'1061901','Beneficiamento de arroz',1),(168,'1061902','Fabricação de produtos do arroz',1),(169,'1062700','Moagem de trigo e fabricação de derivados',1),(170,'1063500','Fabricação de farinha de mandioca e derivados',1),(171,'1065101','Fabricação de amidos e féculas de vegetais',1),(172,'1065102','Fabricação de óleo de milho em bruto',1),(173,'1065103','Fabricação de óleo de milho refinado',1),(174,'1066000','Fabricação de alimentos para animais',1),(175,'1071600','Fabricação de açúcar em bruto',1),(176,'1072401','Fabricação de açúcar de cana refinado',1),(177,'1072402','Fabricação de açúcar de cereais (dextrose) e de beterraba',1),(178,'1081301','Beneficiamento de café',1),(179,'1081302','Torrefação e moagem de café',1),(180,'1082100','Fabricação de produtos à base de café',1),(181,'1091101','Fabricação de produtos de panificação industrial',1),(182,'1092900','Fabricação de biscoitos e bolachas',1),(183,'1093701','Fabricação de produtos derivados do cacau e de chocolates',1),(184,'1093702','Fabricação de frutas cristalizadas, balas e semelhantes',1),(185,'1094500','Fabricação de massas alimentícias',1),(186,'1095300','Fabricação de especiarias, molhos, temperos e condimentos',1),(187,'1096100','Fabricação de alimentos e pratos prontos',1),(188,'1096100','- Fabricação de alimentos e pratos prontos',1),(189,'1099601','Fabricação de vinagres',1),(190,'1099602','- Fabricação de pós alimentícios',1),(191,'1099602','Fabricação de pós-alimentícios',1),(192,'1099603','Fabricação de fermentos e leveduras',1),(193,'1099604','Fabricação de gelo comum',1),(194,'1099605','Fabricação de produtos para infusão (chá, mate, etc.)',1),(195,'1099606','Fabricação de adoçantes naturais e artificiais',1),(196,'1111901','Fabricação de aguardente de cana-de-açúcar',1),(197,'1111902','Fabricação de outras aguardentes e bebidas destiladas',1),(198,'1112700','Fabricação de vinho',1),(199,'1113501','Fabricação de malte, inclusive malte uísque',1),(200,'1113502','Fabricação de cervejas e chopes',1),(201,'1121600','Fabricação de águas envasadas',1),(202,'1122401','Fabricação de refrigerantes',1),(203,'1122402','Fabricação de chá mate e outros chás prontos para consumo',1),(204,'1122404','Fabricação de bebidas isotônicas',1),(205,'1210700','Processamento industrial do fumo',1),(206,'1220401','Fabricação de cigarros',1),(207,'1220402','Fabricação de cigarrilhas e charutos',1),(208,'1220403','Fabricação de filtros para cigarros',1),(209,'1311100','Preparação e fiação de fibras de algodão',1),(210,'1313800','Fiação de fibras artificiais e sintéticas',1),(211,'1314600','Fabricação de linhas para costurar e bordar',1),(212,'1321900','Tecelagem de fios de algodão',1),(213,'1322700','Tecelagem de fios de fibras têxteis naturais, exceto algodão',1),(214,'1323500','Tecelagem de fios de fibras artificiais e sintéticas',1),(215,'1330800','Fabricação de tecidos de malha',1),(216,'1351100','Fabricação de artefatos têxteis para uso doméstico',1),(217,'1352900','Fabricação de artefatos de tapeçaria',1),(218,'1353700','Fabricação de artefatos de cordoaria',1),(219,'1354500','Fabricação de tecidos especiais, inclusive artefatos',1),(220,'1411801','Confecção de roupas íntimas',1),(221,'1411802','Facção de roupas íntimas',1),(222,'1411802','- Facção de roupas íntimas',1),(223,'1412603','Facção de peças do vestuário, exceto roupas íntimas',1),(224,'1413401','Confecção de roupas profissionais, exceto sob medida',1),(225,'1413402','Confecção, sob medida, de roupas profissionais',1),(226,'1413403','Facção de roupas profissionais',1),(227,'1421500','Fabricação de meias',1),(228,'1510600','Curtimento e outras preparações de couro',1),(229,'1510600','- Curtimento e outras preparações de couro',1),(230,'1531901','Fabricação de calçados de couro',1),(231,'1531902','Acabamento de calçados de couro sob contrato',1),(232,'1532700','Fabricação de tênis de qualquer material',1),(233,'1533500','Fabricação de calçados de material sintético',1),(234,'1540800','Fabricação de partes para calçados, de qualquer material',1),(235,'155501','- Criação de frangos para corte',1),(236,'1610201','Serrarias com desdobramento de madeira',1),(237,'1610202','- Serrarias sem desdobramento de madeira',1),(238,'1610203','Serrarias com desdobramento de madeira em bruto',1),(239,'1610204','Serrarias sem desdobramento de madeira em bruto - Resseragem',1),(240,'1610205','Serviço de tratamento de madeira realizado sob contrato',1),(241,'1622601','Fabricação de casas de madeira pré-fabricadas',1),(242,'1622699','Fabricação de outros artigos de carpintaria para construção',1),(243,'1629301','Fabricação de artefatos diversos de madeira, exceto móveis',1),(244,'1721400','Fabricação de papel',1),(245,'1722200','Fabricação de cartolina e papel-cartão',1),(246,'1731100','Fabricação de embalagens de papel',1),(247,'1732000','Fabricação de embalagens de cartolina e papel-cartão',1),(248,'1733800','Fabricação de chapas e de embalagens de papelão ondulado',1),(249,'1741901','Fabricação de formulários contínuos',1),(250,'1742701','Fabricação de fraldas descartáveis',1),(251,'1742702','Fabricação de absorventes higiênicos',1),(252,'1811301','Impressão de jornais',1),(253,'1812100','Impressão de material de segurança',1),(254,'1813001','Impressão de material para uso publicitário',1),(255,'1813001','- Impressão de material para uso publicitário',1),(256,'1813099','Impressão de material para outros usos',1),(257,'1821100','Serviços de pré-impressão',1),(258,'1822901','Serviços de encadernação e plastificação',1),(259,'1830001','Reprodução de som em qualquer suporte',1),(260,'1830002','Reprodução de vídeo em qualquer suporte',1),(261,'1830003','Reprodução de software em qualquer suporte',1),(262,'1910100','Coquerias',1),(263,'1921700','Fabricação de produtos do refino de petróleo',1),(264,'1922501','Formulação de combustíveis',1),(265,'1922502','Rerrefino de óleos lubrificantes',1),(266,'1931400','Fabricação de álcool',1),(267,'1932200','Fabricação de biocombustíveis, exceto álcool',1),(268,'2011800','Fabricação de cloro e álcalis',1),(269,'2012600','Fabricação de intermediários para fertilizantes',1),(270,'2013401','Fabricação de adubos e fertilizantes organo-minerais',1),(271,'2013402','Fabricação de adubos e fertilizantes, exceto organo-minerais',1),(272,'2014200','Fabricação de gases industriais',1),(273,'2020301','Elaboração de combustíveis nucleares',1),(274,'2021500','Fabricação de produtos petroquímicos básicos',1),(275,'2031200','Fabricação de resinas termoplásticas',1),(276,'2031200','- Fabricação de resinas termoplásticas',1),(277,'2032100','Fabricação de resinas termofixas',1),(278,'2033900','Fabricação de elastômeros',1),(279,'2040100','Fabricação de fibras artificiais e sintéticas',1),(280,'2051700','Fabricação de defensivos agrícolas',1),(281,'2052500','Fabricação de desinfestantes domissanitários',1),(282,'2061400','Fabricação de sabões e detergentes sintéticos',1),(283,'2062200','Fabricação de produtos de limpeza e polimento',1),(284,'2062200','- Fabricação de produtos de limpeza e polimento',1),(285,'2071100','Fabricação de tintas, vernizes, esmaltes e lacas',1),(286,'2072000','Fabricação de tintas de impressão',1),(287,'2073800','Fabricação de impermeabilizantes, solventes e produtos afins',1),(288,'2091600','Fabricação de adesivos e selantes',1),(289,'2092401','Fabricação de pólvoras, explosivos e detonantes',1),(290,'2092402','Fabricação de artigos pirotécnicos',1),(291,'2092403','Fabricação de fósforos de segurança',1),(292,'2093200','Fabricação de aditivos de uso industrial',1),(293,'2094100','Fabricação de catalisadores',1),(294,'210107','- Extração de madeira em florestas plantadas',1),(295,'2110600','Fabricação de produtos farmoquímicos',1),(296,'2121101','Fabricação de medicamentos alopáticos para uso humano',1),(297,'2121102','Fabricação de medicamentos homeopáticos para uso humano',1),(298,'2121103','Fabricação de medicamentos fitoterápicos para uso humano',1),(299,'2122000','Fabricação de medicamentos para uso veterinário',1),(300,'2123800','Fabricação de preparações farmacêuticas',1),(301,'2211100','Fabricação de pneumáticos e de câmaras-de-ar',1),(302,'2212900','Reforma de pneumáticos usados',1),(303,'2222600','Fabricação de embalagens de material plástico',1),(304,'2311700','Fabricação de vidro plano e de segurança',1),(305,'2312500','Fabricação de embalagens de vidro',1),(306,'2319200','Fabricação de artigos de vidro',1),(307,'2320600','Fabricação de cimento',1),(308,'2330302','Fabricação de artefatos de cimento para uso na construção',1),(309,'2330304','Fabricação de casas pré-moldadas de concreto',1),(310,'2330305','Preparação de massa de concreto e argamassa para construção',1),(311,'2341900','Fabricação de produtos cerâmicos refratários',1),(312,'2342701','Fabricação de azulejos e pisos',1),(313,'2349401','Fabricação de material sanitário de cerâmica',1),(314,'2391501','Britamento de pedras, exceto associado à extração',1),(315,'2392300','Fabricação de cal e gesso',1),(316,'2399102','Fabricação de abrasivos',1),(317,'2411300','Produção de ferro-gusa',1),(318,'2412100','Produção de ferroligas',1),(319,'2421100','Produção de semiacabados de aço',1),(320,'2422902','Produção de laminados planos de aços especiais',1),(321,'2423701','Produção de tubos de aço sem costura',1),(322,'2423702','Produção de laminados longos de aço, exceto tubos',1),(323,'2424501','Produção de arames de aço',1),(324,'2431800','Produção de tubos de aço com costura',1),(325,'2439300','Produção de outros tubos de ferro e aço',1),(326,'2441501','Produção de alumínio e suas ligas em formas primárias',1),(327,'2441502','Produção de laminados de alumínio',1),(328,'2442300','Metalurgia dos metais preciosos',1),(329,'2443100','Metalurgia do cobre',1),(330,'2449101','Produção de zinco em formas primárias',1),(331,'2449102','Produção de laminados de zinco',1),(332,'2449103','Fabricação de ânodos para galvanoplastia',1),(333,'2451200','Fundição de ferro e aço',1),(334,'2452100','- Fundição de metais não-ferrosos e suas ligas',1),(335,'2452100','Fundição de metais não ferrosos e suas ligas',1),(336,'2511000','Fabricação de estruturas metálicas',1),(337,'2512800','Fabricação de esquadrias de metal',1),(338,'2512800','Fabricação de esquadrias de metal',1),(339,'2513600','Fabricação de obras de caldeiraria pesada',1),(340,'2513600','- Fabricação de obras de caldeiraria pesada',1),(341,'2531401','Produção de forjados de aço',1),(342,'2531402','Produção de forjados de metais não-ferrosos e suas ligas',1),(343,'2531402','Produção de forjados de metais não ferrosos e suas ligas',1),(344,'2532201','Produção de artefatos estampados de metal',1),(345,'2532202','Metalurgia do pó',1),(346,'2539001','- Serviços de usinagem, tornearia e solda',1),(347,'2539001','Serviços de usinagem, torneiria e solda',1),(348,'2539002','Serviços de tratamento e revestimento em metais',1),(349,'2541100','Fabricação de artigos de cutelaria',1),(350,'2542000','Fabricação de artigos de serralheria, exceto esquadrias',1),(351,'2543800','Fabricação de ferramentas',1),(352,'2550102','Fabricação de armas de fogo, outras armas e munições',1),(353,'2591800','Fabricação de embalagens metálicas',1),(354,'2592601','Fabricação de produtos de trefilados de metal padronizados',1),(355,'2593400','Fabricação de artigos de metal para uso doméstico e pessoal',1),(356,'2599302','Serviço de corte e dobra de metais',1),(357,'2610800','Fabricação de componentes eletrônicos',1),(358,'2621300','Fabricação de equipamentos de informática',1),(359,'2622100','Fabricação de periféricos para equipamentos de informática',1),(360,'2652300','Fabricação de cronômetros e relógios',1),(361,'2680900','Fabricação de mídias virgens, magnéticas e ópticas',1),(362,'2710403','Fabricação de motores elétricos, peças e acessórios',1),(363,'2733300','Fabricação de fios, cabos e condutores elétricos isolados',1),(364,'2740601','Fabricação de lâmpadas',1),(365,'2740602','Fabricação de luminárias e outros equipamentos de iluminação',1),(366,'2790202','Fabricação de equipamentos para sinalização e alarme',1),(367,'2815101','Fabricação de rolamentos para fins industriais',1),(368,'2831300','Fabricação de tratores agrícolas, peças e acessórios',1),(369,'2840200','Fabricação de máquinas-ferramenta, peças e acessórios',1),(370,'2853400','Fabricação de tratores, peças e acessórios, exceto agrícolas',1),(371,'2910701','Fabricação de automóveis, camionetas e utilitários',1),(372,'2920401','Fabricação de caminhões e ônibus',1),(373,'2920402','Fabricação de motores para caminhões e ônibus',1),(374,'2930101','Fabricação de cabines, carrocerias e reboques para caminhões',1),(375,'2930102','Fabricação de carrocerias para ônibus',1),(376,'2949201','Fabricação de bancos e estofados para veículos automotores',1),(377,'3011301','Construção de embarcações de grande porte',1),(378,'3012100','Construção de embarcações para esporte e lazer',1),(379,'3032600','Fabricação de peças e acessórios para veículos ferroviários',1),(380,'3041500','Fabricação de aeronaves',1),(381,'3050400','Fabricação de veículos militares de combate',1),(382,'3091101','Fabricação de motocicletas',1),(383,'3091102','Fabricação de peças e acessórios para motocicletas',1),(384,'3101200','Fabricação de móveis com predominância de madeira',1),(385,'3102100','Fabricação de móveis com predominância de metal',1),(386,'3104700','Fabricação de colchões',1),(387,'3211601','Lapidação de gemas',1),(388,'3211602','Fabricação de artefatos de joalheria e ourivesaria',1),(389,'3211603','Cunhagem de moedas e medalhas',1),(390,'3212400','Fabricação de bijuterias e artefatos semelhantes',1),(391,'3220500','Fabricação de instrumentos musicais, peças e acessórios',1),(392,'3230200','Fabricação de artefatos para pesca e esporte',1),(393,'3240001','Fabricação de jogos eletrônicos',1),(394,'3250705','Fabricação de materiais para medicina e odontologia',1),(395,'3250706','Serviços de prótese dentária',1),(396,'3250706','Serviços de prótese dentária',1),(397,'3250707','Fabricação de artigos ópticos',1),(398,'3250709','Serviço de laboratório óptico',1),(399,'3291400','Fabricação de escovas, pincéis e vassouras',1),(400,'3299001','Fabricação de guarda-chuvas e similares',1),(401,'3299004','Fabricação de painéis e letreiros luminosos',1),(402,'3299005','Fabricação de aviamentos para costura',1),(403,'3299006','Fabricação de velas, inclusive decorativas',1),(404,'3314701','Manutenção e reparação de máquinas motrizes não elétricas',1),(405,'3314703','Manutenção e reparação de válvulas industriais',1),(406,'3314704','Manutenção e reparação de compressores',1),(407,'3314712','Manutenção e reparação de tratores agrícolas',1),(408,'3314713','Manutenção e reparação de máquinas-ferramenta',1),(409,'3314716','Manutenção e reparação de tratores, exceto agrícolas',1),(410,'3315500','Manutenção e reparação de veículos ferroviários',1),(411,'3316302','Manutenção de aeronaves na pista',1),(412,'3321000','Instalação de máquinas e equipamentos industriais',1),(413,'3321000','- Instalação de máquinas e equipamentos industriais',1),(414,'3329501','Serviços de montagem de móveis de qualquer material',1),(415,'3329501','Serviços de montagem de móveis de qualquer material',1),(416,'3511501','Geração de energia elétrica',1),(417,'3512300','Transmissão de energia elétrica',1),(418,'3513100','Comércio atacadista de energia elétrica',1),(419,'3513100','Comércio atacadista de energia elétrica',1),(420,'3514000','Distribuição de energia elétrica',1),(421,'3514000','- Distribuição de energia elétrica',1),(422,'3520401','Produção de gás; processamento de gás natural',1),(423,'3520402','Distribuição de combustíveis gasosos por redes urbanas',1),(424,'3600601','Captação, tratamento e distribuição de água',1),(425,'3600602','Distribuição de água por caminhões',1),(426,'3600602','- Distribuição de água por caminhões',1),(427,'3701100','Gestão de redes de esgoto',1),(428,'3701100','- Gestão de redes de esgoto',1),(429,'3702900','Atividades relacionadas a esgoto, exceto a gestão de redes',1),(430,'3811400','- Coleta de resíduos não-perigosos',1),(431,'3811400','Coleta de resíduos não perigosos',1),(432,'3812200','Coleta de resíduos perigosos',1),(433,'3821100','- Tratamento e disposição de resíduos não-perigosos',1),(434,'3821100','Tratamento e disposição de resíduos não perigosos',1),(435,'3822000','Tratamento e disposição de resíduos perigosos',1),(436,'3831901','Recuperação de sucatas de alumínio',1),(437,'3831999','Recuperação de materiais metálicos, exceto alumínio',1),(438,'3832700','Recuperação de materiais plásticos',1),(439,'3832700','- Recuperação de materiais plásticos',1),(440,'3839401','Usinas de compostagem',1),(441,'3839499','Recuperação de materiais não especificados anteriormente',1),(442,'3900500','Descontaminação e outros serviços de gestão de resíduos',1),(443,'4110700','Incorporação de empreendimentos imobiliários',1),(444,'4120400','Construção de edifícios',1),(445,'4211101','Construção de rodovias e ferrovias',1),(446,'4211102','Pintura para sinalização em pistas rodoviárias e aeroportos',1),(447,'4212000','Construção de obras de arte especiais',1),(448,'4213800','Obras de urbanização - ruas, praças e calçadas',1),(449,'4221903','Manutenção de redes de distribuição de energia elétrica',1),(450,'4221904','Construção de estações e redes de telecomunicações',1),(451,'4221905','Manutenção de estações e redes de telecomunicações',1),(452,'4222702','Obras de irrigação',1),(453,'4291000','Obras portuárias, marítimas e fluviais',1),(454,'4292801','Montagem de estruturas metálicas',1),(455,'4292802','Obras de montagem industrial',1),(456,'4299501','Construção de instalações esportivas e recreativas',1),(457,'4299501','- Construção de instalações esportivas e recreativas',1),(458,'4311801','Demolição de edifícios e outras estruturas',1),(459,'4311801','- Demolição de edifícios e outras estruturas',1),(460,'4311802','Preparação de canteiro e limpeza de terreno',1),(461,'4312600','Perfurações e sondagens',1),(462,'4313400','Obras de terraplenagem',1),(463,'4321500','Instalação e manutenção elétrica',1),(464,'4322301','Instalações hidráulicas, sanitárias e de gás',1),(465,'4322303','Instalações de sistema de prevenção contra incêndio',1),(466,'4329101','Instalação de painéis publicitários',1),(467,'4329105','Tratamentos térmicos, acústicos ou de vibração',1),(468,'4330401','Impermeabilização em obras de engenharia civil',1),(469,'4330403','Obras de acabamento em gesso e estuque',1),(470,'4330403','- Obras de acabamento em gesso e estuque',1),(471,'4330404','Serviços de pintura de edifícios em geral',1),(472,'4330499','Outras obras de acabamento da construção',1),(473,'4391600','Obras de fundações',1),(474,'4399101','Administração de obras',1),(475,'4399103','Obras de alvenaria',1),(476,'4399105','Perfuração e construção de poços de água',1),(477,'4511104','Comércio por atacado de caminhões novos e usados',1),(478,'4511106','Comércio por atacado de ônibus e micro-ônibus novos e usados',1),(479,'4512902','Comércio sob consignação de veículos automotores',1),(480,'4520006','Serviços de borracharia para veículos automotores',1),(481,'4520008','Serviços de capotaria',1),(482,'4530702','Comércio por atacado de pneumáticos e câmaras-de-ar',1),(483,'4530705','Comércio a varejo de pneumáticos e câmaras-de-ar',1),(484,'4541201','Comércio por atacado de motocicletas e motonetas',1),(485,'4541203','Comércio a varejo de motocicletas e motonetas novas',1),(486,'4541204','Comércio a varejo de motocicletas e motonetas usadas',1),(487,'4541204','Comércio a varejo de motocicletas e motonetas usadas',1),(488,'4542102','Comércio sob consignação de motocicletas e motonetas',1),(489,'4543900','Manutenção e reparação de motocicletas e motonetas',1),(490,'4543900','- Manutenção e reparação de motocicletas e motonetas',1),(491,'4621400','Comércio atacadista de café em grão',1),(492,'4622200','Comércio atacadista de soja',1),(493,'4623101','Comércio atacadista de animais vivos',1),(494,'4623103','Comércio atacadista de algodão',1),(495,'4623104','Comércio atacadista de fumo em folha não beneficiado',1),(496,'4623105','Comércio atacadista de cacau',1),(497,'4623106','Comércio atacadista de sementes, flores, plantas e gramas',1),(498,'4623107','Comércio atacadista de sisal',1),(499,'4623109','Comércio atacadista de alimentos para animais',1),(500,'4623109','- Comércio atacadista de alimentos para animais',1),(501,'4631100','Comércio atacadista de leite e laticínios',1),(502,'4632001','Comércio atacadista de cereais e leguminosas beneficiados',1),(503,'4632002','Comércio atacadista de farinhas, amidos e féculas',1),(504,'4633802','Comércio atacadista de aves vivas e ovos',1),(505,'4634601','Comércio atacadista de carnes bovinas e suínas e derivados',1),(506,'4634602','Comércio atacadista de aves abatidas e derivados',1),(507,'4634603','Comércio atacadista de pescados e frutos do mar',1),(508,'4634699','Comércio atacadista de carnes e derivados de outros animais',1),(509,'4635401','Comércio atacadista de água mineral',1),(510,'4635402','Comércio atacadista de cerveja, chope e refrigerante',1),(511,'4636201','Comércio atacadista de fumo beneficiado',1),(512,'4636202','Comércio atacadista de cigarros, cigarrilhas e charutos',1),(513,'4637101','Comércio atacadista de café torrado, moído e solúvel',1),(514,'4637102','Comércio atacadista de açúcar',1),(515,'4637103','Comércio atacadista de óleos e gorduras',1),(516,'4637104','Comércio atacadista de pães, bolos, biscoitos e similares',1),(517,'4637105','Comércio atacadista de massas alimentícias',1),(518,'4637106','Comércio atacadista de sorvetes',1),(519,'4639701','Comércio atacadista de produtos alimentícios em geral',1),(520,'4639701','- Comércio atacadista de produtos alimentícios em geral',1),(521,'4641901','Comércio atacadista de tecidos',1),(522,'4641902','Comércio atacadista de artigos de cama, mesa e banho',1),(523,'4641903','Comércio atacadista de artigos de armarinho',1),(524,'4643501','Comércio atacadista de calçados',1),(525,'4643502','Comércio atacadista de bolsas, malas e artigos de viagem',1),(526,'4644301','Comércio atacadista de medicamentos e drogas de uso humano',1),(527,'4645102','Comércio atacadista de próteses e artigos de ortopedia',1),(528,'4645103','Comércio atacadista de produtos odontológicos',1),(529,'4646001','Comércio atacadista de cosméticos e produtos de perfumaria',1),(530,'4646002','Comércio atacadista de produtos de higiene pessoal',1),(531,'4646002','Comércio atacadista de produtos de higiene pessoal',1),(532,'4647801','Comércio atacadista de artigos de escritório e de papelaria',1),(533,'4647802','Comércio atacadista de livros, jornais e outras publicações',1),(534,'4649404','Comércio atacadista de móveis e artigos de colchoaria',1),(535,'4649406','Comércio atacadista de lustres, luminárias e abajures',1),(536,'4649407','Comércio atacadista de filmes, CDs, DVDs, fitas e discos',1),(537,'4651601','Comércio atacadista de equipamentos de informática',1),(538,'4651602','Comércio atacadista de suprimentos para informática',1),(539,'4651602','- Comércio atacadista de suprimentos para informática',1),(540,'4669901','Comércio atacadista de bombas e compressores; partes e peças',1),(541,'4671100','Comércio atacadista de madeira e produtos derivados',1),(542,'4672900','Comércio atacadista de ferragens e ferramentas',1),(543,'4672900','- Comércio atacadista de ferragens e ferramentas',1),(544,'4673700','Comércio atacadista de material elétrico',1),(545,'4674500','Comércio atacadista de cimento',1),(546,'4679601','Comércio atacadista de tintas, vernizes e similares',1),(547,'4679602','Comércio atacadista de mármores e granitos',1),(548,'4679603','Comércio atacadista de vidros, espelhos e vitrais',1),(549,'4679699','Comércio atacadista de materiais de construção em geral',1),(550,'4679699','- Comércio atacadista de materiais de construção em geral',1),(551,'4681805','Comércio atacadista de lubrificantes',1),(552,'4682600','Comércio atacadista de gás liquefeito de petróleo (GLP)',1),(553,'4684201','Comércio atacadista de resinas e elastômeros',1),(554,'4684202','Comércio atacadista de solventes',1),(555,'4686901','Comércio atacadista de papel e papelão em bruto',1),(556,'4686902','Comércio atacadista de embalagens',1),(557,'4687701','Comércio atacadista de resíduos de papel e papelão',1),(558,'4687703','Comércio atacadista de resíduos e sucatas metálicos',1),(559,'4689302','Comércio atacadista de fios e fibras beneficiados',1),(560,'4713001','Lojas de departamentos ou magazines',1),(561,'4721102','Padaria e confeitaria com predominância de revenda',1),(562,'4721103','Comércio varejista de laticínios e frios',1),(563,'4721104','Comércio varejista de doces, balas, bombons e semelhantes',1),(564,'4722901','Comércio varejista de carnes - açougues',1),(565,'4722902','Peixaria',1),(566,'4723700','Comércio varejista de bebidas',1),(567,'4724500','Comércio varejista de hortifrutigranjeiros',1),(568,'4729601','Tabacaria',1),(569,'4729602','Comércio varejista de mercadorias em lojas de conveniência',1),(570,'4731800','Comércio varejista de combustíveis para veículos automotores',1),(571,'4732600','Comércio varejista de lubrificantes',1),(572,'4732600','- Comércio varejista de lubrificantes',1),(573,'4741500','Comércio varejista de tintas e materiais para pintura',1),(574,'4742300','Comércio varejista de material elétrico',1),(575,'4743100','Comércio varejista de vidros',1),(576,'4744001','Comércio varejista de ferragens e ferramentas',1),(577,'4744002','Comércio varejista de madeira e artefatos',1),(578,'4744003','Comércio varejista de materiais hidráulicos',1),(579,'4744006','Comércio varejista de pedras para revestimento',1),(580,'4744099','Comércio varejista de materiais de construção em geral',1),(581,'4744099','- Comércio varejista de materiais de construção em geral',1),(582,'4751202','Recarga de cartuchos para equipamentos de informática',1),(583,'4754701','Comércio varejista de móveis',1),(584,'4754702','Comércio varejista de artigos de colchoaria',1),(585,'4754703','Comércio varejista de artigos de iluminação',1),(586,'4754703','- Comércio varejista de artigos de iluminação',1),(587,'4755501','Comércio varejista de tecidos',1),(588,'4755502','Comercio varejista de artigos de armarinho',1),(589,'4755502','Comercio varejista de artigos de armarinho',1),(590,'4755503','Comercio varejista de artigos de cama, mesa e banho',1),(591,'4761001','Comércio varejista de livros',1),(592,'4761002','Comércio varejista de jornais e revistas',1),(593,'4761003','Comércio varejista de artigos de papelaria',1),(594,'4762800','Comércio varejista de discos, CDs, DVDs e fitas',1),(595,'4763601','Comércio varejista de brinquedos e artigos recreativos',1),(596,'4763601','- Comércio varejista de brinquedos e artigos recreativos',1),(597,'4763602','Comércio varejista de artigos esportivos',1),(598,'4763604','Comércio varejista de artigos de caça, pesca e camping',1),(599,'4771703','Comércio varejista de produtos farmacêuticos homeopáticos',1),(600,'4771704','Comércio varejista de medicamentos veterinários',1),(601,'4771704','- Comércio varejista de medicamentos veterinários',1),(602,'4773300','Comércio varejista de artigos médicos e ortopédicos',1),(603,'4774100','Comércio varejista de artigos de óptica',1),(604,'4781400','Comércio varejista de artigos do vestuário e acessórios',1),(605,'4782201','Comércio varejista de calçados',1),(606,'4782202','Comércio varejista de artigos de viagem',1),(607,'4783101','Comércio varejista de artigos de joalheria',1),(608,'4783102','Comércio varejista de artigos de relojoaria',1),(609,'4783102','Comércio varejista de artigos de relojoaria',1),(610,'4784900','Comércio varejista de gás liqüefeito de petróleo (GLP)',1),(611,'4785701','Comércio varejista de antiguidades',1),(612,'4785799','Comércio varejista de outros artigos usados',1),(613,'4789001','Comércio varejista de suvenires, bijuterias e artesanatos',1),(614,'4789002','Comércio varejista de plantas e flores naturais',1),(615,'4789003','Comércio varejista de objetos de arte',1),(616,'4789005','Comércio varejista de produtos saneantes domissanitários',1),(617,'4789007','Comércio varejista de equipamentos para escritório',1),(618,'4789008','Comércio varejista de artigos fotográficos e para filmagem',1),(619,'4789009','Comércio varejista de armas e munições',1),(620,'4911600','Transporte ferroviário de carga',1),(621,'4912403','Transporte metroviário',1),(622,'4923001','Serviço de táxi',1),(623,'4924800','Transporte escolar',1),(624,'4930203','Transporte rodoviário de produtos perigosos',1),(625,'4930204','Transporte rodoviário de mudanças',1),(626,'4940000','Transporte dutoviário',1),(627,'4950700','Trens turísticos, teleféricos e similares',1),(628,'5011401','Transporte marítimo de cabotagem - Carga',1),(629,'5011402','Transporte marítimo de cabotagem - Passageiros',1),(630,'5012201','Transporte marítimo de longo curso - Carga',1),(631,'5012202','Transporte marítimo de longo curso - Passageiros',1),(632,'5030101','Navegação de apoio marítimo',1),(633,'5030102','Navegação de apoio portuário',1),(634,'5030103','Serviço de rebocadores e empurradores',1),(635,'5091201','Transporte por navegação de travessia, municipal',1),(636,'5099801','Transporte aquaviário para passeios turísticos',1),(637,'5111100','Transporte aéreo de passageiros regular',1),(638,'5112901','Serviço de táxi aéreo e locação de aeronaves com tripulação',1),(639,'5120000','Transporte aéreo de carga',1),(640,'5130700','Transporte espacial',1),(641,'5211701','Armazéns gerais - emissão de warrant',1),(642,'5211702','Guarda-móveis',1),(643,'5211702','- Guarda-móveis',1),(644,'5212500','Carga e descarga',1),(645,'5212500','Carga e descarga',1),(646,'5222200','Terminais rodoviários e ferroviários',1),(647,'5223100','Estacionamento de veículos',1),(648,'5229002','Serviços de reboque de veículos',1),(649,'5231101','- Administração da infra-estrutura portuária',1),(650,'5231101','Administração da infraestrutura portuária',1),(651,'5231102','Operações de terminais',1),(652,'5231102','Atividades do Operador Portuário',1),(653,'5231103','Gestão de terminais aquaviários',1),(654,'5232000','Atividades de agenciamento marítimo',1),(655,'5239701','Serviços de praticagem',1),(656,'5240101','Operação dos aeroportos e campos de aterrissagem',1),(657,'5250801','Comissaria de despachos',1),(658,'5250802','Atividades de despachantes aduaneiros',1),(659,'5250803','Agenciamento de cargas, exceto para o transporte marítimo',1),(660,'5250804','Organização logística do transporte de carga',1),(661,'5250804','- Organização logística do transporte de carga',1),(662,'5250805','Operador de transporte multimodal - OTM',1),(663,'5310501','Atividades do Correio Nacional',1),(664,'5310502','- Atividades de franqueadas do Correio Nacional',1),(665,'5320211','Serviços de malote não realizados pelo Correio Nacional',1),(666,'5320212','Serviços de entrega rápida',1),(667,'5510801','Hotéis',1),(668,'5510802','Apart-hotéis',1),(669,'5510803','Motéis',1),(670,'5590601','Albergues, exceto assistenciais',1),(671,'5590602','Campings',1),(672,'5590603','Pensões (alojamento)',1),(673,'5590699','Outros alojamentos não especificados anteriormente',1),(674,'5611201','Restaurantes e similares',1),(675,'5611203','Lanchonetes, casas de chá, de sucos e similares',1),(676,'5612100','Serviços ambulantes de alimentação',1),(677,'5620102','Serviços de alimentação para eventos e recepções - bufê',1),(678,'5620103','Cantinas - serviços de alimentação privativos',1),(679,'5811500','Edição de livros',1),(680,'5812301','Edição de jornais diários',1),(681,'5812302','Edição de jornais não diários',1),(682,'5813100','Edição de revistas',1),(683,'5813100','- Edição de revistas',1),(684,'5819100','Edição de cadastros, listas e outros produtos gráficos',1),(685,'5821200','Edição integrada à impressão de livros',1),(686,'5822101','Edição integrada à impressão de jornais diários',1),(687,'5822102','Edição integrada à impressão de jornais não diários',1),(688,'5823900','Edição integrada à impressão de revistas',1),(689,'5823900','Edição integrada à impressão de revistas',1),(690,'5911101','Estúdios cinematográficos',1),(691,'5911102','Produção de filmes para publicidade',1),(692,'5911102','- Produção de filmes para publicidade',1),(693,'5912001','Serviços de dublagem',1),(694,'5912002','Serviços de mixagem sonora em produção audiovisual',1),(695,'5914600','Atividades de exibição cinematográfica',1),(696,'5920100','Atividades de gravação de som e de edição de música',1),(697,'600001','- Extração de petróleo e gás natural',1),(698,'6010100','Atividades de rádio',1),(699,'6021700','Atividades de televisão aberta',1),(700,'6022501','Programadoras',1),(701,'6110801','Serviços de telefonia fixa comutada - STFC',1),(702,'6110802','Serviços de redes de transporte de telecomunicações - SRTT',1),(703,'6110803','Serviços de comunicação multimídia - SCM',1),(704,'6120501','Telefonia móvel celular',1),(705,'6120502','Serviço móvel especializado - SME',1),(706,'6130200','Telecomunicações por satélite',1),(707,'6141800','Operadoras de televisão por assinatura por cabo',1),(708,'6142600','Operadoras de televisão por assinatura por micro-ondas',1),(709,'6143400','Operadoras de televisão por assinatura por satélite',1),(710,'6190601','Provedores de acesso às redes de comunicações',1),(711,'6190602','Provedores de voz sobre protocolo Internet - VOIP',1),(712,'6201501','Desenvolvimento de programas de computador sob encomenda',1),(713,'6201502','Web desing',1),(714,'6204000','Consultoria em tecnologia da informação',1),(715,'6391700','Agências de notícias',1),(716,'6410700','Banco Central',1),(717,'6421200','Bancos comerciais',1),(718,'6422100','Bancos múltiplos, com carteira comercial',1),(719,'6423900','Caixas econômicas',1),(720,'6424701','Bancos cooperativos',1),(721,'6424702','Cooperativas centrais de crédito',1),(722,'6424703','Cooperativas de crédito mútuo',1),(723,'6424704','Cooperativas de crédito rural',1),(724,'6431000','Bancos múltiplos, sem carteira comercial',1),(725,'6432800','Bancos de investimento',1),(726,'6433600','Bancos de desenvolvimento',1),(727,'6434400','Agências de fomento',1),(728,'6435201','Sociedades de crédito imobiliário',1),(729,'6435202','Associações de poupança e empréstimo',1),(730,'6435203','Companhias hipotecárias',1),(731,'6437900','Sociedades de crédito ao microempreendedor',1),(732,'6438701','Bancos de câmbio',1),(733,'6440900','Arrendamento mercantil',1),(734,'6450600','Sociedades de capitalização',1),(735,'6461100','Holdings de instituições financeiras',1),(736,'6462000','Holdings de instituições não-financeiras',1),(737,'6462000','Holdings de instituições não financeiras',1),(738,'6463800','Outras sociedades de participação, exceto holdings',1),(739,'6470102','Fundos de investimento previdenciários',1),(740,'6470103','Fundos de investimento imobiliários',1),(741,'6491300','Sociedades de fomento mercantil - factoring',1),(742,'6492100','Securitização de créditos',1),(743,'6499901','Clubes de investimento',1),(744,'6499902','Sociedades de investimento',1),(745,'6499903','Fundo garantidor de crédito',1),(746,'6499904','Caixas de financiamento de corporações',1),(747,'6499905','Concessão de crédito pelas OSCIP',1),(748,'6511101','Sociedade seguradora de seguros vida',1),(749,'6511102','Planos de auxílio-funeral',1),(750,'6512000','Seguros não-vida',1),(751,'6512000','Sociedade seguradora de seguros não vida',1),(752,'6520100','Sociedade seguradora de seguros-saúde',1),(753,'6530800','Resseguros',1),(754,'6541300','Previdência complementar fechada',1),(755,'6542100','Previdência complementar aberta',1),(756,'6550200','Planos de saúde',1),(757,'6611801','Bolsa de valores',1),(758,'6611802','Bolsa de mercadorias',1),(759,'6611803','Bolsa de mercadorias e futuros',1),(760,'6611804','Administração de mercados de balcão organizados',1),(761,'6612601','Corretoras de títulos e valores mobiliários',1),(762,'6612602','Distribuidoras de títulos e valores mobiliários',1),(763,'6612603','Corretoras de câmbio',1),(764,'6612604','Corretoras de contratos de mercadorias',1),(765,'6612605','Agentes de investimentos em aplicações financeiras',1),(766,'6613400','Administração de cartões de crédito',1),(767,'6613400','Administração de cartões de crédito',1),(768,'6619301','Serviços de liquidação e custódia',1),(769,'6619302','Correspondentes de instituições financeiras',1),(770,'6619303','Representações de bancos estrangeiros',1),(771,'6619304','Caixas eletrônicos',1),(772,'6619305','Operadoras de cartões de débito',1),(773,'6621501','Peritos e avaliadores de seguros',1),(774,'6621502','Auditoria e consultoria atuarial',1),(775,'6810201','Compra e venda de imóveis próprios',1),(776,'6810202','Aluguel de imóveis próprios',1),(777,'6810203','Loteamento de imóveis próprios',1),(778,'6821801','Corretagem na compra e venda e avaliação de imóveis',1),(779,'6821802','Corretagem no aluguel de imóveis',1),(780,'6822600','Gestão e administração da propriedade imobiliária',1),(781,'6911701','Serviços advocatícios',1),(782,'6911702','Atividades auxiliares da justiça',1),(783,'6911703','Agente de propriedade industrial',1),(784,'6912500','Cartórios',1),(785,'6920601','Atividades de contabilidade',1),(786,'6920602','Atividades de consultoria e auditoria contábil e tributária',1),(787,'7111100','Serviços de arquitetura',1),(788,'7112000','Serviços de engenharia',1),(789,'7119701','Serviços de cartografia, topografia e geodésia',1),(790,'7119702','Atividades de estudos geológicos',1),(791,'7120100','Testes e análises técnicas',1),(792,'7311400','Agências de publicidade',1),(793,'7319001','Criação de estandes para feiras e exposições',1),(794,'7319002','Promoção de vendas',1),(795,'7319003','Marketing direto',1),(796,'7319004','Consultoria em publicidade',1),(797,'7320300','Pesquisas de mercado e de opinião pública',1),(798,'7320300','- Pesquisas de mercado e de opinião pública',1),(799,'7410202','Design de interiores',1),(800,'7410203','- Design de produto',1),(801,'7410203','Desing de produto',1),(802,'7410299','Atividades de desing não especificadas anteriormente',1),(803,'7420002','Atividades de produção de fotografias aéreas e submarinas',1),(804,'7420003','Laboratórios fotográficos',1),(805,'7420004','Filmagem de festas e eventos',1),(806,'7420005','Serviços de microfilmagem',1),(807,'7490101','Serviços de tradução, interpretação e similares',1),(808,'7490102','Escafandria e mergulho',1),(809,'7500100','Atividades veterinárias',1),(810,'7711000','Locação de automóveis sem condutor',1),(811,'7711000','Locação de automóveis sem condutor',1),(812,'7719502','Locação de aeronaves sem tripulação',1),(813,'7721700','Aluguel de equipamentos recreativos e esportivos',1),(814,'7722500','Aluguel de fitas de vídeo, DVDs e similares',1),(815,'7723300','Aluguel de objetos do vestuário, jóias e acessórios',1),(816,'7729201','Aluguel de aparelhos de jogos eletrônicos',1),(817,'7729203','Aluguel de material médico',1),(818,'7731400','Aluguel de máquinas e equipamentos agrícolas sem operador',1),(819,'7731400','Aluguel de máquinas e equipamentos agrícolas sem operador',1),(820,'7732202','Aluguel de andaimes',1),(821,'7733100','Aluguel de máquinas e equipamentos para escritório',1),(822,'7733100','- Aluguel de máquinas e equipamentos para escritórios',1),(823,'7740300','- Gestão de ativos intangíveis não-financeiros',1),(824,'7740300','Gestão de ativos intangíveis não financeiros',1),(825,'7810800','Seleção e agenciamento de mão-de-obra',1),(826,'7810800','Seleção e agenciamento de mão de obra',1),(827,'7820500','- Locação de mão-de-obra temporária',1),(828,'7820500','Locação de mão de obra temporária',1),(829,'7830200','Fornecimento e gestão de recursos humanos para terceiros',1),(830,'7911200','Agências de viagens',1),(831,'7912100','Operadores turísticos',1),(832,'8011101','Atividades de vigilância e segurança privada',1),(833,'8011102','Serviços de adestramento de cães de guarda',1),(834,'8012900','Atividades de transporte de valores',1),(835,'8020002','Outras atividades de serviços de segurança',1),(836,'8030700','Atividades de investigação particular',1),(837,'8112500','Condomínios prediais',1),(838,'8121400','Limpeza em prédios e em domicílios',1),(839,'8122200','Imunização e controle de pragas urbanas',1),(840,'8129000','Atividades de limpeza não especificadas anteriormente',1),(841,'8130300','Atividades paisagísticas',1),(842,'8211300','Serviços combinados de escritório e apoio administrativo',1),(843,'8219901','Fotocópias',1),(844,'8220210','Atividades de teleatendimento',1),(845,'8230002','Casas de festas e eventos',1),(846,'8291100','- Atividades de cobranças e informações cadastrais',1),(847,'8291100','Atividades de cobrança e informações cadastrais',1),(848,'8292000','Envasamento e empacotamento sob contrato',1),(849,'8299701','Medição de consumo de energia elétrica, gás e água',1),(850,'8299702','Emissão de vales-alimentação, vales-transporte e similares',1),(851,'8299703','Serviços de gravação de carimbos, exceto confecção',1),(852,'8299704','Leiloeiros independentes',1),(853,'8299705','Serviços de levantamento de fundos sob contrato',1),(854,'8299706','Casas lotéricas',1),(855,'8299707','Salas de acesso à Internet',1),(856,'8411600','Administração pública em geral',1),(857,'8413200','Regulação das atividades econômicas',1),(858,'8421300','Relações exteriores',1),(859,'8422100','Defesa',1),(860,'8422100','- Defesa',1),(861,'8423000','Justiça',1),(862,'8424800','Segurança e ordem pública',1),(863,'8425600','Defesa Civil',1),(864,'8430200','Seguridade social obrigatória',1),(865,'8511200','Educação infantil - creche',1),(866,'8512100','Educação infantil - pré-escola',1),(867,'8513900','Ensino fundamental',1),(868,'8520100','Ensino médio',1),(869,'8520100','Ensino médio',1),(870,'8531700','Educação superior - graduação',1),(871,'8532500','Educação superior - graduação e pós-graduação',1),(872,'8533300','Educação superior - pós-graduação e extensão',1),(873,'8541400','Educação profissional de nível técnico',1),(874,'8541400','- Educação profissional de nível técnico',1),(875,'8542200','Educação profissional de nível tecnológico',1),(876,'8550301','Administração de caixas escolares',1),(877,'8550302','Atividades de apoio à educação, exceto caixas escolares',1),(878,'8591100','Ensino de esportes',1),(879,'8592901','Ensino de dança',1),(880,'8592902','Ensino de artes cênicas, exceto dança',1),(881,'8592903','Ensino de música',1),(882,'8592999','Ensino de arte e cultura não especificado anteriormente',1),(883,'8593700','Ensino de idiomas',1),(884,'8599601','Formação de condutores',1),(885,'8599602','Cursos de pilotagem',1),(886,'8599603','Treinamento em informática',1),(887,'8599604','Treinamento em desenvolvimento profissional e gerencial',1),(888,'8599605','Cursos preparatórios para concursos',1),(889,'8599699','Outras atividades de ensino não especificadas anteriormente',1),(890,'8599699','Outras atividades de ensino não especificadas anteriormente',1),(891,'8621601','UTI móvel',1),(892,'8630503','Atividade médica ambulatorial restrita a consultas',1),(893,'8630504','Atividade odontológica',1),(894,'8630506','Serviços de vacinação e imunização humana',1),(895,'8630507','Atividades de reprodução humana assistida',1),(896,'8640201','Laboratórios de anatomia patológica e citológica',1),(897,'8640202','Laboratórios clínicos',1),(898,'8640203','Serviços de diálise e nefrologia',1),(899,'8640204','Serviços de tomografia',1),(900,'8640206','Serviços de ressonância magnética',1),(901,'8640210','Serviços de quimioterapia',1),(902,'8640211','Serviços de radioterapia',1),(903,'8640212','Serviços de hemoterapia',1),(904,'8640213','Serviços de litotripsia',1),(905,'8640214','Serviços de bancos de células e tecidos humanos',1),(906,'8650001','Atividades de enfermagem',1),(907,'8650002','Atividades de profissionais da nutrição',1),(908,'8650003','Atividades de psicologia e psicanálise',1),(909,'8650004','Atividades de fisioterapia',1),(910,'8650005','Atividades de terapia ocupacional',1),(911,'8650006','Atividades de fonoaudiologia',1),(912,'8650007','Atividades de terapia de nutrição enteral e parenteral',1),(913,'8660700','Atividades de apoio à gestão de saúde',1),(914,'8690902','Atividades de bancos de leite humano',1),(915,'8690903','Atividades de acupuntura',1),(916,'8690904','Atividades de podologia',1),(917,'8711501','Clínicas e residências geriátricas',1),(918,'8711502','Instituições de longa permanência para idosos',1),(919,'8711504','Centros de apoio a pacientes com câncer e com AIDS',1),(920,'8711505','Condomínios residenciais para idosos',1),(921,'8720401','Atividades de centros de assistência psicossocial',1),(922,'8730101','Orfanatos',1),(923,'8730102','Albergues assistenciais',1),(924,'8800600','Serviços de assistência social sem alojamento',1),(925,'8800600','- Serviços de assistência social sem alojamento',1),(926,'9001901','Produção teatral',1),(927,'9001902','Produção musical',1),(928,'9001903','Produção de espetáculos de dança',1),(929,'9001904','Produção de espetáculos circenses, de marionetes e similares',1),(930,'9001905','Produção de espetáculos de rodeios, vaquejadas e similares',1),(931,'9001906','Atividades de sonorização e de iluminação',1),(932,'9002702','Restauração de obras de arte',1),(933,'9101500','Atividades de bibliotecas e arquivos',1),(934,'9102302','Restauração e conservação de lugares e prédios históricos',1),(935,'9200301','Casas de bingo',1),(936,'9200302','Exploração de apostas em corridas de cavalos',1),(937,'9311500','Gestão de instalações de esportes',1),(938,'9312300','Clubes sociais, esportivos e similares',1),(939,'9313100','Atividades de condicionamento físico',1),(940,'9319101','Produção e promoção de eventos esportivos',1),(941,'9319101','Produção e promoção de eventos esportivos',1),(942,'9319199','Outras atividades esportivas não especificadas anteriormente',1),(943,'9321200','Parques de diversão e parques temáticos',1),(944,'9329801','Discotecas, danceterias, salões de dança e similares',1),(945,'9329802','Exploração de boliches',1),(946,'9329803','Exploração de jogos de sinuca, bilhar e similares',1),(947,'9329804','Exploração de jogos eletrônicos recreativos',1),(948,'9412001','Atividades de fiscalização profissional',1),(949,'9412099','Outras atividades associativas profissionais',1),(950,'9420100','Atividades de organizações sindicais',1),(951,'9430800','Atividades de associações de defesa de direitos sociais',1),(952,'9491000','Atividades de organizações religiosas ou filosóficas',1),(953,'9492800','Atividades de organizações políticas',1),(954,'9499500','Atividades associativas não especificadas anteriormente',1),(955,'9499500','- Atividades associativas não especificadas anteriormente',1),(956,'9512600','Reparação e manutenção de equipamentos de comunicação',1),(957,'9529101','Reparação de calçados, bolsas e artigos de viagem',1),(958,'9529102','Chaveiros',1),(959,'9529103','Reparação de relógios',1),(960,'9529105','Reparação de artigos do mobiliário',1),(961,'9529105','- Reparação de artigos do mobiliário',1),(962,'9529106','Reparação de jóias',1),(963,'9601701','Lavanderias',1),(964,'9601702','Tinturarias',1),(965,'9601702','- Tinturarias',1),(966,'9601703','Toalheiros',1),(967,'9602501','Cabeleireiros',1),(968,'9602501','Cabeleireiros, manicure e pedicure',1),(969,'9603301','Gestão e manutenção de cemitérios',1),(970,'9603302','Serviços de cremação',1),(971,'9603303','Serviços de sepultamento',1),(972,'9603304','Serviços de funerárias',1),(973,'9603305','Serviços de somatoconservação',1),(974,'9609202','Agências matrimoniais',1),(975,'9609205','Atividades de sauna e banhos',1),(976,'9609206','Serviços de tatuagem e colocação de piercing',1),(977,'9609207','Alojamento de animais domésticos',1),(978,'9609208','Higiene e embelezamento de animais domésticos',1),(979,'9700500','Serviços domésticos',1),(980,'990403','- Atividades de apoio à extração de minerais não-metálicos',1);
/*!40000 ALTER TABLE `cnae` ENABLE KEYS */;
UNLOCK TABLES;

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
  `name` varchar(13) NOT NULL,
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
  `document_value` float(9,4) NOT NULL,
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

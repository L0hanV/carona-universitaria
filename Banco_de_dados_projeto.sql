CREATE DATABASE  IF NOT EXISTS `caronas_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `caronas_db`;
-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: caronas_db
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `avaliacoes`
--

DROP TABLE IF EXISTS `avaliacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `avaliacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `carona_id` int NOT NULL,
  `avaliador_id` int NOT NULL,
  `avaliado_id` int NOT NULL,
  `nota` int NOT NULL,
  `comentario` varchar(500) DEFAULT NULL,
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `carona_id` (`carona_id`,`avaliador_id`,`avaliado_id`),
  KEY `avaliador_id` (`avaliador_id`),
  KEY `avaliado_id` (`avaliado_id`),
  CONSTRAINT `avaliacoes_ibfk_1` FOREIGN KEY (`carona_id`) REFERENCES `caronas` (`id`),
  CONSTRAINT `avaliacoes_ibfk_2` FOREIGN KEY (`avaliador_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `avaliacoes_ibfk_3` FOREIGN KEY (`avaliado_id`) REFERENCES `usuarios` (`id`),
  CONSTRAINT `chk_nota` CHECK ((`nota` between 1 and 5)),
  CONSTRAINT `chk_usuarios_diferentes` CHECK ((`avaliador_id` <> `avaliado_id`))
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `avaliacoes`
--

LOCK TABLES `avaliacoes` WRITE;
/*!40000 ALTER TABLE `avaliacoes` DISABLE KEYS */;
INSERT INTO `avaliacoes` VALUES (1,1,2,1,5,'Motorista pontual e educado.','2026-11-20 04:54:52'),(2,1,1,2,5,'Passageiro é top.','2026-11-20 04:57:04');
/*!40000 ALTER TABLE `avaliacoes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `validar_avaliacao` BEFORE INSERT ON `avaliacoes` FOR EACH ROW BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM caronas c
        INNER JOIN solicitacoes s
            ON s.carona_id = c.id
        WHERE c.id = NEW.carona_id
          AND c.status = 'concluida'
          AND s.status = 'aceita'
          AND (
              (
                  NEW.avaliador_id = c.motorista_id
                  AND NEW.avaliado_id = s.passageiro_id
              )
              OR
              (
                  NEW.avaliador_id = s.passageiro_id
                  AND NEW.avaliado_id = c.motorista_id
              )
          )
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
            'Avaliacao nao permitida para esta viagem';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bloquear_alteracao_avaliacao` BEFORE UPDATE ON `avaliacoes` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT =
        'Avaliacoes cadastradas nao podem ser alteradas';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `bloquear_exclusao_avaliacao` BEFORE DELETE ON `avaliacoes` FOR EACH ROW BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT =
        'Avaliacoes cadastradas nao podem ser excluidas';
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `caronas`
--

DROP TABLE IF EXISTS `caronas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `caronas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `motorista_id` int NOT NULL,
  `origem` varchar(150) NOT NULL,
  `destino` varchar(150) NOT NULL,
  `data_hora_saida` datetime NOT NULL,
  `vagas_disponiveis` int NOT NULL,
  `criando_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('agendada','em_andamento','concluida','cancelada') NOT NULL DEFAULT 'agendada',
  PRIMARY KEY (`id`),
  KEY `motorista_id` (`motorista_id`),
  CONSTRAINT `caronas_ibfk_1` FOREIGN KEY (`motorista_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `caronas`
--

LOCK TABLES `caronas` WRITE;
/*!40000 ALTER TABLE `caronas` DISABLE KEYS */;
INSERT INTO `caronas` VALUES (1,1,'Terminal da Parangaba','Estacio Parangaba','2026-11-23 18:30:00',2,'2026-11-19 22:47:36','concluida'),(2,1,'Terminal da Parangaba','Estacio Parangaba','2026-12-10 18:00:00',2,'2026-11-20 05:20:58','agendada');
/*!40000 ALTER TABLE `caronas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitacoes`
--

DROP TABLE IF EXISTS `solicitacoes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitacoes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `carona_id` int NOT NULL,
  `passageiro_id` int NOT NULL,
  `status` enum('pendente','aceita','recusada','cancelada') NOT NULL DEFAULT 'pendente',
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `carona_id` (`carona_id`,`passageiro_id`),
  KEY `passageiro_id` (`passageiro_id`),
  CONSTRAINT `solicitacoes_ibfk_1` FOREIGN KEY (`carona_id`) REFERENCES `caronas` (`id`),
  CONSTRAINT `solicitacoes_ibfk_2` FOREIGN KEY (`passageiro_id`) REFERENCES `usuarios` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitacoes`
--

LOCK TABLES `solicitacoes` WRITE;
/*!40000 ALTER TABLE `solicitacoes` DISABLE KEYS */;
INSERT INTO `solicitacoes` VALUES (1,1,2,'aceita','2026-11-20 03:33:30'),(2,2,2,'aceita','2026-11-20 05:21:26');
/*!40000 ALTER TABLE `solicitacoes` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `controlar_vagas` BEFORE UPDATE ON `solicitacoes` FOR EACH ROW BEGIN
    IF OLD.status = 'pendente'
       AND NEW.status = 'aceita' THEN

        UPDATE caronas
        SET vagas_disponiveis = vagas_disponiveis - 1
        WHERE id = NEW.carona_id
          AND status = 'agendada'
          AND vagas_disponiveis > 0;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Carona sem vagas ou indisponivel';
        END IF;

    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuarios` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `senha_hash` varchar(255) NOT NULL,
  `telefone` varchar(20) NOT NULL,
  `eh_motorista` tinyint(1) DEFAULT '0',
  `criado_em` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuarios`
--

LOCK TABLES `usuarios` WRITE;
/*!40000 ALTER TABLE `usuarios` DISABLE KEYS */;
INSERT INTO `usuarios` VALUES (1,'Mototista Teste','motorista.teste@exemplo.com','testetesteteste','85999999999',1,'2026-11-19 22:30:27'),(2,'Passageiro Teste','Passageiro.teste@exemplo.com','testetesteteste','85999999999',0,'2026-11-19 23:31:36'),(3,'Estudante Teste','estudante.teste@example.com','testetesteteste','85988888888',0,'2026-11-20 05:09:00');
/*!40000 ALTER TABLE `usuarios` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-20  2:37:36

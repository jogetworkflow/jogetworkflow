-- MySQL dump 10.13  Distrib 5.1.41, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: jogetdb
-- ------------------------------------------------------
-- Server version	5.1.41-3ubuntu12.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `SHKActivities`
--

DROP TABLE IF EXISTS `SHKActivities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivities` (
  `Id` varchar(100) NOT NULL,
  `ActivitySetDefinitionId` varchar(90) DEFAULT NULL,
  `ActivityDefinitionId` varchar(90) NOT NULL,
  `Process` decimal(19,0) NOT NULL,
  `TheResource` decimal(19,0) DEFAULT NULL,
  `PDefName` varchar(200) NOT NULL,
  `ProcessId` varchar(200) NOT NULL,
  `ResourceId` varchar(100) DEFAULT NULL,
  `State` decimal(19,0) NOT NULL,
  `BlockActivityId` varchar(100) DEFAULT NULL,
  `Performer` varchar(100) DEFAULT NULL,
  `IsPerformerAsynchronous` smallint(6) DEFAULT NULL,
  `Priority` int(11) DEFAULT NULL,
  `Name` varchar(254) DEFAULT NULL,
  `Activated` bigint(20) NOT NULL,
  `ActivatedTZO` bigint(20) NOT NULL,
  `Accepted` bigint(20) DEFAULT NULL,
  `AcceptedTZO` bigint(20) DEFAULT NULL,
  `LastStateTime` bigint(20) NOT NULL,
  `LastStateTimeTZO` bigint(20) NOT NULL,
  `LimitTime` bigint(20) NOT NULL,
  `LimitTimeTZO` bigint(20) NOT NULL,
  `Description` varchar(254) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivities` (`Id`),
  KEY `SHKActivities_TheResource` (`TheResource`),
  KEY `SHKActivities_State` (`State`),
  KEY `I2_SHKActivities` (`Process`,`ActivitySetDefinitionId`,`ActivityDefinitionId`),
  KEY `I3_SHKActivities` (`Process`,`State`),
  CONSTRAINT `SHKActivities_Process` FOREIGN KEY (`Process`) REFERENCES `SHKProcesses` (`oid`),
  CONSTRAINT `SHKActivities_State` FOREIGN KEY (`State`) REFERENCES `SHKActivityStates` (`oid`),
  CONSTRAINT `SHKActivities_TheResource` FOREIGN KEY (`TheResource`) REFERENCES `SHKResourcesTable` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivities`
--

LOCK TABLES `SHKActivities` WRITE;
/*!40000 ALTER TABLE `SHKActivities` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKActivities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKActivityData`
--

DROP TABLE IF EXISTS `SHKActivityData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivityData` (
  `Activity` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValue` mediumblob,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` double DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `IsResult` smallint(6) NOT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivityData` (`CNT`),
  UNIQUE KEY `I2_SHKActivityData` (`Activity`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKActivityData_Activity` FOREIGN KEY (`Activity`) REFERENCES `SHKActivities` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivityData`
--

LOCK TABLES `SHKActivityData` WRITE;
/*!40000 ALTER TABLE `SHKActivityData` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKActivityData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKActivityDataBLOBs`
--

DROP TABLE IF EXISTS `SHKActivityDataBLOBs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivityDataBLOBs` (
  `ActivityDataWOB` decimal(19,0) NOT NULL,
  `VariableValue` mediumblob,
  `OrdNo` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivityDataBLOBs` (`ActivityDataWOB`,`OrdNo`),
  CONSTRAINT `SHKActivityDataBLOBs_ActivityDataWOB` FOREIGN KEY (`ActivityDataWOB`) REFERENCES `SHKActivityDataWOB` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivityDataBLOBs`
--

LOCK TABLES `SHKActivityDataBLOBs` WRITE;
/*!40000 ALTER TABLE `SHKActivityDataBLOBs` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKActivityDataBLOBs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKActivityDataWOB`
--

DROP TABLE IF EXISTS `SHKActivityDataWOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivityDataWOB` (
  `Activity` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` double DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `IsResult` smallint(6) NOT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivityDataWOB` (`CNT`),
  UNIQUE KEY `I2_SHKActivityDataWOB` (`Activity`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKActivityDataWOB_Activity` FOREIGN KEY (`Activity`) REFERENCES `SHKActivities` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivityDataWOB`
--

LOCK TABLES `SHKActivityDataWOB` WRITE;
/*!40000 ALTER TABLE `SHKActivityDataWOB` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKActivityDataWOB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKActivityStateEventAudits`
--

DROP TABLE IF EXISTS `SHKActivityStateEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivityStateEventAudits` (
  `KeyValue` varchar(30) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivityStateEventAudits` (`KeyValue`),
  UNIQUE KEY `I2_SHKActivityStateEventAudits` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivityStateEventAudits`
--

LOCK TABLES `SHKActivityStateEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKActivityStateEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKActivityStateEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKActivityStates`
--

DROP TABLE IF EXISTS `SHKActivityStates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKActivityStates` (
  `KeyValue` varchar(30) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKActivityStates` (`KeyValue`),
  UNIQUE KEY `I2_SHKActivityStates` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKActivityStates`
--

LOCK TABLES `SHKActivityStates` WRITE;
/*!40000 ALTER TABLE `SHKActivityStates` DISABLE KEYS */;
INSERT INTO `SHKActivityStates` VALUES ('open.running','open.running','1000001',0),('open.not_running.not_started','open.not_running.not_started','1000003',0),('open.not_running.suspended','open.not_running.suspended','1000005',0),('closed.completed','closed.completed','1000007',0),('closed.terminated','closed.terminated','1000009',0),('closed.aborted','closed.aborted','1000011',0);
/*!40000 ALTER TABLE `SHKActivityStates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKAndJoinTable`
--

DROP TABLE IF EXISTS `SHKAndJoinTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKAndJoinTable` (
  `Process` decimal(19,0) NOT NULL,
  `BlockActivity` decimal(19,0) DEFAULT NULL,
  `ActivityDefinitionId` varchar(90) NOT NULL,
  `Activity` decimal(19,0) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKAndJoinTable` (`CNT`),
  KEY `SHKAndJoinTable_BlockActivity` (`BlockActivity`),
  KEY `I2_SHKAndJoinTable` (`Process`,`BlockActivity`,`ActivityDefinitionId`),
  KEY `I3_SHKAndJoinTable` (`Activity`),
  CONSTRAINT `SHKAndJoinTable_Activity` FOREIGN KEY (`Activity`) REFERENCES `SHKActivities` (`oid`),
  CONSTRAINT `SHKAndJoinTable_BlockActivity` FOREIGN KEY (`BlockActivity`) REFERENCES `SHKActivities` (`oid`),
  CONSTRAINT `SHKAndJoinTable_Process` FOREIGN KEY (`Process`) REFERENCES `SHKProcesses` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKAndJoinTable`
--

LOCK TABLES `SHKAndJoinTable` WRITE;
/*!40000 ALTER TABLE `SHKAndJoinTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKAndJoinTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKAssignmentEventAudits`
--

DROP TABLE IF EXISTS `SHKAssignmentEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKAssignmentEventAudits` (
  `RecordedTime` bigint(20) NOT NULL,
  `RecordedTimeTZO` bigint(20) NOT NULL,
  `TheUsername` varchar(100) NOT NULL,
  `TheType` decimal(19,0) NOT NULL,
  `ActivityId` varchar(100) NOT NULL,
  `ActivityName` varchar(254) DEFAULT NULL,
  `ProcessId` varchar(100) NOT NULL,
  `ProcessName` varchar(254) DEFAULT NULL,
  `ProcessFactoryName` varchar(200) NOT NULL,
  `ProcessFactoryVersion` varchar(20) NOT NULL,
  `ActivityDefinitionId` varchar(90) NOT NULL,
  `ActivityDefinitionName` varchar(90) DEFAULT NULL,
  `ActivityDefinitionType` int(11) NOT NULL,
  `ProcessDefinitionId` varchar(90) NOT NULL,
  `ProcessDefinitionName` varchar(90) DEFAULT NULL,
  `PackageId` varchar(90) NOT NULL,
  `OldResourceUsername` varchar(100) DEFAULT NULL,
  `OldResourceName` varchar(100) DEFAULT NULL,
  `NewResourceUsername` varchar(100) NOT NULL,
  `NewResourceName` varchar(100) DEFAULT NULL,
  `IsAccepted` smallint(6) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKAssignmentEventAudits` (`CNT`),
  KEY `SHKAssignmentEventAudits_TheType` (`TheType`),
  CONSTRAINT `SHKAssignmentEventAudits_TheType` FOREIGN KEY (`TheType`) REFERENCES `SHKEventTypes` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKAssignmentEventAudits`
--

LOCK TABLES `SHKAssignmentEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKAssignmentEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKAssignmentEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKAssignmentsTable`
--

DROP TABLE IF EXISTS `SHKAssignmentsTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKAssignmentsTable` (
  `Activity` decimal(19,0) NOT NULL,
  `TheResource` decimal(19,0) NOT NULL,
  `ActivityId` varchar(100) NOT NULL,
  `ActivityProcessId` varchar(100) NOT NULL,
  `ActivityProcessDefName` varchar(200) NOT NULL,
  `ResourceId` varchar(100) NOT NULL,
  `IsAccepted` smallint(6) NOT NULL,
  `IsValid` smallint(6) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKAssignmentsTable` (`CNT`),
  UNIQUE KEY `I2_SHKAssignmentsTable` (`Activity`,`TheResource`),
  KEY `I3_SHKAssignmentsTable` (`TheResource`,`IsValid`),
  KEY `I4_SHKAssignmentsTable` (`ActivityId`),
  KEY `I5_SHKAssignmentsTable` (`ResourceId`),
  CONSTRAINT `SHKAssignmentsTable_Activity` FOREIGN KEY (`Activity`) REFERENCES `SHKActivities` (`oid`),
  CONSTRAINT `SHKAssignmentsTable_TheResource` FOREIGN KEY (`TheResource`) REFERENCES `SHKResourcesTable` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKAssignmentsTable`
--

LOCK TABLES `SHKAssignmentsTable` WRITE;
/*!40000 ALTER TABLE `SHKAssignmentsTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKAssignmentsTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKCounters`
--

DROP TABLE IF EXISTS `SHKCounters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKCounters` (
  `name` varchar(100) NOT NULL,
  `the_number` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKCounters` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKCounters`
--

LOCK TABLES `SHKCounters` WRITE;
/*!40000 ALTER TABLE `SHKCounters` DISABLE KEYS */;
INSERT INTO `SHKCounters` VALUES ('_xpdldata_','101','1000016',0);
/*!40000 ALTER TABLE `SHKCounters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKCreateProcessEventAudits`
--

DROP TABLE IF EXISTS `SHKCreateProcessEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKCreateProcessEventAudits` (
  `RecordedTime` bigint(20) NOT NULL,
  `RecordedTimeTZO` bigint(20) NOT NULL,
  `TheUsername` varchar(100) NOT NULL,
  `TheType` decimal(19,0) NOT NULL,
  `ProcessId` varchar(100) NOT NULL,
  `ProcessName` varchar(254) DEFAULT NULL,
  `ProcessFactoryName` varchar(200) NOT NULL,
  `ProcessFactoryVersion` varchar(20) NOT NULL,
  `ProcessDefinitionId` varchar(90) NOT NULL,
  `ProcessDefinitionName` varchar(90) DEFAULT NULL,
  `PackageId` varchar(90) NOT NULL,
  `PActivityId` varchar(100) DEFAULT NULL,
  `PProcessId` varchar(100) DEFAULT NULL,
  `PProcessName` varchar(254) DEFAULT NULL,
  `PProcessFactoryName` varchar(200) DEFAULT NULL,
  `PProcessFactoryVersion` varchar(20) DEFAULT NULL,
  `PActivityDefinitionId` varchar(90) DEFAULT NULL,
  `PActivityDefinitionName` varchar(90) DEFAULT NULL,
  `PProcessDefinitionId` varchar(90) DEFAULT NULL,
  `PProcessDefinitionName` varchar(90) DEFAULT NULL,
  `PPackageId` varchar(90) DEFAULT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKCreateProcessEventAudits` (`CNT`),
  KEY `SHKCreateProcessEventAudits_TheType` (`TheType`),
  CONSTRAINT `SHKCreateProcessEventAudits_TheType` FOREIGN KEY (`TheType`) REFERENCES `SHKEventTypes` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKCreateProcessEventAudits`
--

LOCK TABLES `SHKCreateProcessEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKCreateProcessEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKCreateProcessEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKDataEventAudits`
--

DROP TABLE IF EXISTS `SHKDataEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKDataEventAudits` (
  `RecordedTime` bigint(20) NOT NULL,
  `RecordedTimeTZO` bigint(20) NOT NULL,
  `TheUsername` varchar(100) NOT NULL,
  `TheType` decimal(19,0) NOT NULL,
  `ActivityId` varchar(100) DEFAULT NULL,
  `ActivityName` varchar(254) DEFAULT NULL,
  `ProcessId` varchar(100) NOT NULL,
  `ProcessName` varchar(254) DEFAULT NULL,
  `ProcessFactoryName` varchar(200) NOT NULL,
  `ProcessFactoryVersion` varchar(20) NOT NULL,
  `ActivityDefinitionId` varchar(90) DEFAULT NULL,
  `ActivityDefinitionName` varchar(90) DEFAULT NULL,
  `ActivityDefinitionType` int(11) DEFAULT NULL,
  `ProcessDefinitionId` varchar(90) NOT NULL,
  `ProcessDefinitionName` varchar(90) DEFAULT NULL,
  `PackageId` varchar(90) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKDataEventAudits` (`CNT`),
  KEY `SHKDataEventAudits_TheType` (`TheType`),
  CONSTRAINT `SHKDataEventAudits_TheType` FOREIGN KEY (`TheType`) REFERENCES `SHKEventTypes` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKDataEventAudits`
--

LOCK TABLES `SHKDataEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKDataEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKDataEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKDeadlines`
--

DROP TABLE IF EXISTS `SHKDeadlines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKDeadlines` (
  `Process` decimal(19,0) NOT NULL,
  `Activity` decimal(19,0) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `TimeLimit` bigint(20) NOT NULL,
  `TimeLimitTZO` bigint(20) NOT NULL,
  `ExceptionName` varchar(100) NOT NULL,
  `IsSynchronous` smallint(6) NOT NULL,
  `IsExecuted` smallint(6) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKDeadlines` (`CNT`),
  KEY `I2_SHKDeadlines` (`Process`,`TimeLimit`),
  KEY `I3_SHKDeadlines` (`Activity`,`TimeLimit`),
  CONSTRAINT `SHKDeadlines_Activity` FOREIGN KEY (`Activity`) REFERENCES `SHKActivities` (`oid`),
  CONSTRAINT `SHKDeadlines_Process` FOREIGN KEY (`Process`) REFERENCES `SHKProcesses` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKDeadlines`
--

LOCK TABLES `SHKDeadlines` WRITE;
/*!40000 ALTER TABLE `SHKDeadlines` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKDeadlines` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKEventTypes`
--

DROP TABLE IF EXISTS `SHKEventTypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKEventTypes` (
  `KeyValue` varchar(30) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKEventTypes` (`KeyValue`),
  UNIQUE KEY `I2_SHKEventTypes` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKEventTypes`
--

LOCK TABLES `SHKEventTypes` WRITE;
/*!40000 ALTER TABLE `SHKEventTypes` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKEventTypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKGroupGroupTable`
--

DROP TABLE IF EXISTS `SHKGroupGroupTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKGroupGroupTable` (
  `sub_gid` decimal(19,0) NOT NULL,
  `groupid` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKGroupGroupTable` (`sub_gid`,`groupid`),
  KEY `I2_SHKGroupGroupTable` (`groupid`),
  CONSTRAINT `SHKGroupGroupTable_groupid` FOREIGN KEY (`groupid`) REFERENCES `SHKGroupTable` (`oid`),
  CONSTRAINT `SHKGroupGroupTable_sub_gid` FOREIGN KEY (`sub_gid`) REFERENCES `SHKGroupTable` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKGroupGroupTable`
--

LOCK TABLES `SHKGroupGroupTable` WRITE;
/*!40000 ALTER TABLE `SHKGroupGroupTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKGroupGroupTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKGroupTable`
--

DROP TABLE IF EXISTS `SHKGroupTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKGroupTable` (
  `groupid` varchar(100) NOT NULL,
  `description` varchar(254) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKGroupTable` (`groupid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKGroupTable`
--

LOCK TABLES `SHKGroupTable` WRITE;
/*!40000 ALTER TABLE `SHKGroupTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKGroupTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKGroupUser`
--

DROP TABLE IF EXISTS `SHKGroupUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKGroupUser` (
  `USERNAME` varchar(100) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKGroupUser` (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKGroupUser`
--

LOCK TABLES `SHKGroupUser` WRITE;
/*!40000 ALTER TABLE `SHKGroupUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKGroupUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKGroupUserPackLevelPart`
--

DROP TABLE IF EXISTS `SHKGroupUserPackLevelPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKGroupUserPackLevelPart` (
  `PARTICIPANTOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKGroupUserPackLevelPart` (`PARTICIPANTOID`,`USEROID`),
  KEY `SHKGroupUserPackLevelPart_USEROID` (`USEROID`),
  CONSTRAINT `SHKGroupUserPackLevelPart_PARTICIPANTOID` FOREIGN KEY (`PARTICIPANTOID`) REFERENCES `SHKPackLevelParticipant` (`oid`),
  CONSTRAINT `SHKGroupUserPackLevelPart_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKGroupUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKGroupUserPackLevelPart`
--

LOCK TABLES `SHKGroupUserPackLevelPart` WRITE;
/*!40000 ALTER TABLE `SHKGroupUserPackLevelPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKGroupUserPackLevelPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKGroupUserProcLevelPart`
--

DROP TABLE IF EXISTS `SHKGroupUserProcLevelPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKGroupUserProcLevelPart` (
  `PARTICIPANTOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKGroupUserProcLevelPart` (`PARTICIPANTOID`,`USEROID`),
  KEY `SHKGroupUserProcLevelPart_USEROID` (`USEROID`),
  CONSTRAINT `SHKGroupUserProcLevelPart_PARTICIPANTOID` FOREIGN KEY (`PARTICIPANTOID`) REFERENCES `SHKProcLevelParticipant` (`oid`),
  CONSTRAINT `SHKGroupUserProcLevelPart_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKGroupUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKGroupUserProcLevelPart`
--

LOCK TABLES `SHKGroupUserProcLevelPart` WRITE;
/*!40000 ALTER TABLE `SHKGroupUserProcLevelPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKGroupUserProcLevelPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKNewEventAuditData`
--

DROP TABLE IF EXISTS `SHKNewEventAuditData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKNewEventAuditData` (
  `DataEventAudit` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValue` mediumblob,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` float DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKNewEventAuditData` (`CNT`),
  UNIQUE KEY `I2_SHKNewEventAuditData` (`DataEventAudit`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKNewEventAuditData_DataEventAudit` FOREIGN KEY (`DataEventAudit`) REFERENCES `SHKDataEventAudits` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKNewEventAuditData`
--

LOCK TABLES `SHKNewEventAuditData` WRITE;
/*!40000 ALTER TABLE `SHKNewEventAuditData` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKNewEventAuditData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKNewEventAuditDataBLOBs`
--

DROP TABLE IF EXISTS `SHKNewEventAuditDataBLOBs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKNewEventAuditDataBLOBs` (
  `NewEventAuditDataWOB` decimal(19,0) NOT NULL,
  `VariableValue` mediumblob,
  `OrdNo` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKNewEventAuditDataBLOBs` (`NewEventAuditDataWOB`,`OrdNo`),
  CONSTRAINT `SHKNewEventAuditDataBLOBs_NewEventAuditDataWOB` FOREIGN KEY (`NewEventAuditDataWOB`) REFERENCES `SHKNewEventAuditDataWOB` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKNewEventAuditDataBLOBs`
--

LOCK TABLES `SHKNewEventAuditDataBLOBs` WRITE;
/*!40000 ALTER TABLE `SHKNewEventAuditDataBLOBs` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKNewEventAuditDataBLOBs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKNewEventAuditDataWOB`
--

DROP TABLE IF EXISTS `SHKNewEventAuditDataWOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKNewEventAuditDataWOB` (
  `DataEventAudit` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` float DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKNewEventAuditDataWOB` (`CNT`),
  UNIQUE KEY `I2_SHKNewEventAuditDataWOB` (`DataEventAudit`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKNewEventAuditDataWOB_DataEventAudit` FOREIGN KEY (`DataEventAudit`) REFERENCES `SHKDataEventAudits` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKNewEventAuditDataWOB`
--

LOCK TABLES `SHKNewEventAuditDataWOB` WRITE;
/*!40000 ALTER TABLE `SHKNewEventAuditDataWOB` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKNewEventAuditDataWOB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKNextXPDLVersions`
--

DROP TABLE IF EXISTS `SHKNextXPDLVersions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKNextXPDLVersions` (
  `XPDLId` varchar(90) NOT NULL,
  `NextVersion` varchar(20) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKNextXPDLVersions` (`XPDLId`,`NextVersion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKNextXPDLVersions`
--

LOCK TABLES `SHKNextXPDLVersions` WRITE;
/*!40000 ALTER TABLE `SHKNextXPDLVersions` DISABLE KEYS */;
INSERT INTO `SHKNextXPDLVersions` VALUES ('Human_Resource_WF_01','2','1000013',0);
/*!40000 ALTER TABLE `SHKNextXPDLVersions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKNormalUser`
--

DROP TABLE IF EXISTS `SHKNormalUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKNormalUser` (
  `USERNAME` varchar(100) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKNormalUser` (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKNormalUser`
--

LOCK TABLES `SHKNormalUser` WRITE;
/*!40000 ALTER TABLE `SHKNormalUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKNormalUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKOldEventAuditData`
--

DROP TABLE IF EXISTS `SHKOldEventAuditData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKOldEventAuditData` (
  `DataEventAudit` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValue` mediumblob,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` float DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKOldEventAuditData` (`CNT`),
  UNIQUE KEY `I2_SHKOldEventAuditData` (`DataEventAudit`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKOldEventAuditData_DataEventAudit` FOREIGN KEY (`DataEventAudit`) REFERENCES `SHKDataEventAudits` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKOldEventAuditData`
--

LOCK TABLES `SHKOldEventAuditData` WRITE;
/*!40000 ALTER TABLE `SHKOldEventAuditData` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKOldEventAuditData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKOldEventAuditDataBLOBs`
--

DROP TABLE IF EXISTS `SHKOldEventAuditDataBLOBs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKOldEventAuditDataBLOBs` (
  `OldEventAuditDataWOB` decimal(19,0) NOT NULL,
  `VariableValue` mediumblob,
  `OrdNo` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKOldEventAuditDataBLOBs` (`OldEventAuditDataWOB`,`OrdNo`),
  CONSTRAINT `SHKOldEventAuditDataBLOBs_OldEventAuditDataWOB` FOREIGN KEY (`OldEventAuditDataWOB`) REFERENCES `SHKOldEventAuditDataWOB` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKOldEventAuditDataBLOBs`
--

LOCK TABLES `SHKOldEventAuditDataBLOBs` WRITE;
/*!40000 ALTER TABLE `SHKOldEventAuditDataBLOBs` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKOldEventAuditDataBLOBs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKOldEventAuditDataWOB`
--

DROP TABLE IF EXISTS `SHKOldEventAuditDataWOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKOldEventAuditDataWOB` (
  `DataEventAudit` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` float DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKOldEventAuditDataWOB` (`CNT`),
  UNIQUE KEY `I2_SHKOldEventAuditDataWOB` (`DataEventAudit`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKOldEventAuditDataWOB_DataEventAudit` FOREIGN KEY (`DataEventAudit`) REFERENCES `SHKDataEventAudits` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKOldEventAuditDataWOB`
--

LOCK TABLES `SHKOldEventAuditDataWOB` WRITE;
/*!40000 ALTER TABLE `SHKOldEventAuditDataWOB` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKOldEventAuditDataWOB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelParticipant`
--

DROP TABLE IF EXISTS `SHKPackLevelParticipant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelParticipant` (
  `PARTICIPANT_ID` varchar(90) NOT NULL,
  `PACKAGEOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelParticipant` (`PARTICIPANT_ID`,`PACKAGEOID`),
  KEY `SHKPackLevelParticipant_PACKAGEOID` (`PACKAGEOID`),
  CONSTRAINT `SHKPackLevelParticipant_PACKAGEOID` FOREIGN KEY (`PACKAGEOID`) REFERENCES `SHKXPDLParticipantPackage` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelParticipant`
--

LOCK TABLES `SHKPackLevelParticipant` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelParticipant` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelParticipant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelXPDLApp`
--

DROP TABLE IF EXISTS `SHKPackLevelXPDLApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelXPDLApp` (
  `APPLICATION_ID` varchar(90) NOT NULL,
  `PACKAGEOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelXPDLApp` (`APPLICATION_ID`,`PACKAGEOID`),
  KEY `SHKPackLevelXPDLApp_PACKAGEOID` (`PACKAGEOID`),
  CONSTRAINT `SHKPackLevelXPDLApp_PACKAGEOID` FOREIGN KEY (`PACKAGEOID`) REFERENCES `SHKXPDLApplicationPackage` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelXPDLApp`
--

LOCK TABLES `SHKPackLevelXPDLApp` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelXPDLApp` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelXPDLApp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelXPDLAppTAAppDetUsr`
--

DROP TABLE IF EXISTS `SHKPackLevelXPDLAppTAAppDetUsr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelXPDLAppTAAppDetUsr` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelXPDLAppTAAppDetUsr` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKPackLevelXPDLAppTAAppDetUsr_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppDetUsr_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppDetailUser` (`oid`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppDetUsr_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKPackLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelXPDLAppTAAppDetUsr`
--

LOCK TABLES `SHKPackLevelXPDLAppTAAppDetUsr` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppDetUsr` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppDetUsr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelXPDLAppTAAppDetail`
--

DROP TABLE IF EXISTS `SHKPackLevelXPDLAppTAAppDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelXPDLAppTAAppDetail` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelXPDLAppTAAppDetail` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKPackLevelXPDLAppTAAppDetail_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppDetail_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppDetail` (`oid`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppDetail_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKPackLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelXPDLAppTAAppDetail`
--

LOCK TABLES `SHKPackLevelXPDLAppTAAppDetail` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppDetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelXPDLAppTAAppUser`
--

DROP TABLE IF EXISTS `SHKPackLevelXPDLAppTAAppUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelXPDLAppTAAppUser` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelXPDLAppTAAppUser` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKPackLevelXPDLAppTAAppUser_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppUser_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppUser` (`oid`),
  CONSTRAINT `SHKPackLevelXPDLAppTAAppUser_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKPackLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelXPDLAppTAAppUser`
--

LOCK TABLES `SHKPackLevelXPDLAppTAAppUser` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppTAAppUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKPackLevelXPDLAppToolAgntApp`
--

DROP TABLE IF EXISTS `SHKPackLevelXPDLAppToolAgntApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKPackLevelXPDLAppToolAgntApp` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKPackLevelXPDLAppToolAgntApp` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKPackLevelXPDLAppToolAgntApp_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKPackLevelXPDLAppToolAgntApp_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentApp` (`oid`),
  CONSTRAINT `SHKPackLevelXPDLAppToolAgntApp_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKPackLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKPackLevelXPDLAppToolAgntApp`
--

LOCK TABLES `SHKPackLevelXPDLAppToolAgntApp` WRITE;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppToolAgntApp` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKPackLevelXPDLAppToolAgntApp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelParticipant`
--

DROP TABLE IF EXISTS `SHKProcLevelParticipant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelParticipant` (
  `PARTICIPANT_ID` varchar(90) NOT NULL,
  `PROCESSOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelParticipant` (`PARTICIPANT_ID`,`PROCESSOID`),
  KEY `SHKProcLevelParticipant_PROCESSOID` (`PROCESSOID`),
  CONSTRAINT `SHKProcLevelParticipant_PROCESSOID` FOREIGN KEY (`PROCESSOID`) REFERENCES `SHKXPDLParticipantProcess` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelParticipant`
--

LOCK TABLES `SHKProcLevelParticipant` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelParticipant` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelParticipant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelXPDLApp`
--

DROP TABLE IF EXISTS `SHKProcLevelXPDLApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelXPDLApp` (
  `APPLICATION_ID` varchar(90) NOT NULL,
  `PROCESSOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelXPDLApp` (`APPLICATION_ID`,`PROCESSOID`),
  KEY `SHKProcLevelXPDLApp_PROCESSOID` (`PROCESSOID`),
  CONSTRAINT `SHKProcLevelXPDLApp_PROCESSOID` FOREIGN KEY (`PROCESSOID`) REFERENCES `SHKXPDLApplicationProcess` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelXPDLApp`
--

LOCK TABLES `SHKProcLevelXPDLApp` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelXPDLApp` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelXPDLApp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelXPDLAppTAAppDetUsr`
--

DROP TABLE IF EXISTS `SHKProcLevelXPDLAppTAAppDetUsr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelXPDLAppTAAppDetUsr` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelXPDLAppTAAppDetUsr` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKProcLevelXPDLAppTAAppDetUsr_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppDetUsr_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppDetailUser` (`oid`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppDetUsr_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKProcLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelXPDLAppTAAppDetUsr`
--

LOCK TABLES `SHKProcLevelXPDLAppTAAppDetUsr` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppDetUsr` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppDetUsr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelXPDLAppTAAppDetail`
--

DROP TABLE IF EXISTS `SHKProcLevelXPDLAppTAAppDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelXPDLAppTAAppDetail` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelXPDLAppTAAppDetail` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKProcLevelXPDLAppTAAppDetail_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppDetail_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppDetail` (`oid`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppDetail_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKProcLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelXPDLAppTAAppDetail`
--

LOCK TABLES `SHKProcLevelXPDLAppTAAppDetail` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppDetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelXPDLAppTAAppUser`
--

DROP TABLE IF EXISTS `SHKProcLevelXPDLAppTAAppUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelXPDLAppTAAppUser` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelXPDLAppTAAppUser` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKProcLevelXPDLAppTAAppUser_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppUser_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentAppUser` (`oid`),
  CONSTRAINT `SHKProcLevelXPDLAppTAAppUser_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKProcLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelXPDLAppTAAppUser`
--

LOCK TABLES `SHKProcLevelXPDLAppTAAppUser` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppTAAppUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcLevelXPDLAppToolAgntApp`
--

DROP TABLE IF EXISTS `SHKProcLevelXPDLAppToolAgntApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcLevelXPDLAppToolAgntApp` (
  `XPDL_APPOID` decimal(19,0) NOT NULL,
  `TOOLAGENTOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcLevelXPDLAppToolAgntApp` (`XPDL_APPOID`,`TOOLAGENTOID`),
  KEY `SHKProcLevelXPDLAppToolAgntApp_TOOLAGENTOID` (`TOOLAGENTOID`),
  CONSTRAINT `SHKProcLevelXPDLAppToolAgntApp_TOOLAGENTOID` FOREIGN KEY (`TOOLAGENTOID`) REFERENCES `SHKToolAgentApp` (`oid`),
  CONSTRAINT `SHKProcLevelXPDLAppToolAgntApp_XPDL_APPOID` FOREIGN KEY (`XPDL_APPOID`) REFERENCES `SHKProcLevelXPDLApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcLevelXPDLAppToolAgntApp`
--

LOCK TABLES `SHKProcLevelXPDLAppToolAgntApp` WRITE;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppToolAgntApp` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcLevelXPDLAppToolAgntApp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessData`
--

DROP TABLE IF EXISTS `SHKProcessData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessData` (
  `Process` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValue` mediumblob,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` double DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessData` (`CNT`),
  UNIQUE KEY `I2_SHKProcessData` (`Process`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKProcessData_Process` FOREIGN KEY (`Process`) REFERENCES `SHKProcesses` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessData`
--

LOCK TABLES `SHKProcessData` WRITE;
/*!40000 ALTER TABLE `SHKProcessData` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcessData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessDataBLOBs`
--

DROP TABLE IF EXISTS `SHKProcessDataBLOBs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessDataBLOBs` (
  `ProcessDataWOB` decimal(19,0) NOT NULL,
  `VariableValue` mediumblob,
  `OrdNo` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessDataBLOBs` (`ProcessDataWOB`,`OrdNo`),
  CONSTRAINT `SHKProcessDataBLOBs_ProcessDataWOB` FOREIGN KEY (`ProcessDataWOB`) REFERENCES `SHKProcessDataWOB` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessDataBLOBs`
--

LOCK TABLES `SHKProcessDataBLOBs` WRITE;
/*!40000 ALTER TABLE `SHKProcessDataBLOBs` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcessDataBLOBs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessDataWOB`
--

DROP TABLE IF EXISTS `SHKProcessDataWOB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessDataWOB` (
  `Process` decimal(19,0) NOT NULL,
  `VariableDefinitionId` varchar(100) NOT NULL,
  `VariableType` int(11) NOT NULL,
  `VariableValueXML` text,
  `VariableValueVCHAR` varchar(4000) DEFAULT NULL,
  `VariableValueDBL` double DEFAULT NULL,
  `VariableValueLONG` bigint(20) DEFAULT NULL,
  `VariableValueDATE` datetime DEFAULT NULL,
  `VariableValueBOOL` smallint(6) DEFAULT NULL,
  `OrdNo` int(11) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessDataWOB` (`CNT`),
  UNIQUE KEY `I2_SHKProcessDataWOB` (`Process`,`VariableDefinitionId`,`OrdNo`),
  CONSTRAINT `SHKProcessDataWOB_Process` FOREIGN KEY (`Process`) REFERENCES `SHKProcesses` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessDataWOB`
--

LOCK TABLES `SHKProcessDataWOB` WRITE;
/*!40000 ALTER TABLE `SHKProcessDataWOB` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcessDataWOB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessDefinitions`
--

DROP TABLE IF EXISTS `SHKProcessDefinitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessDefinitions` (
  `Name` varchar(200) NOT NULL,
  `PackageId` varchar(90) NOT NULL,
  `ProcessDefinitionId` varchar(90) NOT NULL,
  `ProcessDefinitionCreated` bigint(20) NOT NULL,
  `ProcessDefinitionVersion` varchar(20) NOT NULL,
  `State` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessDefinitions` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessDefinitions`
--

LOCK TABLES `SHKProcessDefinitions` WRITE;
/*!40000 ALTER TABLE `SHKProcessDefinitions` DISABLE KEYS */;
INSERT INTO `SHKProcessDefinitions` VALUES ('Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','Human_Resource_WF_01','Human_Resource_WF_01_wp1',1275891323501,'1',0,'1000017',0);
/*!40000 ALTER TABLE `SHKProcessDefinitions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessRequesters`
--

DROP TABLE IF EXISTS `SHKProcessRequesters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessRequesters` (
  `Id` varchar(100) NOT NULL,
  `ActivityRequester` decimal(19,0) DEFAULT NULL,
  `ResourceRequester` decimal(19,0) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessRequesters` (`Id`),
  KEY `I2_SHKProcessRequesters` (`ActivityRequester`),
  KEY `I3_SHKProcessRequesters` (`ResourceRequester`),
  CONSTRAINT `SHKProcessRequesters_ActivityRequester` FOREIGN KEY (`ActivityRequester`) REFERENCES `SHKActivities` (`oid`),
  CONSTRAINT `SHKProcessRequesters_ResourceRequester` FOREIGN KEY (`ResourceRequester`) REFERENCES `SHKResourcesTable` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessRequesters`
--

LOCK TABLES `SHKProcessRequesters` WRITE;
/*!40000 ALTER TABLE `SHKProcessRequesters` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcessRequesters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessStateEventAudits`
--

DROP TABLE IF EXISTS `SHKProcessStateEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessStateEventAudits` (
  `KeyValue` varchar(30) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessStateEventAudits` (`KeyValue`),
  UNIQUE KEY `I2_SHKProcessStateEventAudits` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessStateEventAudits`
--

LOCK TABLES `SHKProcessStateEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKProcessStateEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcessStateEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcessStates`
--

DROP TABLE IF EXISTS `SHKProcessStates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcessStates` (
  `KeyValue` varchar(30) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcessStates` (`KeyValue`),
  UNIQUE KEY `I2_SHKProcessStates` (`Name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcessStates`
--

LOCK TABLES `SHKProcessStates` WRITE;
/*!40000 ALTER TABLE `SHKProcessStates` DISABLE KEYS */;
INSERT INTO `SHKProcessStates` VALUES ('open.running','open.running','1000000',0),('open.not_running.not_started','open.not_running.not_started','1000002',0),('open.not_running.suspended','open.not_running.suspended','1000004',0),('closed.completed','closed.completed','1000006',0),('closed.terminated','closed.terminated','1000008',0),('closed.aborted','closed.aborted','1000010',0);
/*!40000 ALTER TABLE `SHKProcessStates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKProcesses`
--

DROP TABLE IF EXISTS `SHKProcesses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKProcesses` (
  `SyncVersion` bigint(20) NOT NULL,
  `Id` varchar(100) NOT NULL,
  `ProcessDefinition` decimal(19,0) NOT NULL,
  `PDefName` varchar(200) NOT NULL,
  `ActivityRequesterId` varchar(100) DEFAULT NULL,
  `ActivityRequesterProcessId` varchar(100) DEFAULT NULL,
  `ResourceRequesterId` varchar(100) NOT NULL,
  `ExternalRequesterClassName` varchar(254) DEFAULT NULL,
  `State` decimal(19,0) NOT NULL,
  `Priority` int(11) DEFAULT NULL,
  `Name` varchar(254) DEFAULT NULL,
  `Created` bigint(20) NOT NULL,
  `CreatedTZO` bigint(20) NOT NULL,
  `Started` bigint(20) DEFAULT NULL,
  `StartedTZO` bigint(20) DEFAULT NULL,
  `LastStateTime` bigint(20) NOT NULL,
  `LastStateTimeTZO` bigint(20) NOT NULL,
  `LimitTime` bigint(20) NOT NULL,
  `LimitTimeTZO` bigint(20) NOT NULL,
  `Description` varchar(254) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKProcesses` (`Id`),
  KEY `I2_SHKProcesses` (`ProcessDefinition`),
  KEY `I3_SHKProcesses` (`State`),
  KEY `I4_SHKProcesses` (`ActivityRequesterId`),
  KEY `I5_SHKProcesses` (`ResourceRequesterId`),
  CONSTRAINT `SHKProcesses_ProcessDefinition` FOREIGN KEY (`ProcessDefinition`) REFERENCES `SHKProcessDefinitions` (`oid`),
  CONSTRAINT `SHKProcesses_State` FOREIGN KEY (`State`) REFERENCES `SHKProcessStates` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKProcesses`
--

LOCK TABLES `SHKProcesses` WRITE;
/*!40000 ALTER TABLE `SHKProcesses` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKProcesses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKResourcesTable`
--

DROP TABLE IF EXISTS `SHKResourcesTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKResourcesTable` (
  `Username` varchar(100) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKResourcesTable` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKResourcesTable`
--

LOCK TABLES `SHKResourcesTable` WRITE;
/*!40000 ALTER TABLE `SHKResourcesTable` DISABLE KEYS */;
INSERT INTO `SHKResourcesTable` VALUES ('admin',NULL,'1000012',0);
/*!40000 ALTER TABLE `SHKResourcesTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKStateEventAudits`
--

DROP TABLE IF EXISTS `SHKStateEventAudits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKStateEventAudits` (
  `RecordedTime` bigint(20) NOT NULL,
  `RecordedTimeTZO` bigint(20) NOT NULL,
  `TheUsername` varchar(100) NOT NULL,
  `TheType` decimal(19,0) NOT NULL,
  `ActivityId` varchar(100) DEFAULT NULL,
  `ActivityName` varchar(254) DEFAULT NULL,
  `ProcessId` varchar(100) NOT NULL,
  `ProcessName` varchar(254) DEFAULT NULL,
  `ProcessFactoryName` varchar(200) NOT NULL,
  `ProcessFactoryVersion` varchar(20) NOT NULL,
  `ActivityDefinitionId` varchar(90) DEFAULT NULL,
  `ActivityDefinitionName` varchar(90) DEFAULT NULL,
  `ActivityDefinitionType` int(11) DEFAULT NULL,
  `ProcessDefinitionId` varchar(90) NOT NULL,
  `ProcessDefinitionName` varchar(90) DEFAULT NULL,
  `PackageId` varchar(90) NOT NULL,
  `OldProcessState` decimal(19,0) DEFAULT NULL,
  `NewProcessState` decimal(19,0) DEFAULT NULL,
  `OldActivityState` decimal(19,0) DEFAULT NULL,
  `NewActivityState` decimal(19,0) DEFAULT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKStateEventAudits` (`CNT`),
  KEY `SHKStateEventAudits_TheType` (`TheType`),
  KEY `SHKStateEventAudits_OldProcessState` (`OldProcessState`),
  KEY `SHKStateEventAudits_NewProcessState` (`NewProcessState`),
  KEY `SHKStateEventAudits_OldActivityState` (`OldActivityState`),
  KEY `SHKStateEventAudits_NewActivityState` (`NewActivityState`),
  CONSTRAINT `SHKStateEventAudits_NewActivityState` FOREIGN KEY (`NewActivityState`) REFERENCES `SHKActivityStateEventAudits` (`oid`),
  CONSTRAINT `SHKStateEventAudits_NewProcessState` FOREIGN KEY (`NewProcessState`) REFERENCES `SHKProcessStateEventAudits` (`oid`),
  CONSTRAINT `SHKStateEventAudits_OldActivityState` FOREIGN KEY (`OldActivityState`) REFERENCES `SHKActivityStateEventAudits` (`oid`),
  CONSTRAINT `SHKStateEventAudits_OldProcessState` FOREIGN KEY (`OldProcessState`) REFERENCES `SHKProcessStateEventAudits` (`oid`),
  CONSTRAINT `SHKStateEventAudits_TheType` FOREIGN KEY (`TheType`) REFERENCES `SHKEventTypes` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKStateEventAudits`
--

LOCK TABLES `SHKStateEventAudits` WRITE;
/*!40000 ALTER TABLE `SHKStateEventAudits` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKStateEventAudits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKToolAgentApp`
--

DROP TABLE IF EXISTS `SHKToolAgentApp`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKToolAgentApp` (
  `TOOL_AGENT_NAME` varchar(250) NOT NULL,
  `APP_NAME` varchar(90) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKToolAgentApp` (`TOOL_AGENT_NAME`,`APP_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKToolAgentApp`
--

LOCK TABLES `SHKToolAgentApp` WRITE;
/*!40000 ALTER TABLE `SHKToolAgentApp` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKToolAgentApp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKToolAgentAppDetail`
--

DROP TABLE IF EXISTS `SHKToolAgentAppDetail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKToolAgentAppDetail` (
  `APP_MODE` decimal(10,0) NOT NULL,
  `TOOLAGENT_APPOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKToolAgentAppDetail` (`APP_MODE`,`TOOLAGENT_APPOID`),
  KEY `SHKToolAgentAppDetail_TOOLAGENT_APPOID` (`TOOLAGENT_APPOID`),
  CONSTRAINT `SHKToolAgentAppDetail_TOOLAGENT_APPOID` FOREIGN KEY (`TOOLAGENT_APPOID`) REFERENCES `SHKToolAgentApp` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKToolAgentAppDetail`
--

LOCK TABLES `SHKToolAgentAppDetail` WRITE;
/*!40000 ALTER TABLE `SHKToolAgentAppDetail` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKToolAgentAppDetail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKToolAgentAppDetailUser`
--

DROP TABLE IF EXISTS `SHKToolAgentAppDetailUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKToolAgentAppDetailUser` (
  `TOOLAGENT_APPOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKToolAgentAppDetailUser` (`TOOLAGENT_APPOID`,`USEROID`),
  KEY `SHKToolAgentAppDetailUser_USEROID` (`USEROID`),
  CONSTRAINT `SHKToolAgentAppDetailUser_TOOLAGENT_APPOID` FOREIGN KEY (`TOOLAGENT_APPOID`) REFERENCES `SHKToolAgentAppDetail` (`oid`),
  CONSTRAINT `SHKToolAgentAppDetailUser_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKToolAgentUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKToolAgentAppDetailUser`
--

LOCK TABLES `SHKToolAgentAppDetailUser` WRITE;
/*!40000 ALTER TABLE `SHKToolAgentAppDetailUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKToolAgentAppDetailUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKToolAgentAppUser`
--

DROP TABLE IF EXISTS `SHKToolAgentAppUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKToolAgentAppUser` (
  `TOOLAGENT_APPOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKToolAgentAppUser` (`TOOLAGENT_APPOID`,`USEROID`),
  KEY `SHKToolAgentAppUser_USEROID` (`USEROID`),
  CONSTRAINT `SHKToolAgentAppUser_TOOLAGENT_APPOID` FOREIGN KEY (`TOOLAGENT_APPOID`) REFERENCES `SHKToolAgentApp` (`oid`),
  CONSTRAINT `SHKToolAgentAppUser_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKToolAgentUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKToolAgentAppUser`
--

LOCK TABLES `SHKToolAgentAppUser` WRITE;
/*!40000 ALTER TABLE `SHKToolAgentAppUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKToolAgentAppUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKToolAgentUser`
--

DROP TABLE IF EXISTS `SHKToolAgentUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKToolAgentUser` (
  `USERNAME` varchar(100) NOT NULL,
  `PWD` varchar(100) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKToolAgentUser` (`USERNAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKToolAgentUser`
--

LOCK TABLES `SHKToolAgentUser` WRITE;
/*!40000 ALTER TABLE `SHKToolAgentUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKToolAgentUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKUserGroupTable`
--

DROP TABLE IF EXISTS `SHKUserGroupTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKUserGroupTable` (
  `userid` decimal(19,0) NOT NULL,
  `groupid` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKUserGroupTable` (`userid`,`groupid`),
  KEY `SHKUserGroupTable_groupid` (`groupid`),
  CONSTRAINT `SHKUserGroupTable_groupid` FOREIGN KEY (`groupid`) REFERENCES `SHKGroupTable` (`oid`),
  CONSTRAINT `SHKUserGroupTable_userid` FOREIGN KEY (`userid`) REFERENCES `SHKUserTable` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKUserGroupTable`
--

LOCK TABLES `SHKUserGroupTable` WRITE;
/*!40000 ALTER TABLE `SHKUserGroupTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKUserGroupTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKUserPackLevelPart`
--

DROP TABLE IF EXISTS `SHKUserPackLevelPart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKUserPackLevelPart` (
  `PARTICIPANTOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKUserPackLevelPart` (`PARTICIPANTOID`,`USEROID`),
  KEY `SHKUserPackLevelPart_USEROID` (`USEROID`),
  CONSTRAINT `SHKUserPackLevelPart_PARTICIPANTOID` FOREIGN KEY (`PARTICIPANTOID`) REFERENCES `SHKPackLevelParticipant` (`oid`),
  CONSTRAINT `SHKUserPackLevelPart_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKNormalUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKUserPackLevelPart`
--

LOCK TABLES `SHKUserPackLevelPart` WRITE;
/*!40000 ALTER TABLE `SHKUserPackLevelPart` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKUserPackLevelPart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKUserProcLevelParticipant`
--

DROP TABLE IF EXISTS `SHKUserProcLevelParticipant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKUserProcLevelParticipant` (
  `PARTICIPANTOID` decimal(19,0) NOT NULL,
  `USEROID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKUserProcLevelParticipant` (`PARTICIPANTOID`,`USEROID`),
  KEY `SHKUserProcLevelParticipant_USEROID` (`USEROID`),
  CONSTRAINT `SHKUserProcLevelParticipant_PARTICIPANTOID` FOREIGN KEY (`PARTICIPANTOID`) REFERENCES `SHKProcLevelParticipant` (`oid`),
  CONSTRAINT `SHKUserProcLevelParticipant_USEROID` FOREIGN KEY (`USEROID`) REFERENCES `SHKNormalUser` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKUserProcLevelParticipant`
--

LOCK TABLES `SHKUserProcLevelParticipant` WRITE;
/*!40000 ALTER TABLE `SHKUserProcLevelParticipant` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKUserProcLevelParticipant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKUserTable`
--

DROP TABLE IF EXISTS `SHKUserTable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKUserTable` (
  `userid` varchar(100) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `passwd` varchar(50) NOT NULL,
  `email` varchar(254) DEFAULT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKUserTable` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKUserTable`
--

LOCK TABLES `SHKUserTable` WRITE;
/*!40000 ALTER TABLE `SHKUserTable` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKUserTable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLApplicationPackage`
--

DROP TABLE IF EXISTS `SHKXPDLApplicationPackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLApplicationPackage` (
  `PACKAGE_ID` varchar(90) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLApplicationPackage` (`PACKAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLApplicationPackage`
--

LOCK TABLES `SHKXPDLApplicationPackage` WRITE;
/*!40000 ALTER TABLE `SHKXPDLApplicationPackage` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLApplicationPackage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLApplicationProcess`
--

DROP TABLE IF EXISTS `SHKXPDLApplicationProcess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLApplicationProcess` (
  `PROCESS_ID` varchar(90) NOT NULL,
  `PACKAGEOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLApplicationProcess` (`PROCESS_ID`,`PACKAGEOID`),
  KEY `SHKXPDLApplicationProcess_PACKAGEOID` (`PACKAGEOID`),
  CONSTRAINT `SHKXPDLApplicationProcess_PACKAGEOID` FOREIGN KEY (`PACKAGEOID`) REFERENCES `SHKXPDLApplicationPackage` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLApplicationProcess`
--

LOCK TABLES `SHKXPDLApplicationProcess` WRITE;
/*!40000 ALTER TABLE `SHKXPDLApplicationProcess` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLApplicationProcess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLData`
--

DROP TABLE IF EXISTS `SHKXPDLData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLData` (
  `XPDLContent` mediumblob NOT NULL,
  `XPDLClassContent` mediumblob NOT NULL,
  `XPDL` decimal(19,0) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLData` (`CNT`),
  UNIQUE KEY `I2_SHKXPDLData` (`XPDL`),
  CONSTRAINT `SHKXPDLData_XPDL` FOREIGN KEY (`XPDL`) REFERENCES `SHKXPDLS` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLData`
--

LOCK TABLES `SHKXPDLData` WRITE;
/*!40000 ALTER TABLE `SHKXPDLData` DISABLE KEYS */;
INSERT INTO `SHKXPDLData` VALUES ('<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<Package xmlns=\"http://www.wfmc.org/2002/XPDL1.0\" xmlns:xpdl=\"http://www.wfmc.org/2002/XPDL1.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Id=\"Human_Resource_WF_01\" Name=\"Human Resource Workflow 01\" xsi:schemaLocation=\"http://www.wfmc.org/2002/XPDL1.0 http://wfmc.org/standards/docs/TC-1025_schema_10_xpdl.xsd\">\n    <PackageHeader>\n        <XPDLVersion>1.0</XPDLVersion>\n        <Vendor>Together</Vendor>\n        <Created>2010-04-13 15:24:09</Created>\n    </PackageHeader>\n    <Script Type=\"text/javascript\"/>\n    <Participants>\n        <Participant Id=\"Human_Resource_WF_01_par1\" Name=\"Requestor\">\n            <ParticipantType Type=\"ROLE\"/>\n        </Participant>\n        <Participant Id=\"Human_Resource_WF_01_par2\" Name=\"Head of Department\">\n            <ParticipantType Type=\"ROLE\"/>\n        </Participant>\n        <Participant Id=\"Human_Resource_WF_01_par3\" Name=\"HR &amp; Admin\">\n            <ParticipantType Type=\"ROLE\"/>\n        </Participant>\n        <Participant Id=\"Human_Resource_WF_01_par4\" Name=\"System\">\n            <ParticipantType Type=\"SYSTEM\"/>\n        </Participant>\n    </Participants>\n    <Applications>\n        <Application Id=\"default_application\"/>\n    </Applications>\n    <WorkflowProcesses>\n        <WorkflowProcess Id=\"Human_Resource_WF_01_wp1\" Name=\"Travel Request\">\n            <ProcessHeader>\n                <Created>2010-04-13 15:25:48</Created>\n            </ProcessHeader>\n            <DataFields>\n                <DataField Id=\"hod_action\" IsArray=\"FALSE\">\n                    <DataType>\n                        <BasicType Type=\"STRING\"/>\n                    </DataType>\n                </DataField>\n            </DataFields>\n            <Activities>\n                <Activity Id=\"wp1_act1\" Name=\"Raise Travel Requisition\">\n                    <Implementation>\n                        <No/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par1</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par1\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"301,49\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_VIEW\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"wp1_act2\" Name=\"Approve Travel Request for #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#\">\n                    <Implementation>\n                        <No/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par2</Performer>\n                    <TransitionRestrictions>\n                        <TransitionRestriction>\n                            <Join Type=\"XOR\"/>\n                        </TransitionRestriction>\n                    </TransitionRestrictions>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par2\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"415,47\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_UPDATE\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"wp1_act3\" Name=\"Travel Request: Arrangements for #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#\">\n                    <Implementation>\n                        <No/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par3</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par3\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"702,49\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_VIEW\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"wp1_act4\" Name=\"Resubmit Travel Request\">\n                    <Implementation>\n                        <No/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par1</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par1\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"564,49\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_VIEW\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act5\" Name=\"Generate Travel Request ID\">\n                    <Implementation>\n                        <Tool Id=\"default_application\"/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par4</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par4\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"130,51\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act6\" Name=\"Route\">\n                    <Route/>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par1\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"143,50\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_VIEW\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act7\" Name=\"Route\">\n                    <Route/>\n                    <TransitionRestrictions>\n                        <TransitionRestriction>\n                            <Split Type=\"XOR\">\n                                <TransitionRefs>\n                                    <TransitionRef Id=\"Human_Resource_WF_01_wp1_tra7\"/>\n                                    <TransitionRef Id=\"Human_Resource_WF_01_wp1_tra5\"/>\n                                    <TransitionRef Id=\"Human_Resource_WF_01_wp1_tra9\"/>\n                                </TransitionRefs>\n                            </Split>\n                        </TransitionRestriction>\n                    </TransitionRestrictions>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par2\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"574,52\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act8\" Name=\"Email: Notify Requestor of Approval\">\n                    <Implementation>\n                        <Tool Id=\"default_application\"/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par4</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par4\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"699,55\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act9\" Name=\"Email: Notify Requestor of Rejection\">\n                    <Implementation>\n                        <Tool Id=\"default_application\"/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par4</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par4\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"704,154\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"wp1_act10\" Name=\"Travel Request Approved by #performer.wp1_act2.firstName# #performer.wp1_act2.lastName#\">\n                    <Implementation>\n                        <No/>\n                    </Implementation>\n                    <Performer>Human_Resource_WF_01_par1</Performer>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par1\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"886,49\"/>\n                        <ExtendedAttribute Name=\"VariableToProcess_VIEW\" Value=\"hod_action\"/>\n                    </ExtendedAttributes>\n                </Activity>\n                <Activity Id=\"Human_Resource_WF_01_wp1_act11\" Name=\"Route\">\n                    <Route/>\n                    <TransitionRestrictions>\n                        <TransitionRestriction>\n                            <Split Type=\"AND\">\n                                <TransitionRefs>\n                                    <TransitionRef Id=\"Human_Resource_WF_01_wp1_tra10\"/>\n                                    <TransitionRef Id=\"Human_Resource_WF_01_wp1_tra11\"/>\n                                </TransitionRefs>\n                            </Split>\n                        </TransitionRestriction>\n                    </TransitionRestrictions>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_PARTICIPANT_ID\" Value=\"Human_Resource_WF_01_par3\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_OFFSET\" Value=\"714,144\"/>\n                    </ExtendedAttributes>\n                </Activity>\n            </Activities>\n            <Transitions>\n                <Transition From=\"Human_Resource_WF_01_wp1_act5\" Id=\"Human_Resource_WF_01_wp1_tra1\" To=\"wp1_act1\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"266,590-266,79\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act6\" Id=\"Human_Resource_WF_01_wp1_tra2\" To=\"Human_Resource_WF_01_wp1_act5\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_SPLINE\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"wp1_act1\" Id=\"Human_Resource_WF_01_wp1_tra3\" To=\"wp1_act2\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"353,227\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"wp1_act2\" Id=\"Human_Resource_WF_01_wp1_tra4\" To=\"Human_Resource_WF_01_wp1_act7\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_SPLINE\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act7\" Id=\"Human_Resource_WF_01_wp1_tra5\" To=\"wp1_act4\">\n                    <Condition Type=\"CONDITION\">hod_action==\'Resubmit\'</Condition>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_SPLINE\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"wp1_act4\" Id=\"Human_Resource_WF_01_wp1_tra6\" To=\"wp1_act2\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"463,78\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act7\" Id=\"Human_Resource_WF_01_wp1_tra7\" To=\"wp1_act3\">\n                    <Condition Type=\"CONDITION\">hod_action==\'Approved\'</Condition>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"753,229\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"wp1_act3\" Id=\"Human_Resource_WF_01_wp1_tra8\" To=\"Human_Resource_WF_01_wp1_act11\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_SPLINE\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act7\" Id=\"Human_Resource_WF_01_wp1_tra9\" To=\"Human_Resource_WF_01_wp1_act9\">\n                    <Condition Type=\"OTHERWISE\"/>\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"613,687\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act11\" Id=\"Human_Resource_WF_01_wp1_tra10\" To=\"Human_Resource_WF_01_wp1_act8\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_SPLINE\"/>\n                    </ExtendedAttributes>\n                </Transition>\n                <Transition From=\"Human_Resource_WF_01_wp1_act11\" Id=\"Human_Resource_WF_01_wp1_tra11\" To=\"wp1_act10\">\n                    <ExtendedAttributes>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_BREAK_POINTS\" Value=\"938,473\"/>\n                        <ExtendedAttribute Name=\"JaWE_GRAPH_TRANSITION_STYLE\" Value=\"NO_ROUTING_ORTHOGONAL\"/>\n                    </ExtendedAttributes>\n                </Transition>\n            </Transitions>\n            <ExtendedAttributes>\n                <ExtendedAttribute Name=\"JaWE_GRAPH_WORKFLOW_PARTICIPANT_ORDER\" Value=\"Human_Resource_WF_01_par1;Human_Resource_WF_01_par2;Human_Resource_WF_01_par3;Human_Resource_WF_01_par4\"/>\n                <ExtendedAttribute Name=\"JaWE_GRAPH_START_OF_WORKFLOW\" Value=\"JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par1,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act6,X_OFFSET=51,Y_OFFSET=59,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=START_DEFAULT\"/>\n                <ExtendedAttribute Name=\"JaWE_GRAPH_END_OF_WORKFLOW\" Value=\"JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par4,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act9,X_OFFSET=894,Y_OFFSET=167,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULT\"/>\n                <ExtendedAttribute Name=\"JaWE_GRAPH_END_OF_WORKFLOW\" Value=\"JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par1,CONNECTING_ACTIVITY_ID=wp1_act10,X_OFFSET=1076,Y_OFFSET=62,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULT\"/>\n                <ExtendedAttribute Name=\"JaWE_GRAPH_END_OF_WORKFLOW\" Value=\"JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par4,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act8,X_OFFSET=889,Y_OFFSET=68,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULT\"/>\n            </ExtendedAttributes>\n        </WorkflowProcess>\n    </WorkflowProcesses>\n    <ExtendedAttributes>\n        <ExtendedAttribute Name=\"EDITING_TOOL\" Value=\"Workflow Designer\"/>\n        <ExtendedAttribute Name=\"EDITING_TOOL_VERSION\" Value=\"2.0-2(4?)-C-20080226-2126\"/>\n        <ExtendedAttribute Name=\"JaWE_CONFIGURATION\" Value=\"default\"/>\n    </ExtendedAttributes>\n</Package>\n','¨Ì\0sr\0\'org.enhydra.shark.xpdl.elements.Package~+Vm≈Ä~˜\0Z\0isTransientL\0extPkgRefsToIdst\0.Lorg/enhydra/shark/utilities/SequencedHashMap;L\0internalVersiont\0Ljava/lang/String;L\0\nnamespacest\0,Lorg/enhydra/shark/xpdl/elements/Namespaces;xr\0(org.enhydra.shark.xpdl.XMLComplexElement>≤æΩÓ(⁄Ã\0\0xr\05org.enhydra.shark.xpdl.XMLBaseForCollectionAndComplexÂ‡áÓ·ı2\0L\0\nelementMapq\0~\0L\0elementst\0Ljava/util/ArrayList;xr\0!org.enhydra.shark.xpdl.XMLElement#+Bø#˜åº\0Z\0\nisReadOnlyZ\0\nisRequiredL\0nameq\0~\0L\0originalElementHashCodet\0Ljava/lang/Integer;L\0parentt\0#Lorg/enhydra/shark/xpdl/XMLElement;L\0valueq\0~\0xpt\0Packagesr\0java.lang.Integer‚†§˜Åá8\0I\0valuexr\0java.lang.NumberÜ¨ïî‡ã\0\0xp\0Ñ-«pt\0\0sr\0,org.enhydra.shark.utilities.SequencedHashMap.Í\"ì©\"&\0\0xpw\0\0\0\rt\0Idsr\0#org.enhydra.shark.xpdl.XMLAttribute#c›Ä˛ÀM;\0L\0choicesq\0~\0xq\0~\0q\0~\0sq\0~\0ŸuÖq\0~\0\nt\0Human_Resource_WF_01pt\0Namesq\0~\0\0q\0~\0sq\0~\0≤xÒq\0~\0\nt\0\ZHuman Resource Workflow 01pt\0\rPackageHeadersr\0-org.enhydra.shark.xpdl.elements.PackageHeadervÈí,ÌíÔ\0\0xq\0~\0\0q\0~\0sq\0~\07˝Ìq\0~\0\nt\0\0sq\0~\0w\0\0\0t\0XPDLVersionsr\0+org.enhydra.shark.xpdl.elements.XPDLVersion˜\"}◊Y.≈w\0\0xr\0\'org.enhydra.shark.xpdl.XMLSimpleElement¬m›¿éÛ\0\0xq\0~\0q\0~\0!sq\0~\0\0åq\0~\0t\01.0t\0Vendorsr\0&org.enhydra.shark.xpdl.elements.Vendor t¯ÍE≥:\0\0xq\0~\0#q\0~\0\'sq\0~\0\0Ô~˛q\0~\0t\0Togethert\0Createdsr\0\'org.enhydra.shark.xpdl.elements.Createdz ÙdKª|[\0\0xq\0~\0#q\0~\0,sq\0~\0\0ˇ\"Ìq\0~\0t\02010-04-13 15:24:09t\0Descriptionsr\0+org.enhydra.shark.xpdl.elements.Description€∞73Ê8˚\0\0xq\0~\0#\0q\0~\01sq\0~\0\0N3™q\0~\0t\0\0t\0\rDocumentationsr\0-org.enhydra.shark.xpdl.elements.Documentation`ƒ9ª◊yí\0\0xq\0~\0#\0q\0~\06sq\0~\0\0!˘¿q\0~\0t\0\0t\0PriorityUnitsr\0,org.enhydra.shark.xpdl.elements.PriorityUnitò≥õËõ¯‰Â\0\0xq\0~\0#\0q\0~\0;sq\0~\0\0ì—?q\0~\0t\0\0t\0CostUnitsr\0(org.enhydra.shark.xpdl.elements.CostUnit‹éŸ=H·å\0\0xq\0~\0#\0q\0~\0@sq\0~\0\0éñ¸q\0~\0t\0\0xsr\0java.util.ArrayListxÅ“ô«aù\0I\0sizexp\0\0\0w\0\0\0\nq\0~\0$q\0~\0)q\0~\0.q\0~\03q\0~\08q\0~\0=q\0~\0Bxt\0RedefinableHeadersr\01org.enhydra.shark.xpdl.elements.RedefinableHeaderôøMÎœ™\'H\0\0xq\0~\0\0q\0~\0Gsq\0~\05r∑q\0~\0\nt\0\0sq\0~\0w\0\0\0t\0PublicationStatussq\0~\0\0q\0~\0Msq\0~\0˛|/q\0~\0It\0\0sq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0UNDER_REVISIONt\0RELEASEDt\0\nUNDER_TESTxt\0Authorsr\0&org.enhydra.shark.xpdl.elements.Author5 ƒf·ßÜ\0\0xq\0~\0#\0q\0~\0Usq\0~\0\0ã\"Âq\0~\0It\0\0t\0Versionsr\0\'org.enhydra.shark.xpdl.elements.Version9=3¥~ªJQ\0\0xq\0~\0#\0q\0~\0Zsq\0~\0\0†pq\0~\0It\0\0t\0Codepagesr\0(org.enhydra.shark.xpdl.elements.Codepage9$m˜eΩ\rG\0\0xq\0~\0#\0q\0~\0_sq\0~\0\0Htqq\0~\0It\0\0t\0\nCountrykeysr\0*org.enhydra.shark.xpdl.elements.Countrykeyóã.Å–“—\0\0xq\0~\0#\0q\0~\0dsq\0~\0\0‘™ˆq\0~\0It\0\0t\0Responsiblessr\0,org.enhydra.shark.xpdl.elements.Responsibles$ÔÍ{S∆\0\0xr\0$org.enhydra.shark.xpdl.XMLCollectionËèjƒãmÌ∞\0\0xq\0~\0\0q\0~\0isq\0~\0	Úãq\0~\0It\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0Nq\0~\0Wq\0~\0\\q\0~\0aq\0~\0fq\0~\0lxt\0ConformanceClasssr\00org.enhydra.shark.xpdl.elements.ConformanceClass◊Ïy0|k´î\0\0xq\0~\0\0q\0~\0rsq\0~\0\0ù⁄q\0~\0\nt\0\0sq\0~\0w\0\0\0t\0GraphConformancesq\0~\0\0q\0~\0xsq\0~\0\09}Nq\0~\0tq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0FULL_BLOCKEDt\0LOOP_BLOCKEDt\0NON_BLOCKEDxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0yxt\0Scriptsr\0&org.enhydra.shark.xpdl.elements.ScriptQ¶jÁS„8\0\0xq\0~\0\0q\0~\0Äsq\0~\0\0QÆ‡q\0~\0\nt\0\0sq\0~\0w\0\0\0t\0Typesq\0~\0q\0~\0Üsq\0~\0\0∞üq\0~\0Çt\0text/javascriptpt\0Versionsq\0~\0\0q\0~\0äsq\0~\0:£jq\0~\0Çt\0\0pt\0Grammarsq\0~\0\0q\0~\0ésq\0~\0\0æ√Zq\0~\0Çt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0áq\0~\0ãq\0~\0èxt\0ExternalPackagessr\00org.enhydra.shark.xpdl.elements.ExternalPackagesw¿\"+≈®®â\0\0xq\0~\0k\0q\0~\0ìsq\0~\0\0bãßq\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0TypeDeclarationssr\00org.enhydra.shark.xpdl.elements.TypeDeclarations\r· Ox5Õ\0\0xq\0~\0k\0q\0~\0ösq\0~\0à≈¬q\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0Participantssr\0,org.enhydra.shark.xpdl.elements.Participantsh`∑g8J\0\0xq\0~\0k\0q\0~\0°sq\0~\0\0¸∆Ëq\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0+org.enhydra.shark.xpdl.elements.Participanto$îÛrc§è\0\0xr\0+org.enhydra.shark.xpdl.XMLCollectionElementC¢x”vÅr\0\0xq\0~\0t\0Participantsq\0~\0\0¶4\\q\0~\0£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0“¨Øq\0~\0™t\0Human_Resource_WF_01_par1pq\0~\0sq\0~\0\0q\0~\0sq\0~\0∑∑£q\0~\0™t\0	Requestorpt\0ParticipantTypesr\0/org.enhydra.shark.xpdl.elements.ParticipantType>àn•›Ö®˜\0\0xq\0~\0q\0~\0µsq\0~\0\0y]_q\0~\0™t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0q\0~\0Üsq\0~\0·F q\0~\0∑t\0ROLEsq\0~\0E\0\0\0w\0\0\0t\0RESOURCE_SETt\0RESOURCEt\0ROLEt\0ORGANIZATIONAL_UNITt\0HUMANt\0SYSTEMxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0ªxt\0Descriptionsq\0~\02\0q\0~\0∆sq\0~\0\0Óìhq\0~\0™t\0\0t\0ExternalReferencesr\01org.enhydra.shark.xpdl.elements.ExternalReferenceÜbË∑¡Qœ\0\0xq\0~\0\0q\0~\0 sq\0~\0æuq\0~\0™t\0\0sq\0~\0w\0\0\0t\0xrefsq\0~\0\0q\0~\0–sq\0~\0\0†ˇ\'q\0~\0Ãt\0\0pt\0locationsq\0~\0q\0~\0‘sq\0~\0œ^‰q\0~\0Ãt\0\0pt\0	namespacesq\0~\0\0q\0~\0ÿsq\0~\0^Û´q\0~\0Ãt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0—q\0~\0’q\0~\0Ÿxt\0ExtendedAttributessr\02org.enhydra.shark.xpdl.elements.ExtendedAttributesÚ∞Oıü⁄UF\0L\0extAttribsStringq\0~\0xq\0~\0k\0q\0~\0›sq\0~\0\0œ{Ûq\0~\0™t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0Øq\0~\0≤q\0~\0∑q\0~\0«q\0~\0Ãq\0~\0ﬂxsq\0~\0®t\0Participantsq\0~\0\0G9q\0~\0£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\01,Pq\0~\0Ât\0Human_Resource_WF_01_par2pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0LUˇq\0~\0Ât\0Head of Departmentpt\0ParticipantTypesq\0~\0∂q\0~\0sq\0~\0°Ìq\0~\0Ât\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0q\0~\0Üsq\0~\0œ∑˝q\0~\0Òt\0ROLEsq\0~\0E\0\0\0w\0\0\0q\0~\0øq\0~\0¿q\0~\0¡q\0~\0¬q\0~\0√q\0~\0ƒxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0ıxt\0Descriptionsq\0~\02\0q\0~\0˙sq\0~\0\08M4q\0~\0Ât\0\0t\0ExternalReferencesq\0~\0À\0q\0~\0˛sq\0~\0\0T¶ìq\0~\0Ât\0\0sq\0~\0w\0\0\0q\0~\0–sq\0~\0\0q\0~\0–sq\0~\0Ñ),q\0~\0ˇt\0\0pq\0~\0‘sq\0~\0q\0~\0‘sq\0~\0´0|q\0~\0ˇt\0\0pq\0~\0ÿsq\0~\0\0q\0~\0ÿsq\0~\0¸U$q\0~\0ˇt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~	xt\0ExtendedAttributessq\0~\0ﬁ\0q\0~\rsq\0~\09ØÄq\0~\0Ât\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\0Íq\0~\0Ìq\0~\0Òq\0~\0˚q\0~\0ˇq\0~xsq\0~\0®t\0Participantsq\0~\0\0Ttœq\0~\0£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0µ—q\0~t\0Human_Resource_WF_01_par3pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0¿Õ}q\0~t\0\nHR & Adminpt\0ParticipantTypesq\0~\0∂q\0~sq\0~\0Ú Ùq\0~t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0q\0~\0Üsq\0~\0\0Íy¯q\0~ t\0ROLEsq\0~\0E\0\0\0w\0\0\0q\0~\0øq\0~\0¿q\0~\0¡q\0~\0¬q\0~\0√q\0~\0ƒxxsq\0~\0E\0\0\0w\0\0\0\nq\0~$xt\0Descriptionsq\0~\02\0q\0~)sq\0~\0Ì∏pq\0~t\0\0t\0ExternalReferencesq\0~\0À\0q\0~-sq\0~\0Á‘Ñq\0~t\0\0sq\0~\0w\0\0\0q\0~\0–sq\0~\0\0q\0~\0–sq\0~\013eq\0~.t\0\0pq\0~\0‘sq\0~\0q\0~\0‘sq\0~\0%NYq\0~.t\0\0pq\0~\0ÿsq\0~\0\0q\0~\0ÿsq\0~\0\0:ﬂ¥q\0~.t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~2q\0~5q\0~8xt\0ExtendedAttributessq\0~\0ﬁ\0q\0~<sq\0~\04æ<q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~ q\0~*q\0~.q\0~=xsq\0~\0®t\0Participantsq\0~\0\0⁄à¬q\0~\0£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0a.Sq\0~Ct\0Human_Resource_WF_01_par4pq\0~\0sq\0~\0\0q\0~\0sq\0~\0HÖMq\0~Ct\0Systempt\0ParticipantTypesq\0~\0∂q\0~Nsq\0~\0\0\'úàq\0~Ct\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0q\0~\0Üsq\0~\0\0ï’q\0~Ot\0SYSTEMsq\0~\0E\0\0\0w\0\0\0q\0~\0øq\0~\0¿q\0~\0¡q\0~\0¬q\0~\0√q\0~\0ƒxxsq\0~\0E\0\0\0w\0\0\0\nq\0~Sxt\0Descriptionsq\0~\02\0q\0~Xsq\0~\0\0”µ.q\0~Ct\0\0t\0ExternalReferencesq\0~\0À\0q\0~\\sq\0~\0‡uq\0~Ct\0\0sq\0~\0w\0\0\0q\0~\0–sq\0~\0\0q\0~\0–sq\0~\0-.3q\0~]t\0\0pq\0~\0‘sq\0~\0q\0~\0‘sq\0~\04R^q\0~]t\0\0pq\0~\0ÿsq\0~\0\0q\0~\0ÿsq\0~\0\0œGq\0~]t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~aq\0~dq\0~gxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~ksq\0~\0Utµq\0~Ct\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Hq\0~Kq\0~Oq\0~Yq\0~]q\0~lxxt\0Applicationssr\0,org.enhydra.shark.xpdl.elements.Applications¬Ä¥ﬁˆº\0\0xq\0~\0k\0q\0~rsq\0~\0¨ø\\q\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0+org.enhydra.shark.xpdl.elements.Applicationv	¢R˘˛S\0\0xq\0~\0©t\0Applicationsq\0~\0’Êq\0~tt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0büCq\0~zt\0default_applicationpq\0~\0sq\0~\0\0q\0~\0sq\0~\0/≤Lq\0~zt\0\0pt\0Descriptionsq\0~\02\0q\0~Ösq\0~\0\0∫™∫q\0~zt\0\0t\0Choicesr\00org.enhydra.shark.xpdl.elements.ApplicationTypesè?˚!≠Æ¶\0\0xr\0\'org.enhydra.shark.xpdl.XMLComplexChoice§|±∫\"Ù˙\0L\0choicesq\0~\0L\0choosenq\0~\0	xq\0~\0q\0~âsq\0~\0«ﬂq\0~zt\0\0sq\0~\0E\0\0\0w\0\0\0\nsr\00org.enhydra.shark.xpdl.elements.FormalParametersp∫ƒB«√ÅZ\0\0xq\0~\0k\0t\0FormalParameterssq\0~\0‘Nq\0~åt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0À\0t\0ExternalReferencesq\0~\0\0s·\Zq\0~åt\0\0sq\0~\0w\0\0\0q\0~\0–sq\0~\0\0q\0~\0–sq\0~\0ø§uq\0~ót\0\0pq\0~\0‘sq\0~\0q\0~\0‘sq\0~\0\0∆Øq\0~ót\0\0pq\0~\0ÿsq\0~\0\0q\0~\0ÿsq\0~\0qv|q\0~ót\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~úq\0~üq\0~¢xxq\0~ët\0ExtendedAttributessq\0~\0ﬁ\0q\0~¶sq\0~\0\0È{q\0~zt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~Çq\0~Üq\0~åq\0~ßxxt\0\nDataFieldssr\0*org.enhydra.shark.xpdl.elements.DataFieldsΩµí ¶‘˙U\0\0xq\0~\0k\0q\0~≠sq\0~\0\0G:q\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0WorkflowProcessessr\01org.enhydra.shark.xpdl.elements.WorkflowProcessespé_¢0,\0\0xq\0~\0k\0q\0~¥sq\0~\0\06*{q\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0/org.enhydra.shark.xpdl.elements.WorkflowProcess%·v0“◊L\0\0xq\0~\0©t\0WorkflowProcesssq\0~\0)eq\0~∂t\0\0sq\0~\0w\0\0\0\rq\0~\0sq\0~\0q\0~\0sq\0~\0e)¯q\0~ºt\0Human_Resource_WF_01_wp1pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0®√q\0~ºt\0Travel Requestpt\0AccessLevelsq\0~\0\0q\0~«sq\0~\0°?≥q\0~ºq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0PUBLICt\0PRIVATExt\0\rProcessHeadersr\0-org.enhydra.shark.xpdl.elements.ProcessHeaderåLÆÉC-)ø\0\0xq\0~\0q\0~Õsq\0~\0]˜q\0~ºt\0\0sq\0~\0w\0\0\0t\0DurationUnitsq\0~\0\0q\0~”sq\0~\0\0√D¥q\0~œq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0Yt\0Mt\0Dt\0ht\0mt\0sxt\0Createdsq\0~\0-\0q\0~›sq\0~\0”∑\rq\0~œt\02010-04-13 15:25:48t\0Descriptionsq\0~\02\0q\0~·sq\0~\0\0ñ—q\0~œt\0\0t\0Prioritysr\0(org.enhydra.shark.xpdl.elements.Priority`ˆNn>b\0\0xq\0~\0#\0q\0~Âsq\0~\0wyÚq\0~œt\0\0t\0Limitsr\0%org.enhydra.shark.xpdl.elements.Limit¸¢Ë1ò”ó\0\0xq\0~\0#\0q\0~Ísq\0~\0\0Á\r˚q\0~œt\0\0t\0	ValidFromsr\0)org.enhydra.shark.xpdl.elements.ValidFromc≈Ö|ÉL<\0\0xq\0~\0#\0q\0~Ôsq\0~\0F·aq\0~œt\0\0t\0ValidTosr\0\'org.enhydra.shark.xpdl.elements.ValidToû¡∂´M…\0\0xq\0~\0#\0q\0~Ùsq\0~\0\0v⁄2q\0~œt\0\0t\0TimeEstimationsr\0.org.enhydra.shark.xpdl.elements.TimeEstimation≈Ä£\'3\0\0xq\0~\0\0q\0~˘sq\0~\0\0Ô*µq\0~œt\0\0sq\0~\0w\0\0\0t\0WaitingTimesr\0+org.enhydra.shark.xpdl.elements.WaitingTimeNì‰Œ†/\0\0xq\0~\0#\0q\0~ˇsq\0~\0‹’®q\0~˚t\0\0t\0WorkingTimesr\0+org.enhydra.shark.xpdl.elements.WorkingTimeæ~±ÉÊ◊\0\0xq\0~\0#\0q\0~sq\0~\0O¥q\0~˚t\0\0t\0Durationsr\0(org.enhydra.shark.xpdl.elements.Duration© ÙCÙÎË\0\0xq\0~\0#\0q\0~	sq\0~\0êtq\0~˚t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~‘q\0~ﬁq\0~‚q\0~Áq\0~Ïq\0~Òq\0~ˆq\0~˚xt\0RedefinableHeadersq\0~\0H\0q\0~sq\0~\0OÄq\0~ºt\0\0sq\0~\0w\0\0\0q\0~\0Msq\0~\0\0q\0~\0Msq\0~\0\0bô˜q\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~\0Rq\0~\0Sq\0~\0Txt\0Authorsq\0~\0V\0q\0~sq\0~\0jK:q\0~t\0\0t\0Versionsq\0~\0[\0q\0~sq\0~\0qq\0~t\0\0t\0Codepagesq\0~\0`\0q\0~ sq\0~\0∆i‹q\0~t\0\0t\0\nCountrykeysq\0~\0e\0q\0~$sq\0~\0Phq\0~t\0\0t\0Responsiblessq\0~\0j\0q\0~(sq\0~\0Ëx‡q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~q\0~!q\0~%q\0~)xt\0FormalParameterssq\0~ê\0q\0~/sq\0~\0Wıìq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0\nDataFieldssq\0~Æ\0q\0~5sq\0~\0ªòq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0)org.enhydra.shark.xpdl.elements.DataFieldI“3.~ë≠˜\0\0xq\0~\0©t\0	DataFieldsq\0~\0\0äµbq\0~6t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0LËòq\0~<t\0\nhod_actionpq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0ß»Ωq\0~<t\0\0pt\0IsArraysq\0~\0\0q\0~Gsq\0~\0kÛ¥q\0~<t\0FALSEsq\0~\0E\0\0\0w\0\0\0t\0TRUEt\0FALSExt\0DataTypesr\0(org.enhydra.shark.xpdl.elements.DataTypeÜ\'4sM\0\0xq\0~\0q\0~Nsq\0~\0\0ädeq\0~<t\0\0sq\0~\0w\0\0\0t\0	DataTypessr\0)org.enhydra.shark.xpdl.elements.DataTypesµpcH,ﬁ!ì\0Z\0\risInitializedxq\0~ãq\0~Tsq\0~\0≈.rq\0~Pt\0\0sq\0~\0E\0\0\0	w\0\0\0\nsr\0)org.enhydra.shark.xpdl.elements.BasicType∑)®Ωw1øé\0\0xq\0~\0t\0	BasicTypesq\0~\0\0lkbq\0~Vt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0q\0~\0Üsq\0~\0˛4q\0~[t\0STRINGsq\0~\0E\0\0\0w\0\0\0t\0STRINGt\0FLOATt\0INTEGERt\0	REFERENCEt\0DATETIMEt\0BOOLEANt\0	PERFORMERxxsq\0~\0E\0\0\0w\0\0\0\nq\0~`xsr\0,org.enhydra.shark.xpdl.elements.DeclaredTypedR.\\^Ë9í\0\0xq\0~\0t\0DeclaredTypesq\0~\0(ÀÊq\0~Vt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0btÍq\0~mt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~rxsr\0*org.enhydra.shark.xpdl.elements.SchemaType&1oSH™Ö\0\0xq\0~\0t\0\nSchemaTypesq\0~\0\0ÈÎ·q\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0Àt\0ExternalReferencesq\0~\0}2|q\0~Vt\0\0sq\0~\0w\0\0\0q\0~\0–sq\0~\0\0q\0~\0–sq\0~\0\0}zq\0~}t\0\0pq\0~\0‘sq\0~\0q\0~\0‘sq\0~\0’üq\0~}t\0\0pq\0~\0ÿsq\0~\0\0q\0~\0ÿsq\0~\0˜Q…q\0~}t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Çq\0~Öq\0~àxsr\0*org.enhydra.shark.xpdl.elements.RecordTypeı%®Ω©ÎK\0\0\0xq\0~\0kt\0\nRecordTypesq\0~\0\0\Zâq\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0)org.enhydra.shark.xpdl.elements.UnionType¥⁄Ô5PŒG˙\0\0xq\0~\0kt\0	UnionTypesq\0~\0\0=˛q\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0/org.enhydra.shark.xpdl.elements.EnumerationType™⁄ﬁf3b\0\0xq\0~\0kt\0EnumerationTypesq\0~\0\0*\00q\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0)org.enhydra.shark.xpdl.elements.ArrayTypeg¨$\0≠N@\0\0xq\0~\0t\0	ArrayTypesq\0~\0rÜ q\0~Vt\0\0sq\0~\0w\0\0\0t\0\nLowerIndexsq\0~\0q\0~ßsq\0~\0ÔU=q\0~¢t\0\0pt\0\nUpperIndexsq\0~\0q\0~´sq\0~\0≈q\0~¢t\0\0pq\0~Tsq\0~Uq\0~Tsq\0~\0\0rM°q\0~¢t\0\0ppxsq\0~\0E\0\0\0w\0\0\0\nq\0~®q\0~¨q\0~Øxsr\0(org.enhydra.shark.xpdl.elements.ListTypeü\"”ü\nÆ\0\0xq\0~\0t\0ListTypesq\0~\0\0Fªüq\0~Vt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~Uq\0~Tsq\0~\0»\0cq\0~¥t\0\0ppxsq\0~\0E\0\0\0w\0\0\0\nq\0~πxxq\0~[xsq\0~\0E\0\0\0w\0\0\0\nq\0~Vxt\0InitialValuesr\0,org.enhydra.shark.xpdl.elements.InitialValuej,z˚îúR\0\0xq\0~\0#\0q\0~æsq\0~\0ër€q\0~<t\0\0t\0Lengthsr\0&org.enhydra.shark.xpdl.elements.LengthMW+-Ã©W‹\0\0xq\0~\0#\0q\0~√sq\0~\0\0£Vq\0~<t\0\0t\0Descriptionsq\0~\02\0q\0~»sq\0~\0\0î]q\0~<t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~Ãsq\0~\0\0|tq\0~<t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Aq\0~Dq\0~Hq\0~Pq\0~¿q\0~≈q\0~…q\0~Õxxt\0Participantssq\0~\0¢\0q\0~”sq\0~\0\0˘£jq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0Applicationssq\0~s\0q\0~Ÿsq\0~\0WùDq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ActivitySetssr\0,org.enhydra.shark.xpdl.elements.ActivitySets–qV[4™Ó÷\0\0xq\0~\0k\0q\0~ﬂsq\0~\0!q\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0\nActivitiessr\0*org.enhydra.shark.xpdl.elements.Activities&G^·æl˛P\0\0xq\0~\0k\0q\0~Êsq\0~\0.>sq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0sr\0(org.enhydra.shark.xpdl.elements.Activity√tá45\Z9ï\0\0xq\0~\0©t\0Activitysq\0~\0\0&üvq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0∑(Ñq\0~Ót\0wp1_act1pq\0~\0sq\0~\0\0q\0~\0sq\0~\0Ø:†q\0~Ót\0Raise Travel Requisitionpt\0Descriptionsq\0~\02\0q\0~˘sq\0~\02÷q\0~Ót\0\0t\0Limitsq\0~Î\0q\0~˝sq\0~\0Ü≤ q\0~Ót\0\0q\0~\0Üsr\0-org.enhydra.shark.xpdl.elements.ActivityTypese≈Ω{ˆûËË\0\0xq\0~ãq\0~\0Üsq\0~\0\0C˜◊q\0~Ót\0\0sq\0~\0E\0\0\0w\0\0\0\nsr\0%org.enhydra.shark.xpdl.elements.Route0eÓ\r≤G›\0\0xq\0~\0t\0Routesq\0~\0\0DJãq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0.org.enhydra.shark.xpdl.elements.Implementationúrñí^%ä\0\0xq\0~\0t\0Implementationsq\0~\0z\r™q\0~t\0\0sq\0~\0w\0\0\0q\0~\0Üsr\03org.enhydra.shark.xpdl.elements.ImplementationTypes\rü‰TŸ°9\0\0xq\0~ãq\0~\0Üsq\0~\0\0‹q\0~t\0\0sq\0~\0E\0\0\0w\0\0\0\nsr\0\"org.enhydra.shark.xpdl.elements.No{ïÖ⁄.\0\0xq\0~\0t\0Nosq\0~\0g‚⁄q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0%org.enhydra.shark.xpdl.elements.ToolsCø÷g©ë\0\0xq\0~\0k\0t\0Toolssq\0~\0^krq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0\'org.enhydra.shark.xpdl.elements.SubFlow;Oısá7:$\0\0xq\0~\0t\0SubFlowsq\0~\0‡<Uq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0ô]q\0~\'t\0\0pt\0	Executionsq\0~\0\0q\0~/sq\0~\0\0Õeq\0~\'q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0ASYNCHRt\0SYNCHRxt\0ActualParameterssr\00org.enhydra.shark.xpdl.elements.ActualParametersÎå˜µ_ÏK˛\0\0xq\0~\0k\0q\0~5sq\0~\0¥NYq\0~\'t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~,q\0~0q\0~7xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsr\0-org.enhydra.shark.xpdl.elements.BlockActivityíq cƒÍF\0\0xq\0~\0t\0\rBlockActivitysq\0~\0\0Éœîq\0~t\0\0sq\0~\0w\0\0\0t\0BlockIdsq\0~\0q\0~Dsq\0~\0∞˛÷q\0~?t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Exxq\0~t\0	Performersr\0)org.enhydra.shark.xpdl.elements.Performer¶\"1%ËÃƒ\0\0xq\0~\0#\0q\0~Isq\0~\0*°Œq\0~Ót\0Human_Resource_WF_01_par1t\0	StartModesr\0)org.enhydra.shark.xpdl.elements.StartModenhÖÑ◊ÛS\0\0xq\0~\0\0q\0~Nsq\0~\0‰€˚q\0~Ót\0\0sq\0~\0w\0\0\0t\0Modesr\00org.enhydra.shark.xpdl.elements.StartFinishModes~Á6zÂXã\'\0\0xq\0~ã\0q\0~Tsq\0~\0\0&F˜q\0~Pt\0\0sq\0~\0E\0\0\0w\0\0\0\nsr\0,org.enhydra.shark.xpdl.XMLEmptyChoiceElementÔ2‘;Œ3ı_\0\0xq\0~\0\0t\0XMLEmptyChoiceElementsq\0~\0\0-8Sq\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0)org.enhydra.shark.xpdl.elements.AutomaticÈt?˚_Äê\0\0xq\0~\0t\0	Automaticsq\0~\0\0Ã÷]q\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsr\0&org.enhydra.shark.xpdl.elements.Manual∑v™âÓ[ÿ§\0\0xq\0~\0t\0Manualsq\0~\0\0\rÉwq\0~Vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~[xsq\0~\0E\0\0\0w\0\0\0\nq\0~Vxt\0\nFinishModesr\0*org.enhydra.shark.xpdl.elements.FinishModeˆÉ¯õúºÛ{\0\0xq\0~\0\0q\0~psq\0~\02˝q\0~Ót\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0iq\0~rt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0d„q\0~vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0ﬂ≤+q\0~vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0*Qõq\0~vt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~zxsq\0~\0E\0\0\0w\0\0\0\nq\0~vxt\0Prioritysq\0~Ê\0q\0~çsq\0~\0\0S‘øq\0~Ót\0\0t\0	Deadlinessr\0)org.enhydra.shark.xpdl.elements.Deadlines>Ωç…ú√⁄\0\0xq\0~\0k\0q\0~ësq\0~\0¥Y4q\0~Ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsr\05org.enhydra.shark.xpdl.elements.SimulationInformation\"ì|I™£í\0\0xq\0~\0\0q\0~òsq\0~\0L|]q\0~Ót\0\0sq\0~\0w\0\0\0t\0\rInstantiationsq\0~\0\0q\0~ûsq\0~\0\0xÀ´q\0~öq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0ONCEt\0MULTIPLExt\0Costsr\0$org.enhydra.shark.xpdl.elements.Costœ˘¿ﬁÚëû\0\0xq\0~\0#q\0~§sq\0~\0\0Éeäq\0~öt\0\0t\0TimeEstimationsq\0~˙q\0~©sq\0~\0\0pQq\0~öt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~Æsq\0~\0\0ß\\q\0~™t\0\0t\0WorkingTimesq\0~\0q\0~≤sq\0~\0\0ﬁ∂q\0~™t\0\0t\0Durationsq\0~\n\0q\0~∂sq\0~\0–åq\0~™t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~Øq\0~≥q\0~∑xxsq\0~\0E\0\0\0w\0\0\0\nq\0~üq\0~¶q\0~™xt\0Iconsr\0$org.enhydra.shark.xpdl.elements.Icon´TŒU(ˇ}6\0\0xq\0~\0#\0q\0~ºsq\0~\0\0ûI¿q\0~Ót\0\0t\0\rDocumentationsq\0~\07\0q\0~¡sq\0~\0˚ÂÃq\0~Ót\0\0t\0TransitionRestrictionssr\06org.enhydra.shark.xpdl.elements.TransitionRestrictionsC)∑◊Äi;\0\0xq\0~\0k\0q\0~≈sq\0~\0\0´‡.q\0~Ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~Ãsq\0~\0\0\nÚÅq\0~Ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\01org.enhydra.shark.xpdl.elements.ExtendedAttributeª¬\\±ÏF\0\0xq\0~\0t\0ExtendedAttributesq\0~\0\0y#Wq\0~Õt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0ˇaÖq\0~”t\0JaWE_GRAPH_PARTICIPANT_IDpt\0Valuesq\0~\0\0q\0~€sq\0~\0\0[hgq\0~”t\0Human_Resource_WF_01_par1pxsq\0~\0E\0\0\0w\0\0\0\nq\0~ÿq\0~‹xsq\0~“t\0ExtendedAttributesq\0~\0#Dmq\0~Õt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0aVÿq\0~‡t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0åÇ-q\0~‡t\0301,49pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Âq\0~Ëxsq\0~“t\0ExtendedAttributesq\0~\0\0∂â‡q\0~Õt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Êq\0~Ït\0VariableToProcess_VIEWpq\0~€sq\0~\0\0q\0~€sq\0~\0ØÅ	q\0~Ït\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Òq\0~Ùxxpxsq\0~\0E\0\0\0w\0\0\0q\0~Ûq\0~ˆq\0~˙q\0~˛q\0~q\0~Kq\0~Pq\0~rq\0~éq\0~ìq\0~öq\0~æq\0~¬q\0~«q\0~Õxsq\0~Ìt\0Activitysq\0~\0@≤;q\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0úHDq\0~˘t\0wp1_act2pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0uk7q\0~˘t\0WApprove Travel Request for #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#pt\0Descriptionsq\0~\02\0q\0~sq\0~\0\0—Ì>q\0~˘t\0\0t\0Limitsq\0~Î\0q\0~sq\0~\0\0.ìNq\0~˘t\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0»Ëq\0~˘t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0\0˘*£q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0\0^3‘q\0~t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0ú◊Õq\0~t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0Ì∞q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0ëÍ}q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0πÎ4q\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0¨q\0~+t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0Yq\0~+q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~6sq\0~\0\00/9q\0~+t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~0q\0~3q\0~7xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0lW±q\0~t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0ÒCÒq\0~>t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Cxxq\0~t\0	Performersq\0~J\0q\0~Gsq\0~\0\0£ßq\0~˘t\0Human_Resource_WF_01_par2t\0	StartModesq\0~O\0q\0~Ksq\0~\0\0.«Òq\0~˘t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0H”†q\0~Lt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0@Zq\0~Pt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0’\"›q\0~Pt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0‰ìq\0~Pt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~Txsq\0~\0E\0\0\0w\0\0\0\nq\0~Pxt\0\nFinishModesq\0~q\0q\0~gsq\0~\0e  q\0~˘t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0 #Ûq\0~ht\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\ZT+q\0~lt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0åq\0~lt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0&ﬂBq\0~lt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~pxsq\0~\0E\0\0\0w\0\0\0\nq\0~lxt\0Prioritysq\0~Ê\0q\0~Ésq\0~\0äåq\0~˘t\0\0t\0	Deadlinessq\0~í\0q\0~ásq\0~\0\0µÀq\0~˘t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~çsq\0~\0‰ÿq\0~˘t\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0#˘∏q\0~éq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~ïsq\0~\0\0ﬂ◊q\0~ét\0\0t\0TimeEstimationsq\0~˙q\0~ôsq\0~\0úÔ÷q\0~ét\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~ûsq\0~\0\0EÂq\0~öt\0\0t\0WorkingTimesq\0~\0q\0~¢sq\0~\0\0¬Dñq\0~öt\0\0t\0Durationsq\0~\n\0q\0~¶sq\0~\0\0$ÿXq\0~öt\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~üq\0~£q\0~ßxxsq\0~\0E\0\0\0w\0\0\0\nq\0~íq\0~ñq\0~öxt\0Iconsq\0~Ω\0q\0~¨sq\0~\0\0˜~õq\0~˘t\0\0t\0\rDocumentationsq\0~\07\0q\0~∞sq\0~\0\0ô0(q\0~˘t\0\0t\0TransitionRestrictionssq\0~∆\0q\0~¥sq\0~\0(≥:q\0~˘t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\05org.enhydra.shark.xpdl.elements.TransitionRestrictionN˚ƒáπ}˛\0\0xq\0~\0t\0TransitionRestrictionsq\0~\0\0≥âq\0~µt\0\0sq\0~\0w\0\0\0t\0Joinsr\0$org.enhydra.shark.xpdl.elements.Join⁄ï”©x)Û5\0\0xq\0~\0\0q\0~¿sq\0~\0(\nq\0~ªt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0E©q\0~¬t\0XORsq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0ANDt\0XORxxsq\0~\0E\0\0\0w\0\0\0\nq\0~∆xt\0Splitsr\0%org.enhydra.shark.xpdl.elements.Split‹ÌØ~—ØWS\0\0xq\0~\0\0q\0~Õsq\0~\0\0_≠¢q\0~ªt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0Äóq\0~œq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~Àxt\0TransitionRefssr\0.org.enhydra.shark.xpdl.elements.TransitionRefs†Ô≥—ä·ƒÎ\0\0xq\0~\0k\0q\0~÷sq\0~\0?°q\0~œt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~”q\0~ÿxxsq\0~\0E\0\0\0w\0\0\0\nq\0~¬q\0~œxxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~ﬂsq\0~\0©àq\0~˘t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0ñVq\0~‡t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0§Ò·q\0~Ât\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0\0Ôq\0~Ât\0Human_Resource_WF_01_par2pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Íq\0~Ìxsq\0~“t\0ExtendedAttributesq\0~\0\0Ãƒãq\0~‡t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0{¢Èq\0~Òt\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ëõq\0~Òt\0415,47pxsq\0~\0E\0\0\0w\0\0\0\nq\0~ˆq\0~˘xsq\0~“t\0ExtendedAttributesq\0~\0Ûç}q\0~‡t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Œ3ìq\0~˝t\0VariableToProcess_UPDATEpq\0~€sq\0~\0\0q\0~€sq\0~\0úIq\0~˝t\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~xxpxsq\0~\0E\0\0\0w\0\0\0q\0~˛q\0~q\0~q\0~	q\0~q\0~Hq\0~Lq\0~hq\0~Ñq\0~àq\0~éq\0~≠q\0~±q\0~µq\0~‡xsq\0~Ìt\0Activitysq\0~\0\0 -Òq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\01uAq\0~\nt\0wp1_act3pq\0~\0sq\0~\0\0q\0~\0sq\0~\0éXŒq\0~\nt\0]Travel Request: Arrangements for #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#pt\0Descriptionsq\0~\02\0q\0~sq\0~\0\0hl^q\0~\nt\0\0t\0Limitsq\0~Î\0q\0~sq\0~\0¢¶q\0~\nt\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0F±q\0~\nt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0\07q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0\nPhq\0~t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0$ÚÚq\0~\'t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0…Ìq\0~,t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0$fq\0~,t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0¶r\\q\0~,t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0û&q\0~<t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0\0‘Nq\0~<q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~Gsq\0~\0s¯/q\0~<t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~Aq\0~Dq\0~Hxxq\0~0xsq\0~\0E\0\0\0w\0\0\0\nq\0~,xsq\0~>t\0\rBlockActivitysq\0~\0\0™ı.q\0~t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0∆£tq\0~Ot\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Txxq\0~\'t\0	Performersq\0~J\0q\0~Xsq\0~\0\0√q\0~\nt\0Human_Resource_WF_01_par3t\0	StartModesq\0~O\0q\0~\\sq\0~\0\0cˇq\0~\nt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\n6q\0~]t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0F@Êq\0~at\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0NÒÖq\0~at\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0“Çq\0~at\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~exsq\0~\0E\0\0\0w\0\0\0\nq\0~axt\0\nFinishModesq\0~q\0q\0~xsq\0~\0\0[‹„q\0~\nt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0¿eq\0~yt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0ÑC£q\0~}t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0tÖ¨q\0~}t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0Ùq\0~}t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~Åxsq\0~\0E\0\0\0w\0\0\0\nq\0~}xt\0Prioritysq\0~Ê\0q\0~îsq\0~\0\0\0e q\0~\nt\0\0t\0	Deadlinessq\0~í\0q\0~òsq\0~\0\0\Z„\nq\0~\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~ûsq\0~\0/©Æq\0~\nt\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0,Ìzq\0~üq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~¶sq\0~\0ö˜$q\0~üt\0\0t\0TimeEstimationsq\0~˙q\0~™sq\0~\0\0◊]Nq\0~üt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~Øsq\0~\0.ﬂöq\0~´t\0\0t\0WorkingTimesq\0~\0q\0~≥sq\0~\0\0Z4óq\0~´t\0\0t\0Durationsq\0~\n\0q\0~∑sq\0~\0\02π,q\0~´t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~∞q\0~¥q\0~∏xxsq\0~\0E\0\0\0w\0\0\0\nq\0~£q\0~ßq\0~´xt\0Iconsq\0~Ω\0q\0~Ωsq\0~\0\0/2q\0~\nt\0\0t\0\rDocumentationsq\0~\07\0q\0~¡sq\0~\0\0∑∏1q\0~\nt\0\0t\0TransitionRestrictionssq\0~∆\0q\0~≈sq\0~\0ù”Õq\0~\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~Àsq\0~\0\0ºw\"q\0~\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0ß	Òq\0~Ãt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0}∑Kq\0~—t\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0\0åªpq\0~—t\0Human_Resource_WF_01_par3pxsq\0~\0E\0\0\0w\0\0\0\nq\0~÷q\0~Ÿxsq\0~“t\0ExtendedAttributesq\0~\0e‘q\0~Ãt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Gjq\0~›t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0á≤»q\0~›t\0702,49pxsq\0~\0E\0\0\0w\0\0\0\nq\0~‚q\0~Âxsq\0~“t\0ExtendedAttributesq\0~\0\0Íï‡q\0~Ãt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0¿Dq\0~Èt\0VariableToProcess_VIEWpq\0~€sq\0~\0\0q\0~€sq\0~\0ª,q\0~Èt\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Óq\0~Òxxpxsq\0~\0E\0\0\0w\0\0\0q\0~q\0~q\0~q\0~\Zq\0~q\0~Yq\0~]q\0~yq\0~ïq\0~ôq\0~üq\0~æq\0~¬q\0~∆q\0~Ãxsq\0~Ìt\0Activitysq\0~\0\0ßjq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0DU≥q\0~ˆt\0wp1_act4pq\0~\0sq\0~\0\0q\0~\0sq\0~\0(;hq\0~ˆt\0Resubmit Travel Requestpt\0Descriptionsq\0~\02\0q\0~sq\0~\0\0Ti	q\0~ˆt\0\0t\0Limitsq\0~Î\0q\0~sq\0~\0ª˝:q\0~ˆt\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0Ó\0=q\0~ˆt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0Q‡ƒq\0~	t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0\0{5q\0~	t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0‹z\rq\0~t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0—!«q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0î⁄q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0,tπq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0£EDq\0~(t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0\0Ñúq\0~(q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~3sq\0~\0™R!q\0~(t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~-q\0~0q\0~4xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0\0ˆpq\0~	t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0\0äùq\0~;t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~@xxq\0~t\0	Performersq\0~J\0q\0~Dsq\0~\0\\ñq\0~ˆt\0Human_Resource_WF_01_par1t\0	StartModesq\0~O\0q\0~Hsq\0~\0âlq\0~ˆt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0Fâq\0~It\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0œÒ\rq\0~Mt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0⁄≈Qq\0~Mt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0–Tq\0~Mt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~Qxsq\0~\0E\0\0\0w\0\0\0\nq\0~Mxt\0\nFinishModesq\0~q\0q\0~dsq\0~\0\0>Ωq\0~ˆt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0nÔq\0~et\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0•ûáq\0~it\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0J∑\nq\0~it\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\07)q\0~it\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~mxsq\0~\0E\0\0\0w\0\0\0\nq\0~ixt\0Prioritysq\0~Ê\0q\0~Äsq\0~\04◊q\0~ˆt\0\0t\0	Deadlinessq\0~í\0q\0~Ñsq\0~\0d€Hq\0~ˆt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~äsq\0~\0\0xÉﬂq\0~ˆt\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0©—q\0~ãq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~ísq\0~\0\0€ËÕq\0~ãt\0\0t\0TimeEstimationsq\0~˙q\0~ñsq\0~\0ë&´q\0~ãt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~õsq\0~\0\0Å≠èq\0~ót\0\0t\0WorkingTimesq\0~\0q\0~üsq\0~\0©∞ìq\0~ót\0\0t\0Durationsq\0~\n\0q\0~£sq\0~\0áΩ1q\0~ót\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~úq\0~†q\0~§xxsq\0~\0E\0\0\0w\0\0\0\nq\0~èq\0~ìq\0~óxt\0Iconsq\0~Ω\0q\0~©sq\0~\0\0ï˙q\0~ˆt\0\0t\0\rDocumentationsq\0~\07\0q\0~≠sq\0~\0\0pœ!q\0~ˆt\0\0t\0TransitionRestrictionssq\0~∆\0q\0~±sq\0~\0\0.Ñ·q\0~ˆt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~∑sq\0~\0\0^q\0~ˆt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0Õö∏q\0~∏t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0hŒˆq\0~Ωt\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0Îõ\rq\0~Ωt\0Human_Resource_WF_01_par1pxsq\0~\0E\0\0\0w\0\0\0\nq\0~¬q\0~≈xsq\0~“t\0ExtendedAttributesq\0~\0}πq\0~∏t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0Æùq\0~…t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0æR¿q\0~…t\0564,49pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Œq\0~—xsq\0~“t\0ExtendedAttributesq\0~\0\0*œ¢q\0~∏t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0•µóq\0~’t\0VariableToProcess_VIEWpq\0~€sq\0~\0\0q\0~€sq\0~\04Íïq\0~’t\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~⁄q\0~›xxpxsq\0~\0E\0\0\0w\0\0\0q\0~˚q\0~˛q\0~q\0~q\0~	q\0~Eq\0~Iq\0~eq\0~Åq\0~Öq\0~ãq\0~™q\0~Æq\0~≤q\0~∏xsq\0~Ìt\0Activitysq\0~\0Áq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0ÊRíq\0~‚t\0Human_Resource_WF_01_wp1_act5pq\0~\0sq\0~\0\0q\0~\0sq\0~\0π—Lq\0~‚t\0\ZGenerate Travel Request IDpt\0Descriptionsq\0~\02\0q\0~Ìsq\0~\0\0[ËÙq\0~‚t\0\0t\0Limitsq\0~Î\0q\0~Òsq\0~\0\0\Z˜™q\0~‚t\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0y◊≥q\0~‚t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0@I÷q\0~ıt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0Ø¡ﬁq\0~ıt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0·≈q\0~ˇt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0;/Üq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0≠Cëq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0$org.enhydra.shark.xpdl.elements.Tool\\6ñ&∂+GÅ\0\0xq\0~\0©t\0Toolsq\0~\0\0L©0q\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0	ySq\0~t\0default_applicationpq\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0˜∫ìq\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0APPLICATIONt\0	PROCEDURExt\0ActualParameterssq\0~6\0q\0~\"sq\0~\0˙+>q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0Descriptionsq\0~\02\0q\0~(sq\0~\0,˛∑q\0~t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~,sq\0~\0œ$q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\Zq\0~q\0~#q\0~)q\0~-xxsq\0~&t\0SubFlowsq\0~\0/Òq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0˙À⁄q\0~3t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0\0]äãq\0~3q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~>sq\0~\02¨„q\0~3t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~8q\0~;q\0~?xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0Ùë¶q\0~ıt\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0Ü`©q\0~Ft\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Kxxq\0~ˇt\0	Performersq\0~J\0q\0~Osq\0~\03˙q\0~‚t\0Human_Resource_WF_01_par4t\0	StartModesq\0~O\0q\0~Ssq\0~\0gTcq\0~‚t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0’1Sq\0~Tt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0é÷äq\0~Xt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0ßvq\0~Xt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0Rq\0~Xt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~\\xsq\0~\0E\0\0\0w\0\0\0\nq\0~Xxt\0\nFinishModesq\0~q\0q\0~osq\0~\0[π\rq\0~‚t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0“\'q\0~pt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0<\'óq\0~tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0KPq\0~tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0uíeq\0~tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~txt\0Prioritysq\0~Ê\0q\0~ãsq\0~\0\0ﬁ7ñq\0~‚t\0\0t\0	Deadlinessq\0~í\0q\0~èsq\0~\0jºq\0~‚t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~ïsq\0~\0ƒrºq\0~‚t\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0Hòüq\0~ñq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~ùsq\0~\0\0)Vq\0~ñt\0\0t\0TimeEstimationsq\0~˙q\0~°sq\0~\0\0ﬁ¬q\0~ñt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~¶sq\0~\0\0£\\q\0~¢t\0\0t\0WorkingTimesq\0~\0q\0~™sq\0~\0Ê¬q\0~¢t\0\0t\0Durationsq\0~\n\0q\0~Æsq\0~\0Iuq\0~¢t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~ßq\0~´q\0~Øxxsq\0~\0E\0\0\0w\0\0\0\nq\0~öq\0~ûq\0~¢xt\0Iconsq\0~Ω\0q\0~¥sq\0~\0n¢Xq\0~‚t\0\0t\0\rDocumentationsq\0~\07\0q\0~∏sq\0~\0\0dUÆq\0~‚t\0\0t\0TransitionRestrictionssq\0~∆\0q\0~ºsq\0~\05J\Zq\0~‚t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~¬sq\0~\0î	,q\0~‚t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0¯\"êq\0~√t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0•6óq\0~»t\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0£(™q\0~»t\0Human_Resource_WF_01_par4pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Õq\0~–xsq\0~“t\0ExtendedAttributesq\0~\0\0¬∏Îq\0~√t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0˙]\Zq\0~‘t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0ˆ~˚q\0~‘t\0130,51pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Ÿq\0~‹xxpxsq\0~\0E\0\0\0w\0\0\0q\0~Áq\0~Íq\0~Óq\0~Úq\0~ıq\0~Pq\0~Tq\0~pq\0~åq\0~êq\0~ñq\0~µq\0~πq\0~Ωq\0~√xsq\0~Ìt\0Activitysq\0~\0\0\n∞Öq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\n9bq\0~·t\0Human_Resource_WF_01_wp1_act6pq\0~\0sq\0~\0\0q\0~\0sq\0~\0 Ïœq\0~·t\0Routept\0Descriptionsq\0~\02\0q\0~Ïsq\0~\0Åq\0~·t\0\0t\0Limitsq\0~Î\0q\0~sq\0~\0\0FÔ*q\0~·t\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0ˇÌq\0~·t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0\0(/Uq\0~Ùt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0\0;úÇq\0~Ùt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0†M0q\0~˛t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0+¶◊q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0÷≠tq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0\0π‡q\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0^:–q\0~t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0\0gF~q\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~sq\0~\0\0E8˙q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0\0üÆtq\0~Ùt\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0vÇûq\0~&t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~+xxq\0~¯t\0	Performersq\0~J\0q\0~/sq\0~\0yfIq\0~·t\0\0t\0	StartModesq\0~O\0q\0~3sq\0~\0*Ftq\0~·t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0wÉÍq\0~4t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0Kﬂq\0~8t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0Òœxq\0~8t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0k˝Ìq\0~8t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~<xsq\0~\0E\0\0\0w\0\0\0\nq\0~8xt\0\nFinishModesq\0~q\0q\0~Osq\0~\0\0Îq\0~·t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0›Xÿq\0~Pt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0∫ÂÈq\0~Tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0LD+q\0~Tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0îqq\0~Tt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~Xxsq\0~\0E\0\0\0w\0\0\0\nq\0~Txt\0Prioritysq\0~Ê\0q\0~ksq\0~\0⁄û⁄q\0~·t\0\0t\0	Deadlinessq\0~í\0q\0~osq\0~\0Ûßq\0~·t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~usq\0~\0\0Fˆq\0~·t\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0˛FNq\0~vq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~}sq\0~\0π∂≠q\0~vt\0\0t\0TimeEstimationsq\0~˙q\0~Åsq\0~\0àÎq\0~vt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~Üsq\0~\0Á≥mq\0~Çt\0\0t\0WorkingTimesq\0~\0q\0~äsq\0~\0\0¥Ófq\0~Çt\0\0t\0Durationsq\0~\n\0q\0~ésq\0~\0\0èyCq\0~Çt\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~áq\0~ãq\0~èxxsq\0~\0E\0\0\0w\0\0\0\nq\0~zq\0~~q\0~Çxt\0Iconsq\0~Ω\0q\0~îsq\0~\0b3âq\0~·t\0\0t\0\rDocumentationsq\0~\07\0q\0~òsq\0~\0\0%Ä≥q\0~·t\0\0t\0TransitionRestrictionssq\0~∆\0q\0~úsq\0~\0\0${Uq\0~·t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~¢sq\0~\0>›q\0~·t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0±…xq\0~£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\"q\0~®t\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0\0H√>q\0~®t\0Human_Resource_WF_01_par1pxsq\0~\0E\0\0\0w\0\0\0\nq\0~≠q\0~∞xsq\0~“t\0ExtendedAttributesq\0~\0\n\\7q\0~£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0,Mìq\0~¥t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0òåq\0~¥t\0143,50pxsq\0~\0E\0\0\0w\0\0\0\nq\0~πq\0~ºxsq\0~“t\0ExtendedAttributesq\0~\0ÿáàq\0~£t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0™,q\0~¿t\0VariableToProcess_VIEWpq\0~€sq\0~\0\0q\0~€sq\0~\0\06hq\0~¿t\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~≈q\0~»xxpxsq\0~\0E\0\0\0w\0\0\0q\0~Êq\0~Èq\0~Ìq\0~Òq\0~Ùq\0~0q\0~4q\0~Pq\0~lq\0~pq\0~vq\0~ïq\0~ôq\0~ùq\0~£xsq\0~Ìt\0Activitysq\0~\0ÿ<q\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0±◊ˇq\0~Õt\0Human_Resource_WF_01_wp1_act7pq\0~\0sq\0~\0\0q\0~\0sq\0~\0?¿ªq\0~Õt\0Routept\0Descriptionsq\0~\02\0q\0~ÿsq\0~\0\0ÜK+q\0~Õt\0\0t\0Limitsq\0~Î\0q\0~‹sq\0~\0\0±(¢q\0~Õt\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0‚‚úq\0~Õt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0ãrEq\0~‡t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0˚6¬q\0~‡t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0»*q\0~Ít\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0\0b5íq\0~Ôt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0´vq\0~Ôt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0\0Û∆nq\0~Ôt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0hîêq\0~ˇt\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0ÒÅSq\0~ˇq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~	\nsq\0~\0\0a´úq\0~ˇt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~	q\0~	q\0~	xxq\0~Ûxsq\0~\0E\0\0\0w\0\0\0\nq\0~Ôxsq\0~>t\0\rBlockActivitysq\0~\0\0I uq\0~‡t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0\0ä‰1q\0~	t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	xxq\0~‰t\0	Performersq\0~J\0q\0~	sq\0~\0\0ãàΩq\0~Õt\0\0t\0	StartModesq\0~O\0q\0~	sq\0~\0\0æVáq\0~Õt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0\"¿†q\0~	 t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\04IÜq\0~	$t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0∆¸Ñq\0~	$t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0ÏsŸq\0~	$t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~	(xsq\0~\0E\0\0\0w\0\0\0\nq\0~	$xt\0\nFinishModesq\0~q\0q\0~	;sq\0~\0\0©‹¬q\0~Õt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0‹SAq\0~	<t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0x\'Èq\0~	@t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0Ñ\\Œq\0~	@t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0È®q\0~	@t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~	Dxsq\0~\0E\0\0\0w\0\0\0\nq\0~	@xt\0Prioritysq\0~Ê\0q\0~	Wsq\0~\0\0KDq\0~Õt\0\0t\0	Deadlinessq\0~í\0q\0~	[sq\0~\0ö˙&q\0~Õt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~	asq\0~\0ù/q\0~Õt\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0òYq\0~	bq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~	isq\0~\0\0ˇ,Nq\0~	bt\0\0t\0TimeEstimationsq\0~˙q\0~	msq\0~\0\0µ‡zq\0~	bt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~	rsq\0~\0\0§àπq\0~	nt\0\0t\0WorkingTimesq\0~\0q\0~	vsq\0~\0\0NÒq\0~	nt\0\0t\0Durationsq\0~\n\0q\0~	zsq\0~\0\0≈»q\0~	nt\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~	sq\0~	wq\0~	{xxsq\0~\0E\0\0\0w\0\0\0\nq\0~	fq\0~	jq\0~	nxt\0Iconsq\0~Ω\0q\0~	Äsq\0~\0\0v‘Øq\0~Õt\0\0t\0\rDocumentationsq\0~\07\0q\0~	Ñsq\0~\0Ögﬁq\0~Õt\0\0t\0TransitionRestrictionssq\0~∆\0q\0~	àsq\0~\0fLµq\0~Õt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~∫t\0TransitionRestrictionsq\0~\0\0O6#q\0~	ât\0\0sq\0~\0w\0\0\0t\0Joinsq\0~¡\0q\0~	ìsq\0~\0\0kLúq\0~	ét\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0r¶dq\0~	îq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~Àxxsq\0~\0E\0\0\0w\0\0\0\nq\0~	òxt\0Splitsq\0~Œ\0q\0~	úsq\0~\0\n\"¡q\0~	ét\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0oæﬂq\0~	ùt\0XORsq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~Àxt\0TransitionRefssq\0~◊\0q\0~	•sq\0~\0\0\\[q\0~	ùt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0-org.enhydra.shark.xpdl.elements.TransitionRefÉ%-ÀÒaö\0\0xq\0~\0©t\0\rTransitionRefsq\0~\0ôõñq\0~	¶t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0µòøq\0~	¨t\0Human_Resource_WF_01_wp1_tra7pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	±xsq\0~	´t\0\rTransitionRefsq\0~\0?_¯q\0~	¶t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0µ∆∂q\0~	µt\0Human_Resource_WF_01_wp1_tra5pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	∫xsq\0~	´t\0\rTransitionRefsq\0~\0È\nq\0~	¶t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0˚ Üq\0~	æt\0Human_Resource_WF_01_wp1_tra9pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	√xxxsq\0~\0E\0\0\0w\0\0\0\nq\0~	°q\0~	¶xxsq\0~\0E\0\0\0w\0\0\0\nq\0~	îq\0~	ùxxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~	…sq\0~\06<Pq\0~Õt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0OÁ6q\0~	 t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0‘Ø‘q\0~	œt\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0cñq\0~	œt\0Human_Resource_WF_01_par2pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	‘q\0~	◊xsq\0~“t\0ExtendedAttributesq\0~\0ekq\0~	 t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0¿]ïq\0~	€t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0?ÔÚq\0~	€t\0574,52pxsq\0~\0E\0\0\0w\0\0\0\nq\0~	‡q\0~	„xxpxsq\0~\0E\0\0\0w\0\0\0q\0~“q\0~’q\0~Ÿq\0~›q\0~‡q\0~	q\0~	 q\0~	<q\0~	Xq\0~	\\q\0~	bq\0~	Åq\0~	Öq\0~	âq\0~	 xsq\0~Ìt\0Activitysq\0~\0\0¢—q\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0éh:q\0~	Ët\0Human_Resource_WF_01_wp1_act8pq\0~\0sq\0~\0\0q\0~\0sq\0~\0+˜Uq\0~	Ët\0#Email: Notify Requestor of Approvalpt\0Descriptionsq\0~\02\0q\0~	Ûsq\0~\0{+ôq\0~	Ët\0\0t\0Limitsq\0~Î\0q\0~	˜sq\0~\0ke=q\0~	Ët\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0√ù	q\0~	Ët\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0zﬂ¥q\0~	˚t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0Ù»q\0~	˚t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0}∑Æq\0~\nt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0\0¶(@q\0~\n\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0úø°q\0~\n\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Toolsq\0~\0Ûjˆq\0~\nt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0BgÄq\0~\n\Zt\0default_applicationpq\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0Û}q\0~\n\Zq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~!xt\0ActualParameterssq\0~6\0q\0~\n%sq\0~\0\0òßÎq\0~\n\Zt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0Descriptionsq\0~\02\0q\0~\n+sq\0~\0\08>÷q\0~\n\Zt\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~\n/sq\0~\0\0•áq\0~\n\Zt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\nq\0~\n\"q\0~\n&q\0~\n,q\0~\n0xxsq\0~&t\0SubFlowsq\0~\0\0È°q\0~\n\nt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Ã‹Íq\0~\n6t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0ªã)q\0~\n6q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~\nAsq\0~\0≠Ruq\0~\n6t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\n;q\0~\n>q\0~\nBxxq\0~\nxsq\0~\0E\0\0\0w\0\0\0\nq\0~\n\nxsq\0~>t\0\rBlockActivitysq\0~\0\0\0¿œq\0~	˚t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0r}q\0~\nIt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\nNxxq\0~\nt\0	Performersq\0~J\0q\0~\nRsq\0~\0mµ:q\0~	Ët\0Human_Resource_WF_01_par4t\0	StartModesq\0~O\0q\0~\nVsq\0~\0ï#»q\0~	Ët\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0`-ùq\0~\nWt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0J5q\0~\n[t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0∂^6q\0~\n[t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0„Qq\0~\n[t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~\n_xsq\0~\0E\0\0\0w\0\0\0\nq\0~\n[xt\0\nFinishModesq\0~q\0q\0~\nrsq\0~\0\0›sq\0~	Ët\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0.∞≥q\0~\nst\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0ß1\\q\0~\nwt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0ôÃÊq\0~\nwt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0[$›q\0~\nwt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~\n{xsq\0~\0E\0\0\0w\0\0\0\nq\0~\nwxt\0Prioritysq\0~Ê\0q\0~\nésq\0~\0\0—-˜q\0~	Ët\0\0t\0	Deadlinessq\0~í\0q\0~\nísq\0~\0 ”Yq\0~	Ët\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~\nòsq\0~\0\0ÉÎq\0~	Ët\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\09ªq\0~\nôq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~\n†sq\0~\0\0Î¡q\0~\nôt\0\0t\0TimeEstimationsq\0~˙q\0~\n§sq\0~\0”n˚q\0~\nôt\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~\n©sq\0~\0\0^2q\0~\n•t\0\0t\0WorkingTimesq\0~\0q\0~\n≠sq\0~\0\0≈R’q\0~\n•t\0\0t\0Durationsq\0~\n\0q\0~\n±sq\0~\0\0¡<q\0~\n•t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~\n™q\0~\nÆq\0~\n≤xxsq\0~\0E\0\0\0w\0\0\0\nq\0~\nùq\0~\n°q\0~\n•xt\0Iconsq\0~Ω\0q\0~\n∑sq\0~\0\0PC÷q\0~	Ët\0\0t\0\rDocumentationsq\0~\07\0q\0~\nªsq\0~\0ï¶&q\0~	Ët\0\0t\0TransitionRestrictionssq\0~∆\0q\0~\nøsq\0~\0œq\0~	Ët\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~\n≈sq\0~\0\0~˙ˆq\0~	Ët\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0™Ù8q\0~\n∆t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0áòBq\0~\nÀt\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0K.q\0~\nÀt\0Human_Resource_WF_01_par4pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\n–q\0~\n”xsq\0~“t\0ExtendedAttributesq\0~\0\02‹uq\0~\n∆t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\'àÄq\0~\n◊t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0r«ñq\0~\n◊t\0699,55pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\n‹q\0~\nﬂxxpxsq\0~\0E\0\0\0w\0\0\0q\0~	Ìq\0~	q\0~	Ùq\0~	¯q\0~	˚q\0~\nSq\0~\nWq\0~\nsq\0~\nèq\0~\nìq\0~\nôq\0~\n∏q\0~\nºq\0~\n¿q\0~\n∆xsq\0~Ìt\0Activitysq\0~\0çÖöq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0m6•q\0~\n‰t\0Human_Resource_WF_01_wp1_act9pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0>wôq\0~\n‰t\0$Email: Notify Requestor of Rejectionpt\0Descriptionsq\0~\02\0q\0~\nÔsq\0~\0„q\0~\n‰t\0\0t\0Limitsq\0~Î\0q\0~\nÛsq\0~\0ëRúq\0~\n‰t\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0∆èÙq\0~\n‰t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0Æq\0~\n˜t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0 ñq\0~\n˜t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0}]Öq\0~t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0\0ÜÌ˛q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0\0r‹∂q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Toolsq\0~\0\0Uq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0ŸVCq\0~t\0default_applicationpq\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0ÎØeq\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~!xt\0ActualParameterssq\0~6\0q\0~!sq\0~\0\0H˘q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0Descriptionsq\0~\02\0q\0~\'sq\0~\0\0Yúq\0~t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~+sq\0~\0QàÉq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~q\0~\"q\0~(q\0~,xxsq\0~&t\0SubFlowsq\0~\0\0¯jgq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0íΩq\0~2t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0\0∏ﬂﬂq\0~2q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~=sq\0~\0q÷˙q\0~2t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~7q\0~:q\0~>xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0\0ÿ‡‹q\0~\n˜t\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0\0íê\rq\0~Et\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Jxxq\0~t\0	Performersq\0~J\0q\0~Nsq\0~\0\0/q‚q\0~\n‰t\0Human_Resource_WF_01_par4t\0	StartModesq\0~O\0q\0~Rsq\0~\0\0›≈$q\0~\n‰t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0π˝Äq\0~St\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0‰bq\0~Wt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0·√ßq\0~Wt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0Ù	dq\0~Wt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~[xsq\0~\0E\0\0\0w\0\0\0\nq\0~Wxt\0\nFinishModesq\0~q\0q\0~nsq\0~\0\0î∏Üq\0~\n‰t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0ﬁ£Bq\0~ot\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0QU·q\0~st\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0›Bq\0~st\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\0 :q\0~st\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~wxsq\0~\0E\0\0\0w\0\0\0\nq\0~sxt\0Prioritysq\0~Ê\0q\0~äsq\0~\0≈zjq\0~\n‰t\0\0t\0	Deadlinessq\0~í\0q\0~ésq\0~\0ÁÁËq\0~\n‰t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~îsq\0~\0\0*^uq\0~\n‰t\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0üWÉq\0~ïq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~úsq\0~\0\0*dåq\0~ït\0\0t\0TimeEstimationsq\0~˙q\0~†sq\0~\0/+ûq\0~ït\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~•sq\0~\0ÿ∫Øq\0~°t\0\0t\0WorkingTimesq\0~\0q\0~©sq\0~\0»HÖq\0~°t\0\0t\0Durationsq\0~\n\0q\0~≠sq\0~\0\0\"q\0~°t\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~¶q\0~™q\0~Æxxsq\0~\0E\0\0\0w\0\0\0\nq\0~ôq\0~ùq\0~°xt\0Iconsq\0~Ω\0q\0~≥sq\0~\0\0œÔÈq\0~\n‰t\0\0t\0\rDocumentationsq\0~\07\0q\0~∑sq\0~\0èË¸q\0~\n‰t\0\0t\0TransitionRestrictionssq\0~∆\0q\0~ªsq\0~\0	.àq\0~\n‰t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~¡sq\0~\0Œëq\0~\n‰t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0p¯q\0~¬t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0(i)q\0~«t\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ãq\0~«t\0Human_Resource_WF_01_par4pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Ãq\0~œxsq\0~“t\0ExtendedAttributesq\0~\0f4q\0~¬t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0.ùëq\0~”t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0j¡&q\0~”t\0704,154pxsq\0~\0E\0\0\0w\0\0\0\nq\0~ÿq\0~€xxpxsq\0~\0E\0\0\0w\0\0\0q\0~\nÈq\0~\nÏq\0~\nq\0~\nÙq\0~\n˜q\0~Oq\0~Sq\0~oq\0~ãq\0~èq\0~ïq\0~¥q\0~∏q\0~ºq\0~¬xsq\0~Ìt\0Activitysq\0~\0Æ◊¡q\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\06¨´q\0~‡t\0	wp1_act10pq\0~\0sq\0~\0\0q\0~\0sq\0~\0÷‘Aq\0~‡t\0WTravel Request Approved by #performer.wp1_act2.firstName# #performer.wp1_act2.lastName#pt\0Descriptionsq\0~\02\0q\0~Îsq\0~\0	?q\0~‡t\0\0t\0Limitsq\0~Î\0q\0~Ôsq\0~\0°¯q\0~‡t\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\0tÃpq\0~‡t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0\0”sq\0~Ût\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0âH\0q\0~Ût\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0÷q\0~˝t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0•UZq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0Üƒ\rq\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0\0±N¸q\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0∏¢ãq\0~t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0∑äiq\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~sq\0~\0\0‡5\0q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~\Zq\0~xxq\0~xsq\0~\0E\0\0\0w\0\0\0\nq\0~xsq\0~>t\0\rBlockActivitysq\0~\0∑…—q\0~Ût\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0\"ÀØq\0~%t\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~*xxq\0~˝t\0	Performersq\0~J\0q\0~.sq\0~\0jqûq\0~‡t\0Human_Resource_WF_01_par1t\0	StartModesq\0~O\0q\0~2sq\0~\0Iu7q\0~‡t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0Æâ5q\0~3t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0è∑q\0~7t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0)U!q\0~7t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0î*<q\0~7t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~;xsq\0~\0E\0\0\0w\0\0\0\nq\0~7xt\0\nFinishModesq\0~q\0q\0~Nsq\0~\0\0`ÔÁq\0~‡t\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0\0&^Gq\0~Ot\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0¨å=q\0~St\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0+$ºq\0~St\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0xÃ‚q\0~St\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~Wxsq\0~\0E\0\0\0w\0\0\0\nq\0~Sxt\0Prioritysq\0~Ê\0q\0~jsq\0~\0”5Dq\0~‡t\0\0t\0	Deadlinessq\0~í\0q\0~nsq\0~\0N;∞q\0~‡t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~tsq\0~\00√\\q\0~‡t\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0i÷€q\0~uq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~|sq\0~\0\0ò¯dq\0~ut\0\0t\0TimeEstimationsq\0~˙q\0~Äsq\0~\0\0€Ö\"q\0~ut\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~Ösq\0~\0\0ödq\0~Åt\0\0t\0WorkingTimesq\0~\0q\0~âsq\0~\0?TÆq\0~Åt\0\0t\0Durationsq\0~\n\0q\0~çsq\0~\0\0–©≤q\0~Åt\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~Üq\0~äq\0~éxxsq\0~\0E\0\0\0w\0\0\0\nq\0~yq\0~}q\0~Åxt\0Iconsq\0~Ω\0q\0~ìsq\0~\04¸\Zq\0~‡t\0\0t\0\rDocumentationsq\0~\07\0q\0~ósq\0~\0ì+Fq\0~‡t\0\0t\0TransitionRestrictionssq\0~∆\0q\0~õsq\0~\0\0˛=˛q\0~‡t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~°sq\0~\0òkq\0~‡t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0Ú≥˘q\0~¢t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0∑|q\0~ßt\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0Qh_q\0~ßt\0Human_Resource_WF_01_par1pxsq\0~\0E\0\0\0w\0\0\0\nq\0~¨q\0~Øxsq\0~“t\0ExtendedAttributesq\0~\0õ`ªq\0~¢t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0Îøﬁq\0~≥t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0Å»hq\0~≥t\0886,49pxsq\0~\0E\0\0\0w\0\0\0\nq\0~∏q\0~ªxsq\0~“t\0ExtendedAttributesq\0~\0\0å$\Zq\0~¢t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0ñL+q\0~øt\0VariableToProcess_VIEWpq\0~€sq\0~\0\0q\0~€sq\0~\0b–±q\0~øt\0\nhod_actionpxsq\0~\0E\0\0\0w\0\0\0\nq\0~ƒq\0~«xxpxsq\0~\0E\0\0\0w\0\0\0q\0~Âq\0~Ëq\0~Ïq\0~q\0~Ûq\0~/q\0~3q\0~Oq\0~kq\0~oq\0~uq\0~îq\0~òq\0~úq\0~¢xsq\0~Ìt\0Activitysq\0~\0\0sGpq\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\09A\nq\0~Ãt\0Human_Resource_WF_01_wp1_act11pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0WA∞q\0~Ãt\0Routept\0Descriptionsq\0~\02\0q\0~◊sq\0~\0\0ôå	q\0~Ãt\0\0t\0Limitsq\0~Î\0q\0~€sq\0~\0\0∏‚«q\0~Ãt\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0\00öq\0~Ãt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Routesq\0~\0\0“¥pq\0~ﬂt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\rt\0Implementationsq\0~\0D5Âq\0~ﬂt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~q\0~\0Üsq\0~\0.É`q\0~Èt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~t\0Nosq\0~\0\0≥S‘q\0~Ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~\0t\0Toolssq\0~\0D¡4q\0~Ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~&t\0SubFlowsq\0~\0\0Ë`sq\0~Ót\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\00Ûq\0~˛t\0\0pq\0~/sq\0~\0\0q\0~/sq\0~\0ô´—q\0~˛q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~3q\0~4xt\0ActualParameterssq\0~6\0q\0~\r	sq\0~\0ﬂC‚q\0~˛t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rq\0~\rq\0~\r\nxxq\0~Úxsq\0~\0E\0\0\0w\0\0\0\nq\0~Óxsq\0~>t\0\rBlockActivitysq\0~\0\0·∂¨q\0~ﬂt\0\0sq\0~\0w\0\0\0q\0~Dsq\0~\0q\0~Dsq\0~\0\0ü¯Åq\0~\rt\0\0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rxxq\0~„t\0	Performersq\0~J\0q\0~\r\Zsq\0~\0\0tÎq\0~Ãt\0\0t\0	StartModesq\0~O\0q\0~\rsq\0~\0å©—q\0~Ãt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0‡ËÖq\0~\rt\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0¢ûmq\0~\r#t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0O\ZÚq\0~\r#t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0r-q\0~\r#t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~\r\'xsq\0~\0E\0\0\0w\0\0\0\nq\0~\r#xt\0\nFinishModesq\0~q\0q\0~\r:sq\0~\0\0ËÃîq\0~Ãt\0\0sq\0~\0w\0\0\0q\0~Tsq\0~U\0q\0~Tsq\0~\0œC|q\0~\r;t\0\0sq\0~\0E\0\0\0w\0\0\0\nsq\0~Z\0t\0XMLEmptyChoiceElementsq\0~\0\0˝≤q\0~\r?t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~at\0	Automaticsq\0~\0\0∂Ô≤q\0~\r?t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxsq\0~ht\0Manualsq\0~\0\02õÀq\0~\r?t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxxq\0~\rCxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r?xt\0Prioritysq\0~Ê\0q\0~\rVsq\0~\0\0í5¬q\0~Ãt\0\0t\0	Deadlinessq\0~í\0q\0~\rZsq\0~\0píq\0~Ãt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0\0w\0\0\0\nxt\0SimulationInformationsq\0~ô\0q\0~\r`sq\0~\0oÑÿq\0~Ãt\0\0sq\0~\0w\0\0\0q\0~ûsq\0~\0\0q\0~ûsq\0~\0\0zø1q\0~\raq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~¢q\0~£xt\0Costsq\0~•q\0~\rhsq\0~\0\0û.Pq\0~\rat\0\0t\0TimeEstimationsq\0~˙q\0~\rlsq\0~\0\0Ú†&q\0~\rat\0\0sq\0~\0w\0\0\0t\0WaitingTimesq\0~\0\0q\0~\rqsq\0~\0\06ﬁq\0~\rmt\0\0t\0WorkingTimesq\0~\0q\0~\rusq\0~\0\0¢Gq\0~\rmt\0\0t\0Durationsq\0~\n\0q\0~\rysq\0~\0Êûôq\0~\rmt\0\0xsq\0~\0E\0\0\0w\0\0\0\nq\0~\rrq\0~\rvq\0~\rzxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\req\0~\riq\0~\rmxt\0Iconsq\0~Ω\0q\0~\rsq\0~\0∂fYq\0~Ãt\0\0t\0\rDocumentationsq\0~\07\0q\0~\rÉsq\0~\0˘ûêq\0~Ãt\0\0t\0TransitionRestrictionssq\0~∆\0q\0~\rásq\0~\0Vq\0~Ãt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~∫t\0TransitionRestrictionsq\0~\0\0ﬁ)üq\0~\ràt\0\0sq\0~\0w\0\0\0t\0Joinsq\0~¡\0q\0~\rísq\0~\0~ºâq\0~\rçt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0ã÷Üq\0~\rìq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~Àxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\róxt\0Splitsq\0~Œ\0q\0~\rõsq\0~\0±Óq\0~\rçt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0’Aq\0~\rút\0ANDsq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~ q\0~Àxt\0TransitionRefssq\0~◊\0q\0~\r§sq\0~\0\0Tq\0~\rút\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~	´t\0\rTransitionRefsq\0~\0´`áq\0~\r•t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0NbÃq\0~\r™t\0Human_Resource_WF_01_wp1_tra10pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rØxsq\0~	´t\0\rTransitionRefsq\0~\0\08{¬q\0~\r•t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0EÌq\0~\r≥t\0Human_Resource_WF_01_wp1_tra11pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r∏xxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r†q\0~\r•xxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rìq\0~\rúxxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~\ræsq\0~\0\0ùpq\0~Ãt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0bﬂq\0~\røt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0}Sÿq\0~\rƒt\0JaWE_GRAPH_PARTICIPANT_IDpq\0~€sq\0~\0\0q\0~€sq\0~\0\0éBq\0~\rƒt\0Human_Resource_WF_01_par3pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r…q\0~\rÃxsq\0~“t\0ExtendedAttributesq\0~\0\0®æCq\0~\røt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0c_ûq\0~\r–t\0JaWE_GRAPH_OFFSETpq\0~€sq\0~\0\0q\0~€sq\0~\0\0\Z≠uq\0~\r–t\0714,144pxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r’q\0~\rÿxxpxsq\0~\0E\0\0\0w\0\0\0q\0~—q\0~‘q\0~ÿq\0~‹q\0~ﬂq\0~\rq\0~\rq\0~\r;q\0~\rWq\0~\r[q\0~\raq\0~\rÄq\0~\rÑq\0~\ràq\0~\røxxt\0Transitionssr\0+org.enhydra.shark.xpdl.elements.TransitionsÌ9>‰¿/iØ\0\0xq\0~\0k\0q\0~\r›sq\0~\0+q\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0sr\0*org.enhydra.shark.xpdl.elements.Transitiontßx∏Ö\0\0xq\0~\0©t\0\nTransitionsq\0~\0\0»Ô¢q\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0¸nXq\0~\rÂt\0Human_Resource_WF_01_wp1_tra1pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0`Aq\0~\rÂt\0\0pt\0Fromsq\0~\0q\0~\rsq\0~\0Ï∞îq\0~\rÂt\0Human_Resource_WF_01_wp1_act5pt\0Tosq\0~\0q\0~\rÙsq\0~\0\0<ﬂ-q\0~\rÂt\0wp1_act1pt\0	Conditionsr\0)org.enhydra.shark.xpdl.elements.Condition€‡D··Z;|\0\0xq\0~\0\0q\0~\r¯sq\0~\0M$eq\0~\rÂt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0êôÏq\0~\r˙q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pt\0	CONDITIONt\0	OTHERWISEt\0	EXCEPTIONt\0DEFAULTEXCEPTIONxxsq\0~\0E\0\0\0w\0\0\0\nq\0~\r˛xt\0Descriptionsq\0~\02\0q\0~sq\0~\0\0i`q\0~\rÂt\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~\nsq\0~\0\0äq\0~\rÂt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0~\rq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0°¡ıq\0~t\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ƒº©q\0~t\0266,590-266,79pxsq\0~\0E\0\0\0w\0\0\0\nq\0~q\0~xsq\0~“t\0ExtendedAttributesq\0~\0\0>\rq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0Ã≠úq\0~t\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ôË¯q\0~t\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~!q\0~$xxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rÍq\0~\rÌq\0~\rÒq\0~\rıq\0~\r˙q\0~q\0~xsq\0~\r‰t\0\nTransitionsq\0~\0\0é2∑q\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0up^q\0~)t\0Human_Resource_WF_01_wp1_tra2pq\0~\0sq\0~\0\0q\0~\0sq\0~\0îßÏq\0~)t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0£¢4q\0~)t\0Human_Resource_WF_01_wp1_act6pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0Ó3Ûq\0~)t\0Human_Resource_WF_01_wp1_act5pt\0	Conditionsq\0~\r˘\0q\0~:sq\0~\0\0úÜ q\0~)t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0)§Qq\0~;q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~?xt\0Descriptionsq\0~\02\0q\0~Csq\0~\0‚◊wq\0~)t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~Gsq\0~\0Øœ‘q\0~)t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0ÿZπq\0~Ht\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0,Mèq\0~Mt\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0óı8q\0~Mt\0NO_ROUTING_SPLINEpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Rq\0~Uxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~.q\0~1q\0~4q\0~7q\0~;q\0~Dq\0~Hxsq\0~\r‰t\0\nTransitionsq\0~\0dmÂq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0ãëÀq\0~Zt\0Human_Resource_WF_01_wp1_tra3pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0…≤ºq\0~Zt\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0k\njq\0~Zt\0wp1_act1pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0xÔ’q\0~Zt\0wp1_act2pt\0	Conditionsq\0~\r˘\0q\0~ksq\0~\0ıÉ4q\0~Zt\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0yXq\0~lq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~pxt\0Descriptionsq\0~\02\0q\0~tsq\0~\0\0^`q\0~Zt\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~xsq\0~\0\0Ò¨q\0~Zt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0∫Kπq\0~yt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0¡å1q\0~~t\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0\0⁄¸Úq\0~~t\0353,227pxsq\0~\0E\0\0\0w\0\0\0\nq\0~Éq\0~Üxsq\0~“t\0ExtendedAttributesq\0~\0Ü≈q\0~yt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0úáq\0~ät\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0\0j!≤q\0~ät\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~èq\0~íxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~_q\0~bq\0~eq\0~hq\0~lq\0~uq\0~yxsq\0~\r‰t\0\nTransitionsq\0~\0 3|q\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0[dKq\0~ót\0Human_Resource_WF_01_wp1_tra4pq\0~\0sq\0~\0\0q\0~\0sq\0~\0âÖ∫q\0~ót\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0˙q\0~ót\0wp1_act2pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0\09ëßq\0~ót\0Human_Resource_WF_01_wp1_act7pt\0	Conditionsq\0~\r˘\0q\0~®sq\0~\0™é∑q\0~ót\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0»†q\0~©q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~≠xt\0Descriptionsq\0~\02\0q\0~±sq\0~\0L≠ƒq\0~ót\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~µsq\0~\0$6q\0~ót\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0c‹(q\0~∂t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0\nÂq\0~ªt\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0Dﬂq\0~ªt\0NO_ROUTING_SPLINEpxsq\0~\0E\0\0\0w\0\0\0\nq\0~¿q\0~√xxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~úq\0~üq\0~¢q\0~•q\0~©q\0~≤q\0~∂xsq\0~\r‰t\0\nTransitionsq\0~\0\0 Wq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0õ[/q\0~»t\0Human_Resource_WF_01_wp1_tra5pq\0~\0sq\0~\0\0q\0~\0sq\0~\0ß#Oq\0~»t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0Æ©Dq\0~»t\0Human_Resource_WF_01_wp1_act7pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0\0ÍÊq\0~»t\0wp1_act4pt\0	Conditionsq\0~\r˘\0q\0~Ÿsq\0~\0ˇ?]q\0~»t\0hod_action==\'Resubmit\'sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0ò˛˘q\0~⁄t\0	CONDITIONsq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~ﬁxt\0Descriptionsq\0~\02\0q\0~„sq\0~\0\0ã Cq\0~»t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~Ásq\0~\0åØq\0~»t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0ˆí_q\0~Ët\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0æXq\0~Ìt\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0≈èπq\0~Ìt\0NO_ROUTING_SPLINEpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Úq\0~ıxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Õq\0~–q\0~”q\0~÷q\0~⁄q\0~‰q\0~Ëxsq\0~\r‰t\0\nTransitionsq\0~\0^…Ùq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Î·q\0~˙t\0Human_Resource_WF_01_wp1_tra6pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0ö·´q\0~˙t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0Ω\"q\0~˙t\0wp1_act4pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0\0≈Cq\0~˙t\0wp1_act2pt\0	Conditionsq\0~\r˘\0q\0~sq\0~\0\0Uøúq\0~˙t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0ñ¢q\0~q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~xt\0Descriptionsq\0~\02\0q\0~sq\0~\0\0mo≈q\0~˙t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~sq\0~\0\0≈‰q\0~˙t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0‹q\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0o¢•q\0~t\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0\0(gq\0~t\0463,78pxsq\0~\0E\0\0\0w\0\0\0\nq\0~#q\0~&xsq\0~“t\0ExtendedAttributesq\0~\0ïøÕq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0cOkq\0~*t\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0Û0^q\0~*t\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~/q\0~2xxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~ˇq\0~q\0~q\0~q\0~q\0~q\0~xsq\0~\r‰t\0\nTransitionsq\0~\0\0ÏzÆq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\05÷q\0~7t\0Human_Resource_WF_01_wp1_tra7pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0\\Êq\0~7t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0jZÈq\0~7t\0Human_Resource_WF_01_wp1_act7pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0vÜq\0~7t\0wp1_act3pt\0	Conditionsq\0~\r˘\0q\0~Hsq\0~\0ïvq\0~7t\0hod_action==\'Approved\'sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0¢õq\0~It\0	CONDITIONsq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~Mxt\0Descriptionsq\0~\02\0q\0~Rsq\0~\0C¶Äq\0~7t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~Vsq\0~\0\0hG.q\0~7t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0n:~q\0~Wt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0¬/\"q\0~\\t\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0§ê>q\0~\\t\0753,229pxsq\0~\0E\0\0\0w\0\0\0\nq\0~aq\0~dxsq\0~“t\0ExtendedAttributesq\0~\0\0˘ÎÕq\0~Wt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0Ë\Z≥q\0~ht\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\01\Z>q\0~ht\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~mq\0~pxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~<q\0~?q\0~Bq\0~Eq\0~Iq\0~Sq\0~Wxsq\0~\r‰t\0\nTransitionsq\0~\0\0≤\n1q\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0≤q\0~ut\0Human_Resource_WF_01_wp1_tra8pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0ù˘q\0~ut\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0ª*œq\0~ut\0wp1_act3pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0˜∂·q\0~ut\0Human_Resource_WF_01_wp1_act11pt\0	Conditionsq\0~\r˘\0q\0~Üsq\0~\0\0`q\0~ut\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0∞–Ìq\0~áq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~ãxt\0Descriptionsq\0~\02\0q\0~èsq\0~\0d¥˛q\0~ut\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~ìsq\0~\0\0¶Õıq\0~ut\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0V:=q\0~ît\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0	ò3q\0~ôt\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0ÁcEq\0~ôt\0NO_ROUTING_SPLINEpxsq\0~\0E\0\0\0w\0\0\0\nq\0~ûq\0~°xxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~zq\0~}q\0~Äq\0~Éq\0~áq\0~êq\0~îxsq\0~\r‰t\0\nTransitionsq\0~\0\0&Lq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Ì∞q\0~¶t\0Human_Resource_WF_01_wp1_tra9pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0Ò`pq\0~¶t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0Mï«q\0~¶t\0Human_Resource_WF_01_wp1_act7pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0§B q\0~¶t\0Human_Resource_WF_01_wp1_act9pt\0	Conditionsq\0~\r˘\0q\0~∑sq\0~\0\0ÚÅçq\0~¶t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0ueq\0~∏t\0	OTHERWISEsq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~ºxt\0Descriptionsq\0~\02\0q\0~¡sq\0~\0Nˆq\0~¶t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~≈sq\0~\0Ñ\ZÂq\0~¶t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0–ı~q\0~∆t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0•QCq\0~Àt\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0\0zq\0~Àt\0613,687pxsq\0~\0E\0\0\0w\0\0\0\nq\0~–q\0~”xsq\0~“t\0ExtendedAttributesq\0~\0\0\0Yıq\0~∆t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0ÁÌq\0~◊t\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ë°)q\0~◊t\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~‹q\0~ﬂxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~´q\0~Æq\0~±q\0~¥q\0~∏q\0~¬q\0~∆xsq\0~\r‰t\0\nTransitionsq\0~\0\0Îõsq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0æmÅq\0~‰t\0Human_Resource_WF_01_wp1_tra10pq\0~\0sq\0~\0\0q\0~\0sq\0~\0\0_j∆q\0~‰t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0\0*∏6q\0~‰t\0Human_Resource_WF_01_wp1_act11pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0\0§œq\0~‰t\0Human_Resource_WF_01_wp1_act8pt\0	Conditionsq\0~\r˘\0q\0~ısq\0~\0\0[)‡q\0~‰t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\Zk«q\0~ˆq\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~˙xt\0Descriptionsq\0~\02\0q\0~˛sq\0~\0ôˆ.q\0~‰t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~sq\0~\0\0Òw\nq\0~‰t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0ÓLiq\0~t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0⁄ô\rq\0~t\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0\0vaÙq\0~t\0NO_ROUTING_SPLINEpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\rq\0~xxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Èq\0~Ïq\0~Ôq\0~Úq\0~ˆq\0~ˇq\0~xsq\0~\r‰t\0\nTransitionsq\0~\0\0Ûq\0~\rﬂt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Nq\0~t\0Human_Resource_WF_01_wp1_tra11pq\0~\0sq\0~\0\0q\0~\0sq\0~\0¡≤lq\0~t\0\0pq\0~\rsq\0~\0q\0~\rsq\0~\0˚g/q\0~t\0Human_Resource_WF_01_wp1_act11pq\0~\rÙsq\0~\0q\0~\rÙsq\0~\0\03K¸q\0~t\0	wp1_act10pt\0	Conditionsq\0~\r˘\0q\0~&sq\0~\0®‡Ωq\0~t\0\0sq\0~\0w\0\0\0q\0~\0Üsq\0~\0\0q\0~\0Üsq\0~\0\0:Ãoq\0~\'q\0~\0Psq\0~\0E\0\0\0w\0\0\0q\0~\0Pq\0~q\0~q\0~q\0~xxsq\0~\0E\0\0\0w\0\0\0\nq\0~+xt\0Descriptionsq\0~\02\0q\0~/sq\0~\0\0C•,q\0~t\0\0t\0ExtendedAttributessq\0~\0ﬁ\0q\0~3sq\0~\0{q\0~t\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0âˇóq\0~4t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Îöq\0~9t\0JaWE_GRAPH_BREAK_POINTSpq\0~€sq\0~\0\0q\0~€sq\0~\0\0g—ìq\0~9t\0938,473pxsq\0~\0E\0\0\0w\0\0\0\nq\0~>q\0~Axsq\0~“t\0ExtendedAttributesq\0~\0@xq\0~4t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0™\'q\0~Et\0JaWE_GRAPH_TRANSITION_STYLEpq\0~€sq\0~\0\0q\0~€sq\0~\0JˆÁq\0~Et\0NO_ROUTING_ORTHOGONALpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Jq\0~Mxxpxsq\0~\0E\0\0\0w\0\0\0\nq\0~\Zq\0~q\0~ q\0~#q\0~\'q\0~0q\0~4xxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~Rsq\0~\0˜fkq\0~ºt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0\0∏⁄ßq\0~St\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0A¥q\0~Xt\0%JaWE_GRAPH_WORKFLOW_PARTICIPANT_ORDERpq\0~€sq\0~\0\0q\0~€sq\0~\0vø™q\0~Xt\0gHuman_Resource_WF_01_par1;Human_Resource_WF_01_par2;Human_Resource_WF_01_par3;Human_Resource_WF_01_par4pxsq\0~\0E\0\0\0w\0\0\0\nq\0~]q\0~`xsq\0~“t\0ExtendedAttributesq\0~\0!2¶q\0~St\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0Ñ>4q\0~dt\0JaWE_GRAPH_START_OF_WORKFLOWpq\0~€sq\0~\0\0q\0~€sq\0~\0\0ÿôq\0~dt\0≈JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par1,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act6,X_OFFSET=51,Y_OFFSET=59,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=START_DEFAULTpxsq\0~\0E\0\0\0w\0\0\0\nq\0~iq\0~lxsq\0~“t\0ExtendedAttributesq\0~\0\0UJÀq\0~St\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0°Å¥q\0~pt\0\ZJaWE_GRAPH_END_OF_WORKFLOWpq\0~€sq\0~\0\0q\0~€sq\0~\0\0JéŒq\0~pt\0≈JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par4,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act9,X_OFFSET=894,Y_OFFSET=167,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULTpxsq\0~\0E\0\0\0w\0\0\0\nq\0~uq\0~xxsq\0~“t\0ExtendedAttributesq\0~\0\0Â§±q\0~St\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0üåq\0~|t\0\ZJaWE_GRAPH_END_OF_WORKFLOWpq\0~€sq\0~\0\0q\0~€sq\0~\0\0†>q\0~|t\0±JaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par1,CONNECTING_ACTIVITY_ID=wp1_act10,X_OFFSET=1076,Y_OFFSET=62,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULTpxsq\0~\0E\0\0\0w\0\0\0\nq\0~Åq\0~Ñxsq\0~“t\0ExtendedAttributesq\0~\0¸îÑq\0~St\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0ztvq\0~àt\0\ZJaWE_GRAPH_END_OF_WORKFLOWpq\0~€sq\0~\0\0q\0~€sq\0~\0\0t!ˇq\0~àt\0ƒJaWE_GRAPH_PARTICIPANT_ID=Human_Resource_WF_01_par4,CONNECTING_ACTIVITY_ID=Human_Resource_WF_01_wp1_act8,X_OFFSET=889,Y_OFFSET=68,JaWE_GRAPH_TRANSITION_STYLE=NO_ROUTING_ORTHOGONAL,TYPE=END_DEFAULTpxsq\0~\0E\0\0\0w\0\0\0\nq\0~çq\0~êxxpxsq\0~\0E\0\0\0\rw\0\0\0q\0~¡q\0~ƒq\0~»q\0~œq\0~q\0~0q\0~6q\0~‘q\0~⁄q\0~·q\0~Ëq\0~\rﬂq\0~Sxxt\0ExtendedAttributessq\0~\0ﬁ\0q\0~ïsq\0~\0v˚¬q\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsq\0~“t\0ExtendedAttributesq\0~\0/Iq\0~ñt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0cïoq\0~õt\0EDITING_TOOLpq\0~€sq\0~\0\0q\0~€sq\0~\0\0Á∆—q\0~õt\0Workflow Designerpxsq\0~\0E\0\0\0w\0\0\0\nq\0~†q\0~£xsq\0~“t\0ExtendedAttributesq\0~\0\0≠˙,q\0~ñt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0\0jUq\0~ßt\0EDITING_TOOL_VERSIONpq\0~€sq\0~\0\0q\0~€sq\0~\0\0:0q\0~ßt\02.0-2(4?)-C-20080226-2126pxsq\0~\0E\0\0\0w\0\0\0\nq\0~¨q\0~Øxsq\0~“t\0ExtendedAttributesq\0~\0\0%¶Iq\0~ñt\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0»øq\0~≥t\0JaWE_CONFIGURATIONpq\0~€sq\0~\0\0q\0~€sq\0~\0\0Ø∫]q\0~≥t\0defaultpxsq\0~\0E\0\0\0w\0\0\0\nq\0~∏q\0~ªxxpxsq\0~\0E\0\0\0\rw\0\0\0q\0~\0q\0~\0q\0~\0q\0~\0Iq\0~\0tq\0~\0Çq\0~\0ïq\0~\0úq\0~\0£q\0~tq\0~Øq\0~∂q\0~ñx\0sq\0~\0w\0\0\0\0xt\01sr\0*org.enhydra.shark.xpdl.elements.Namespaces|ö—<.Rßñ\0\0xq\0~\0kt\0\nNamespacessq\0~\0î\nq\0~\0\nt\0\0sq\0~\0w\0\0\0\0xsq\0~\0E\0\0\0w\0\0\0\nsr\0)org.enhydra.shark.xpdl.elements.NamespaceËz¬¬_\0\0xq\0~\0t\0	Namespacesq\0~\0k Iq\0~√t\0\0sq\0~\0w\0\0\0q\0~\0sq\0~\0q\0~\0sq\0~\0≠ûq\0~ t\0xpdlpq\0~\0‘sq\0~\0q\0~\0‘sq\0~\0h>Äq\0~ t\0 http://www.wfmc.org/2002/XPDL1.0pxsq\0~\0E\0\0\0w\0\0\0\nq\0~œq\0~“xx','1000014','1','1000015',0);
/*!40000 ALTER TABLE `SHKXPDLData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLHistory`
--

DROP TABLE IF EXISTS `SHKXPDLHistory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLHistory` (
  `XPDLId` varchar(90) NOT NULL,
  `XPDLVersion` varchar(20) NOT NULL,
  `XPDLClassVersion` bigint(20) NOT NULL,
  `XPDLUploadTime` datetime NOT NULL,
  `XPDLHistoryUploadTime` datetime NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLHistory` (`XPDLId`,`XPDLVersion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLHistory`
--

LOCK TABLES `SHKXPDLHistory` WRITE;
/*!40000 ALTER TABLE `SHKXPDLHistory` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLHistory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLHistoryData`
--

DROP TABLE IF EXISTS `SHKXPDLHistoryData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLHistoryData` (
  `XPDLContent` mediumblob NOT NULL,
  `XPDLClassContent` mediumblob NOT NULL,
  `XPDLHistory` decimal(19,0) NOT NULL,
  `CNT` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLHistoryData` (`CNT`),
  KEY `SHKXPDLHistoryData_XPDLHistory` (`XPDLHistory`),
  CONSTRAINT `SHKXPDLHistoryData_XPDLHistory` FOREIGN KEY (`XPDLHistory`) REFERENCES `SHKXPDLHistory` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLHistoryData`
--

LOCK TABLES `SHKXPDLHistoryData` WRITE;
/*!40000 ALTER TABLE `SHKXPDLHistoryData` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLHistoryData` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLParticipantPackage`
--

DROP TABLE IF EXISTS `SHKXPDLParticipantPackage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLParticipantPackage` (
  `PACKAGE_ID` varchar(90) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLParticipantPackage` (`PACKAGE_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLParticipantPackage`
--

LOCK TABLES `SHKXPDLParticipantPackage` WRITE;
/*!40000 ALTER TABLE `SHKXPDLParticipantPackage` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLParticipantPackage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLParticipantProcess`
--

DROP TABLE IF EXISTS `SHKXPDLParticipantProcess`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLParticipantProcess` (
  `PROCESS_ID` varchar(90) NOT NULL,
  `PACKAGEOID` decimal(19,0) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLParticipantProcess` (`PROCESS_ID`,`PACKAGEOID`),
  KEY `SHKXPDLParticipantProcess_PACKAGEOID` (`PACKAGEOID`),
  CONSTRAINT `SHKXPDLParticipantProcess_PACKAGEOID` FOREIGN KEY (`PACKAGEOID`) REFERENCES `SHKXPDLParticipantPackage` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLParticipantProcess`
--

LOCK TABLES `SHKXPDLParticipantProcess` WRITE;
/*!40000 ALTER TABLE `SHKXPDLParticipantProcess` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLParticipantProcess` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLReferences`
--

DROP TABLE IF EXISTS `SHKXPDLReferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLReferences` (
  `ReferredXPDLId` varchar(90) NOT NULL,
  `ReferringXPDL` decimal(19,0) NOT NULL,
  `ReferredXPDLNumber` int(11) NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLReferences` (`ReferredXPDLId`,`ReferringXPDL`),
  KEY `SHKXPDLReferences_ReferringXPDL` (`ReferringXPDL`),
  CONSTRAINT `SHKXPDLReferences_ReferringXPDL` FOREIGN KEY (`ReferringXPDL`) REFERENCES `SHKXPDLS` (`oid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLReferences`
--

LOCK TABLES `SHKXPDLReferences` WRITE;
/*!40000 ALTER TABLE `SHKXPDLReferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `SHKXPDLReferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SHKXPDLS`
--

DROP TABLE IF EXISTS `SHKXPDLS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `SHKXPDLS` (
  `XPDLId` varchar(90) NOT NULL,
  `XPDLVersion` varchar(20) NOT NULL,
  `XPDLClassVersion` bigint(20) NOT NULL,
  `XPDLUploadTime` datetime NOT NULL,
  `oid` decimal(19,0) NOT NULL,
  `version` int(11) NOT NULL,
  PRIMARY KEY (`oid`),
  UNIQUE KEY `I1_SHKXPDLS` (`XPDLId`,`XPDLVersion`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SHKXPDLS`
--

LOCK TABLES `SHKXPDLS` WRITE;
/*!40000 ALTER TABLE `SHKXPDLS` DISABLE KEYS */;
INSERT INTO `SHKXPDLS` VALUES ('Human_Resource_WF_01','1',1184650391000,'2010-06-07 14:15:23','1000014',0);
/*!40000 ALTER TABLE `SHKXPDLS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_department`
--

DROP TABLE IF EXISTS `dir_department`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_department` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `organizationId` varchar(255) DEFAULT NULL,
  `hod` varchar(255) DEFAULT NULL,
  `parentId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKEEE8AA4418CEBAE1` (`organizationId`),
  KEY `FKEEE8AA44EF6BB2B7` (`parentId`),
  KEY `FKEEE8AA4480DB1449` (`hod`),
  CONSTRAINT `FKEEE8AA4418CEBAE1` FOREIGN KEY (`organizationId`) REFERENCES `dir_organization` (`id`),
  CONSTRAINT `FKEEE8AA4480DB1449` FOREIGN KEY (`hod`) REFERENCES `dir_employment` (`id`),
  CONSTRAINT `FKEEE8AA44EF6BB2B7` FOREIGN KEY (`parentId`) REFERENCES `dir_department` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_department`
--

LOCK TABLES `dir_department` WRITE;
/*!40000 ALTER TABLE `dir_department` DISABLE KEYS */;
INSERT INTO `dir_department` VALUES ('D-001','CEO\'s Office','','ORG-001','4028808127f4ef840127f5efdbfb004f',NULL),('D-002','Human Resource & Admin','','ORG-001','4028808127f4ef840127f5f41d4b0091',NULL),('D-003','Finance','','ORG-001','4028808127f4ef840127f606242400b3',NULL),('D-004','Marketing','','ORG-001','4028808127f4ef840127f5f20f36007a',NULL),('D-005','Product Development','','ORG-001','4028808127f4ef840127f5f04dc2005a',NULL),('D-006','Training & Consulting','','ORG-001','4028808127f4ef840127f5f7c5b500a5',NULL),('D-007','Support & Services','','ORG-001','4028808127fb4d350127ff78d63300d1',NULL);
/*!40000 ALTER TABLE `dir_department` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_employment`
--

DROP TABLE IF EXISTS `dir_employment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_employment` (
  `id` varchar(255) NOT NULL,
  `userId` varchar(255) DEFAULT NULL,
  `startDate` date DEFAULT NULL,
  `endDate` date DEFAULT NULL,
  `employeeCode` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `gradeId` varchar(255) DEFAULT NULL,
  `departmentId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKC6620ADE716AE35F` (`departmentId`),
  KEY `FKC6620ADE14CE02E9` (`gradeId`),
  KEY `FKC6620ADECE539211` (`userId`),
  CONSTRAINT `FKC6620ADE14CE02E9` FOREIGN KEY (`gradeId`) REFERENCES `dir_grade` (`id`),
  CONSTRAINT `FKC6620ADE716AE35F` FOREIGN KEY (`departmentId`) REFERENCES `dir_department` (`id`),
  CONSTRAINT `FKC6620ADECE539211` FOREIGN KEY (`userId`) REFERENCES `dir_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_employment`
--

LOCK TABLES `dir_employment` WRITE;
/*!40000 ALTER TABLE `dir_employment` DISABLE KEYS */;
INSERT INTO `dir_employment` VALUES ('4028808127f4ef840127f5efdbfb004f','terry',NULL,NULL,NULL,NULL,'G-001','D-001'),('4028808127f4ef840127f5f04dc2005a','clark',NULL,NULL,NULL,NULL,'G-002','D-005'),('4028808127f4ef840127f5f11cf60068','cat',NULL,NULL,NULL,NULL,'G-003','D-005'),('4028808127f4ef840127f5f194e20071','tana',NULL,NULL,NULL,NULL,'G-003','D-005'),('4028808127f4ef840127f5f20f36007a','roy',NULL,NULL,NULL,NULL,'G-002','D-004'),('4028808127f4ef840127f5f319720088','etta',NULL,NULL,NULL,NULL,'G-003','D-004'),('4028808127f4ef840127f5f41d4b0091','sasha',NULL,NULL,NULL,NULL,'G-002','D-002'),('4028808127f4ef840127f5f7c5b500a5','jack',NULL,NULL,NULL,NULL,'G-002','D-006'),('4028808127f4ef840127f606242400b3','tina',NULL,NULL,NULL,NULL,'G-002','D-003'),('4028808127fb4d350127ff78d63300d1','david',NULL,NULL,NULL,NULL,'G-002','D-007'),('4028808127fb4d350127ff84074600f2','julia',NULL,NULL,NULL,NULL,'G-003','D-002');
/*!40000 ALTER TABLE `dir_employment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_employment_report_to`
--

DROP TABLE IF EXISTS `dir_employment_report_to`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_employment_report_to` (
  `employmentId` varchar(255) NOT NULL,
  `reportToId` varchar(255) NOT NULL,
  `id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`employmentId`,`reportToId`),
  KEY `FK53622945F4068416` (`reportToId`),
  KEY `FK536229452787E613` (`employmentId`),
  CONSTRAINT `FK536229452787E613` FOREIGN KEY (`employmentId`) REFERENCES `dir_employment` (`id`),
  CONSTRAINT `FK53622945F4068416` FOREIGN KEY (`reportToId`) REFERENCES `dir_employment` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_employment_report_to`
--

LOCK TABLES `dir_employment_report_to` WRITE;
/*!40000 ALTER TABLE `dir_employment_report_to` DISABLE KEYS */;
INSERT INTO `dir_employment_report_to` VALUES ('4028808127f4ef840127f5f04dc2005a','4028808127f4ef840127f5efdbfb004f','4028808127f4ef840127f5f04e9b005f'),('4028808127f4ef840127f5f20f36007a','4028808127f4ef840127f5efdbfb004f','4028808127f4ef840127f5f20fb7007f'),('4028808127f4ef840127f5f41d4b0091','4028808127f4ef840127f5efdbfb004f','4028808127f4ef840127f5f48eda009e'),('4028808127f4ef840127f5f7c5b500a5','4028808127f4ef840127f5efdbfb004f','4028808127f4ef840127f5f7c60b00aa'),('4028808127f4ef840127f606242400b3','4028808127f4ef840127f5efdbfb004f','4028808127f4ef840127f60624c100b8'),('4028808127fb4d350127ff78d63300d1','4028808127f4ef840127f5efdbfb004f','4028808127fb4d350127ff78d6fe00d6');
/*!40000 ALTER TABLE `dir_employment_report_to` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_grade`
--

DROP TABLE IF EXISTS `dir_grade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_grade` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `organizationId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKBC9A49A518CEBAE1` (`organizationId`),
  CONSTRAINT `FKBC9A49A518CEBAE1` FOREIGN KEY (`organizationId`) REFERENCES `dir_organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_grade`
--

LOCK TABLES `dir_grade` WRITE;
/*!40000 ALTER TABLE `dir_grade` DISABLE KEYS */;
INSERT INTO `dir_grade` VALUES ('G-001','Board Members','','ORG-001'),('G-002','Managers','','ORG-001'),('G-003','Executives','','ORG-001');
/*!40000 ALTER TABLE `dir_grade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_group`
--

DROP TABLE IF EXISTS `dir_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_group` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_group`
--

LOCK TABLES `dir_group` WRITE;
/*!40000 ALTER TABLE `dir_group` DISABLE KEYS */;
INSERT INTO `dir_group` VALUES ('G-001','Managers',''),('G-002','CxO',''),('G-003','hrAdmin','');
/*!40000 ALTER TABLE `dir_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_organization`
--

DROP TABLE IF EXISTS `dir_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_organization` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `parentId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK55A15FA5961BD498` (`parentId`),
  CONSTRAINT `FK55A15FA5961BD498` FOREIGN KEY (`parentId`) REFERENCES `dir_organization` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_organization`
--

LOCK TABLES `dir_organization` WRITE;
/*!40000 ALTER TABLE `dir_organization` DISABLE KEYS */;
INSERT INTO `dir_organization` VALUES ('ORG-001','Joget.Org','',NULL);
/*!40000 ALTER TABLE `dir_organization` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_role`
--

DROP TABLE IF EXISTS `dir_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_role` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_role`
--

LOCK TABLES `dir_role` WRITE;
/*!40000 ALTER TABLE `dir_role` DISABLE KEYS */;
INSERT INTO `dir_role` VALUES ('ROLE_ADMIN','Admin','Administrator'),('ROLE_USER','User','Normal User');
/*!40000 ALTER TABLE `dir_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_user`
--

DROP TABLE IF EXISTS `dir_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_user` (
  `id` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `timeZone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_user`
--

LOCK TABLES `dir_user` WRITE;
/*!40000 ALTER TABLE `dir_user` DISABLE KEYS */;
INSERT INTO `dir_user` VALUES ('admin','admin','admin','Admin','Admin',NULL,1,NULL),('cat','cat','password','Cat','Grant','',1,'0'),('clark','clark','password','Clark','Kent','',1,'0'),('david','david','password','David','Cain','',1,'0'),('etta','etta','password','Etta','Candy','',1,'0'),('jack','jack','password','Jack','Drake','',1,'0'),('julia','julia','password','Julia','Kapatelis','',1,'0'),('roy','roy','password','Roy','Harper','',1,'0'),('sasha','sasha','password','Sasha','Bordeaux','',1,'0'),('tana','tana','password','Tana','Moon','',1,'0'),('terry','terry','password','Terry','Berg','',1,'0'),('tina','tina','password','Tina','Magee','',1,'0');
/*!40000 ALTER TABLE `dir_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_user_group`
--

DROP TABLE IF EXISTS `dir_user_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_user_group` (
  `groupId` varchar(255) NOT NULL,
  `userId` varchar(255) NOT NULL,
  PRIMARY KEY (`userId`,`groupId`),
  KEY `FK2F0367FD159B6639` (`groupId`),
  KEY `FK2F0367FDCE539211` (`userId`),
  CONSTRAINT `FK2F0367FD159B6639` FOREIGN KEY (`groupId`) REFERENCES `dir_group` (`id`),
  CONSTRAINT `FK2F0367FDCE539211` FOREIGN KEY (`userId`) REFERENCES `dir_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_user_group`
--

LOCK TABLES `dir_user_group` WRITE;
/*!40000 ALTER TABLE `dir_user_group` DISABLE KEYS */;
INSERT INTO `dir_user_group` VALUES ('G-001','clark'),('G-001','david'),('G-001','jack'),('G-001','roy'),('G-001','sasha'),('G-001','tina'),('G-002','terry'),('G-003','julia'),('G-003','sasha');
/*!40000 ALTER TABLE `dir_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dir_user_role`
--

DROP TABLE IF EXISTS `dir_user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dir_user_role` (
  `roleId` varchar(255) NOT NULL,
  `userId` varchar(255) NOT NULL,
  PRIMARY KEY (`userId`,`roleId`),
  KEY `FK5C5FE738C8FE3CA7` (`roleId`),
  KEY `FK5C5FE738CE539211` (`userId`),
  CONSTRAINT `FK5C5FE738C8FE3CA7` FOREIGN KEY (`roleId`) REFERENCES `dir_role` (`id`),
  CONSTRAINT `FK5C5FE738CE539211` FOREIGN KEY (`userId`) REFERENCES `dir_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dir_user_role`
--

LOCK TABLES `dir_user_role` WRITE;
/*!40000 ALTER TABLE `dir_user_role` DISABLE KEYS */;
INSERT INTO `dir_user_role` VALUES ('ROLE_ADMIN','admin'),('ROLE_USER','cat'),('ROLE_USER','clark'),('ROLE_USER','david'),('ROLE_USER','etta'),('ROLE_USER','jack'),('ROLE_USER','julia'),('ROLE_USER','roy'),('ROLE_USER','sasha'),('ROLE_USER','tana'),('ROLE_USER','terry'),('ROLE_USER','tina');
/*!40000 ALTER TABLE `dir_user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_category`
--

DROP TABLE IF EXISTS `form_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_category` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_category`
--

LOCK TABLES `form_category` WRITE;
/*!40000 ALTER TABLE `form_category` DISABLE KEYS */;
INSERT INTO `form_category` VALUES ('HR-001','HR Travel Requisition Forms',NULL);
/*!40000 ALTER TABLE `form_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_form`
--

DROP TABLE IF EXISTS `form_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_form` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `data` text,
  `tableName` varchar(255) DEFAULT NULL,
  `categoryId` varchar(255) DEFAULT NULL,
  `created` date DEFAULT NULL,
  `modified` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK6BD8135F5424A3B7` (`categoryId`),
  CONSTRAINT `FK6BD8135F5424A3B7` FOREIGN KEY (`categoryId`) REFERENCES `form_category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_form`
--

LOCK TABLES `form_form` WRITE;
/*!40000 ALTER TABLE `form_form` DISABLE KEYS */;
INSERT INTO `form_form` VALUES ('HR-TRAVEL-001_ver_1','Travel Requisition Form_ver_1','{\"title\":\"Travel Requisition Form\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"tab\",\"label\":\"Employee Particulars\",\"widgets\":[{\"id\":\"row_13\",\"controls\":[{\"id\":\"readonlytext_13\",\"required\":false,\"label\":\"Travel Requisition Reference Number\",\"description\":\"(System generated ID for this request)\",\"name\":\"refName\",\"type\":\"readonlytext\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"readonlytext\"},{\"id\":\"row_0\",\"controls\":[{\"id\":\"text_0\",\"required\":false,\"label\":\"Full name\",\"description\":\"_\",\"name\":\"full_name\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_1\",\"controls\":[{\"id\":\"text_1\",\"required\":false,\"label\":\"Department\",\"description\":\"_\",\"name\":\"department\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"}]},{\"id\":\"fieldset_1\",\"fieldsetMode\":\"tab\",\"label\":\"Travel Information\",\"widgets\":[{\"id\":\"row_3\",\"controls\":[{\"id\":\"text_3\",\"required\":false,\"label\":\"Origin\",\"description\":\"_\",\"name\":\"travel_origin\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_2\",\"controls\":[{\"id\":\"text_2\",\"required\":false,\"label\":\"Destination\",\"description\":\"_\",\"name\":\"travel_destination\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_5\",\"controls\":[{\"id\":\"textarea_5\",\"required\":false,\"label\":\"Purpose for travel\",\"description\":\"_\",\"name\":\"purpose_for_travel\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"},{\"id\":\"row_6\",\"controls\":[{\"id\":\"radio_6_1\",\"required\":false,\"label\":\"Travel via\",\"description\":\"_\",\"name\":\"travel_via\",\"type\":\"radio\",\"value\":\"Ground|Ground\",\"columnName\":\"columnName_6\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Ground|Ground\"},{\"id\":\"radio_6_2\",\"required\":false,\"label\":\"Travel via\",\"description\":\"_\",\"name\":\"travel_via\",\"type\":\"radio\",\"value\":\"Air|Air\",\"columnName\":\"columnName_6\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Air|Air\"}],\"type\":\"radio\"},{\"id\":\"row_7\",\"controls\":[{\"id\":\"datepicker_7\",\"required\":false,\"label\":\"Departure date\",\"description\":\"_\",\"name\":\"departure_date\",\"type\":\"datepicker\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"dateFormat\":\"dd-M-yy\"}],\"type\":\"datepicker\"},{\"id\":\"row_8\",\"controls\":[{\"id\":\"datepicker_8\",\"required\":false,\"label\":\"Return date\",\"description\":\"_\",\"name\":\"return_date\",\"type\":\"datepicker\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"dateFormat\":\"dd-M-yy\"}],\"type\":\"datepicker\"},{\"id\":\"row_9\",\"controls\":[{\"id\":\"textarea_9\",\"required\":false,\"label\":\"Special request (travel)\",\"description\":\"i.e. flight schedule preference\",\"name\":\"special_request_travel\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"}]},{\"id\":\"fieldset_2\",\"fieldsetMode\":\"tab\",\"label\":\"Accommodation\",\"widgets\":[{\"id\":\"row_11\",\"controls\":[{\"id\":\"radio_11_1\",\"required\":false,\"label\":\"Will you require accommodation?\",\"description\":\"(at the destination)\",\"name\":\"require_accommodation\",\"type\":\"radio\",\"value\":\"Yes|Yes\",\"columnName\":\"columnName_11\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Yes|Yes\"},{\"id\":\"radio_11_2\",\"required\":false,\"label\":\"Will you require accommodation?\",\"description\":\"(at the destination)\",\"name\":\"require_accommodation\",\"type\":\"radio\",\"value\":\"No|No\",\"columnName\":\"columnName_11\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"No|No\"}],\"type\":\"radio\"},{\"id\":\"row_12\",\"controls\":[{\"id\":\"textarea_12\",\"required\":false,\"label\":\"Special request (accommodation)\",\"description\":\"i.e. nights of stay if different, location, hotel\",\"name\":\"special_request_accommodation\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"}]}]}','hr_travel_1','HR-001','2010-04-21','2010-04-21'),('HR-TRAVEL-002_ver_1','Travel Requisition Approval Form_ver_1','{\"title\":\"Travel Requisition Approval Form\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"normal\",\"label\":\"Application Details\",\"widgets\":[{\"id\":\"row_0\",\"controls\":[{\"title\":\"Travel Requisition by #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#\",\"formId\":\"HR-TRAVEL-001_ver_1\",\"mode\":\"normal\",\"isFromParentProcess\":\"false\",\"disabled\":\"true\"}],\"type\":\"subform\"}]},{\"id\":\"fieldset_1\",\"fieldsetMode\":\"normal\",\"label\":\"Head of Department Approval\",\"widgets\":[{\"id\":\"row_2\",\"controls\":[{\"id\":\"radio_2_1\",\"required\":false,\"label\":\"Action\",\"description\":\"Head of Department\'s Decision\",\"name\":\"hod_action\",\"type\":\"radio\",\"value\":\"Approved|Approve Request\",\"columnName\":\"columnName_2\",\"variableName\":\"hod_action\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Approved|Approve Request\"},{\"id\":\"radio_2_2\",\"required\":false,\"label\":\"Action\",\"description\":\"Head of Department\'s Decision\",\"name\":\"hod_action\",\"type\":\"radio\",\"value\":\"Rejected|Reject Request\",\"columnName\":\"columnName_2\",\"variableName\":\"hod_action\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Rejected|Reject Request\"},{\"id\":\"radio_2_3\",\"required\":false,\"label\":\"Action\",\"description\":\"Head of Department\'s Decision\",\"name\":\"hod_action\",\"type\":\"radio\",\"value\":\"Resubmit|Request for Resubmission\",\"columnName\":\"columnName_2\",\"variableName\":\"hod_action\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Resubmit|Request for Resubmission\"}],\"type\":\"radio\"},{\"id\":\"row_3\",\"controls\":[{\"id\":\"textarea_3\",\"required\":false,\"label\":\"Comments\",\"description\":\"(including instructions for travel arrangements)\",\"name\":\"hod_comments\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"}]}]}','hr_travel_1','HR-001','2010-04-21','2010-04-21'),('HR-TRAVEL-003_ver_1','Travel Requisition - Arrangement Form_ver_1','{\"title\":\"Travel Arrangement for #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"normal\",\"label\":\"Travel Request by  #performer.wp1_act1.firstName# #performer.wp1_act1.lastName#\",\"widgets\":[{\"id\":\"row_0\",\"controls\":[{\"title\":\"Travel Request Form\",\"formId\":\"HR-TRAVEL-001_ver_1\",\"mode\":\"normal\",\"isFromParentProcess\":\"false\",\"disabled\":\"true\"}],\"type\":\"subform\"}]},{\"id\":\"fieldset_1\",\"fieldsetMode\":\"normal\",\"label\":\"Approval Information (Approved by  #performer.wp1_act2.firstName# #performer.wp1_act2.lastName#)\",\"widgets\":[{\"id\":\"row_1\",\"controls\":[{\"id\":\"textarea_1\",\"required\":false,\"label\":\"Comments\",\"description\":\"_\",\"name\":\"hod_comments\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"}]},{\"id\":\"fieldset_2\",\"fieldsetMode\":\"normal\",\"label\":\"Travel Arrangements Made\",\"widgets\":[{\"id\":\"row_3\",\"controls\":[{\"id\":\"text_3\",\"required\":false,\"label\":\"Departure information\",\"description\":\"Flight Number, etc.\",\"name\":\"departure_information_actual\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_4\",\"controls\":[{\"id\":\"datepicker_4\",\"required\":false,\"label\":\"Departure date\",\"description\":\"_\",\"name\":\"departure_date_actual\",\"type\":\"datepicker\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"dateFormat\":\"dd-M-yy\"}],\"type\":\"datepicker\"},{\"id\":\"row_5\",\"controls\":[{\"id\":\"text_5\",\"required\":false,\"label\":\"Departure time\",\"description\":\"_\",\"name\":\"departure_time_actual\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_6\",\"controls\":[{\"id\":\"text_6\",\"required\":false,\"label\":\"Return information\",\"description\":\"Flight Number, etc.\",\"name\":\"return_information_actual\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_7\",\"controls\":[{\"id\":\"datepicker_7\",\"required\":false,\"label\":\"Return date\",\"description\":\"_\",\"name\":\"return_date_actual\",\"type\":\"datepicker\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"dateFormat\":\"dd-M-yy\"}],\"type\":\"datepicker\"},{\"id\":\"row_8\",\"controls\":[{\"id\":\"text_8\",\"required\":false,\"label\":\"Return time\",\"description\":\"_\",\"name\":\"return_time_actual\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_9\",\"controls\":[{\"id\":\"radio_9_1\",\"required\":false,\"label\":\"Accommodation arrangements made\",\"description\":\"select whether accommodation booked\",\"name\":\"accommodation_actual\",\"type\":\"radio\",\"value\":\"Yes|Yes\",\"columnName\":\"columnName_9\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"Yes|Yes\"},{\"id\":\"radio_9_2\",\"required\":false,\"label\":\"Accommodation arrangements made\",\"description\":\"select whether accommodation booked\",\"name\":\"accommodation_actual\",\"type\":\"radio\",\"value\":\"No|No\",\"columnName\":\"columnName_9\",\"variableName\":\"\",\"formVariableId\":\"\",\"ignoreVariableIfEmpty\":\"false\",\"radioLabel\":\"No|No\"}],\"type\":\"radio\"},{\"id\":\"row_11\",\"controls\":[{\"id\":\"text_11\",\"required\":false,\"label\":\"Hotel name\",\"description\":\"_\",\"name\":\"hotel_name\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"},{\"id\":\"row_12\",\"controls\":[{\"id\":\"textarea_12\",\"required\":false,\"label\":\"Hotel information\",\"description\":\"i.e. address, website\",\"name\":\"hotel_information\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"},{\"id\":\"row_13\",\"controls\":[{\"id\":\"text_13\",\"required\":false,\"label\":\"Booking reference number\",\"description\":\"Where available\",\"name\":\"hotel_reference_number\",\"type\":\"text\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\",\"ignoreVariableIfEmpty\":\"false\"}],\"type\":\"text\"}]}]}','hr_travel_1','HR-001','2010-04-21','2010-04-21'),('HR-TRAVEL-004_ver_1','Travel Requisition Resubmission Form_ver_1','{\"title\":\"Travel Requisition Resubmission Form\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"normal\",\"label\":\"Head of Department\'s Comments\",\"widgets\":[{\"id\":\"row_0\",\"controls\":[{\"id\":\"textarea_0\",\"required\":false,\"label\":\"Comments by #performer.wp1_act2.firstName# #performer.wp1_act2.lastName#\",\"description\":\"_\",\"name\":\"hod_comments\",\"type\":\"textarea\",\"value\":\"\",\"columnName\":\"\",\"variableName\":\"\",\"inputValidation\":\"\",\"inputValidationMessage\":\"\"}],\"type\":\"textarea\"}]},{\"id\":\"fieldset_1\",\"fieldsetMode\":\"normal\",\"label\":\"Resubmission Form\",\"widgets\":[{\"id\":\"row_1\",\"controls\":[{\"title\":\"Travel Requisition Form\",\"formId\":\"HR-TRAVEL-001_ver_1\",\"mode\":\"normal\",\"isFromParentProcess\":\"false\",\"disabled\":\"false\"}],\"type\":\"subform\"}]}]}','hr_travel_1','HR-001','2010-04-21','2010-04-21'),('HR-TRAVEL-005_ver_1','Travel Request Approval Details Form_ver_1','{\"title\":\"Travel Request Approved\",\"fieldsets\":[{\"id\":\"fieldset_0\",\"fieldsetMode\":\"normal\",\"label\":\"Travel Arrangement\",\"widgets\":[{\"id\":\"row_1\",\"controls\":[{\"title\":\"Details\",\"formId\":\"HR-TRAVEL-003_ver_1\",\"mode\":\"normal\",\"isFromParentProcess\":\"false\",\"disabled\":\"true\"}],\"type\":\"subform\"}]}]}','hr_travel_1','HR-001','2010-04-21','2010-04-21');
/*!40000 ALTER TABLE `form_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `form_variable`
--

DROP TABLE IF EXISTS `form_variable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `form_variable` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `pluginName` varchar(255) DEFAULT NULL,
  `pluginProperties` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `form_variable`
--

LOCK TABLES `form_variable` WRITE;
/*!40000 ALTER TABLE `form_variable` DISABLE KEYS */;
/*!40000 ALTER TABLE `form_variable` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `objectid`
--

DROP TABLE IF EXISTS `objectid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `objectid` (
  `nextoid` decimal(19,0) NOT NULL,
  PRIMARY KEY (`nextoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `objectid`
--

LOCK TABLES `objectid` WRITE;
/*!40000 ALTER TABLE `objectid` DISABLE KEYS */;
INSERT INTO `objectid` VALUES ('1000200');
/*!40000 ALTER TABLE `objectid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_activity_application`
--

DROP TABLE IF EXISTS `wf_activity_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_activity_application` (
  `id` varchar(255) NOT NULL,
  `processId` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `activityId` varchar(255) DEFAULT NULL,
  `customClass` varchar(255) DEFAULT NULL,
  `customScript` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_activity_application`
--

LOCK TABLES `wf_activity_application` WRITE;
/*!40000 ALTER TABLE `wf_activity_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_activity_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_activity_form`
--

DROP TABLE IF EXISTS `wf_activity_form`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_activity_form` (
  `id` varchar(255) NOT NULL,
  `processId` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `activityId` varchar(255) DEFAULT NULL,
  `formId` varchar(255) DEFAULT NULL,
  `formUrl` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `formIFrameStyle` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_activity_form`
--

LOCK TABLES `wf_activity_form` WRITE;
/*!40000 ALTER TABLE `wf_activity_form` DISABLE KEYS */;
INSERT INTO `wf_activity_form` VALUES ('ff8080812911011b0129110c96e30008','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'wp1_act1','HR-TRAVEL-001_ver_1',NULL,'SINGLE',NULL),('ff8080812911011b0129110c97190009','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'wp1_act2','HR-TRAVEL-002_ver_1',NULL,'SINGLE',NULL),('ff8080812911011b0129110c9745000a','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'wp1_act3','HR-TRAVEL-003_ver_1',NULL,'SINGLE',NULL),('ff8080812911011b0129110c9772000b','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'wp1_act4','HR-TRAVEL-004_ver_1',NULL,'SINGLE',NULL),('ff8080812911011b0129110c97a0000c','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'wp1_act10','HR-TRAVEL-005_ver_1',NULL,'SINGLE',NULL);
/*!40000 ALTER TABLE `wf_activity_form` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_activity_plugin`
--

DROP TABLE IF EXISTS `wf_activity_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_activity_plugin` (
  `id` varchar(255) NOT NULL,
  `processId` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `activityId` varchar(255) DEFAULT NULL,
  `pluginName` varchar(255) DEFAULT NULL,
  `pluginProperties` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_activity_plugin`
--

LOCK TABLES `wf_activity_plugin` WRITE;
/*!40000 ALTER TABLE `wf_activity_plugin` DISABLE KEYS */;
INSERT INTO `wf_activity_plugin` VALUES ('ff8080812911011b0129110c98810010','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1',1,'Human_Resource_WF_01_wp1_act5','org.joget.plugin.referenceid.ReferenceIdPlugin','\"noOfDigit\",\"5\"\n\"prefix\",\"HR-TR-\"\n\"variableId\",\"\"\n\"formDataTable\",\"hr_travel_1\"\n');
/*!40000 ALTER TABLE `wf_activity_plugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_audit_trail`
--

DROP TABLE IF EXISTS `wf_audit_trail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_audit_trail` (
  `id` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `clazz` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `message` text,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_audit_trail`
--

LOCK TABLES `wf_audit_trail` WRITE;
/*!40000 ALTER TABLE `wf_audit_trail` DISABLE KEYS */;
INSERT INTO `wf_audit_trail` VALUES ('ff8080812911011b0129110c92c60006','admin','org.joget.workflow.model.service.WorkflowManagerImpl','processUploadWithoutUpdateMapping',NULL,'2010-06-07 14:15:23'),('ff8080812911011b0129110c93360007','admin','org.joget.workflow.model.service.WorkflowManagerImpl','processUploadWithoutUpdateMapping',NULL,'2010-06-07 14:15:23');
/*!40000 ALTER TABLE `wf_audit_trail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_audit_trail_plugin`
--

DROP TABLE IF EXISTS `wf_audit_trail_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_audit_trail_plugin` (
  `pluginName` varchar(255) NOT NULL,
  `pluginProperties` text,
  PRIMARY KEY (`pluginName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_audit_trail_plugin`
--

LOCK TABLES `wf_audit_trail_plugin` WRITE;
/*!40000 ALTER TABLE `wf_audit_trail_plugin` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_audit_trail_plugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_participant_directory`
--

DROP TABLE IF EXISTS `wf_participant_directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_participant_directory` (
  `id` varchar(255) NOT NULL,
  `packageId` varchar(255) DEFAULT NULL,
  `processId` varchar(255) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `participantId` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `value` text,
  `pluginProperties` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_participant_directory`
--

LOCK TABLES `wf_participant_directory` WRITE;
/*!40000 ALTER TABLE `wf_participant_directory` DISABLE KEYS */;
INSERT INTO `wf_participant_directory` VALUES ('ff8080812911011b0129110c97dc000d','Human_Resource_WF_01',NULL,1,'Human_Resource_WF_01_par1','REQUESTER','runProcess',NULL),('ff8080812911011b0129110c9813000e','Human_Resource_WF_01',NULL,1,'Human_Resource_WF_01_par2','REQUESTER_HOD','wp1_act1',NULL),('ff8080812911011b0129110c984c000f','Human_Resource_WF_01',NULL,1,'Human_Resource_WF_01_par3','DEPARTMENT','D-002',NULL);
/*!40000 ALTER TABLE `wf_participant_directory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_plugin_default`
--

DROP TABLE IF EXISTS `wf_plugin_default`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_plugin_default` (
  `pluginName` varchar(255) NOT NULL,
  `pluginProperties` text,
  PRIMARY KEY (`pluginName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_plugin_default`
--

LOCK TABLES `wf_plugin_default` WRITE;
/*!40000 ALTER TABLE `wf_plugin_default` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_plugin_default` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_process_link`
--

DROP TABLE IF EXISTS `wf_process_link`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_process_link` (
  `processId` varchar(255) NOT NULL,
  `parentProcessId` varchar(255) DEFAULT NULL,
  `originProcessId` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`processId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_process_link`
--

LOCK TABLES `wf_process_link` WRITE;
/*!40000 ALTER TABLE `wf_process_link` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_process_link` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_report`
--

DROP TABLE IF EXISTS `wf_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_report` (
  `activityInstanceId` varchar(255) NOT NULL,
  `processInstanceId` varchar(255) DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `createdTime` datetime DEFAULT NULL,
  `startedTime` datetime DEFAULT NULL,
  `dateLimit` bigint(20) DEFAULT NULL,
  `due` datetime DEFAULT NULL,
  `delay` bigint(20) DEFAULT NULL,
  `finishTime` datetime DEFAULT NULL,
  `timeConsumingFromDateCreated` bigint(20) DEFAULT NULL,
  `timeConsumingFromDateStarted` bigint(20) DEFAULT NULL,
  `performer` varchar(255) DEFAULT NULL,
  `nameOfAcceptedUser` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `packageId` varchar(255) DEFAULT NULL,
  `processDefId` varchar(255) DEFAULT NULL,
  `activityDefId` varchar(255) DEFAULT NULL,
  `assignmentUsers` text,
  PRIMARY KEY (`activityInstanceId`),
  KEY `FKB943CCA47A4E8F48` (`packageId`),
  KEY `FKB943CCA4A39D6461` (`processDefId`),
  KEY `FKB943CCA4CB863F` (`activityDefId`),
  CONSTRAINT `FKB943CCA47A4E8F48` FOREIGN KEY (`packageId`) REFERENCES `wf_report_package` (`packageId`),
  CONSTRAINT `FKB943CCA4A39D6461` FOREIGN KEY (`processDefId`) REFERENCES `wf_report_process` (`processDefId`),
  CONSTRAINT `FKB943CCA4CB863F` FOREIGN KEY (`activityDefId`) REFERENCES `wf_report_activity` (`activityDefId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_report`
--

LOCK TABLES `wf_report` WRITE;
/*!40000 ALTER TABLE `wf_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_report_activity`
--

DROP TABLE IF EXISTS `wf_report_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_report_activity` (
  `activityDefId` varchar(255) NOT NULL,
  `activityName` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`activityDefId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_report_activity`
--

LOCK TABLES `wf_report_activity` WRITE;
/*!40000 ALTER TABLE `wf_report_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_report_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_report_package`
--

DROP TABLE IF EXISTS `wf_report_package`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_report_package` (
  `packageId` varchar(255) NOT NULL,
  `packageName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`packageId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_report_package`
--

LOCK TABLES `wf_report_package` WRITE;
/*!40000 ALTER TABLE `wf_report_package` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_report_package` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_report_process`
--

DROP TABLE IF EXISTS `wf_report_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_report_process` (
  `processDefId` varchar(255) NOT NULL,
  `processName` varchar(255) DEFAULT NULL,
  `version` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`processDefId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_report_process`
--

LOCK TABLES `wf_report_process` WRITE;
/*!40000 ALTER TABLE `wf_report_process` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_report_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_resource_bundle_message`
--

DROP TABLE IF EXISTS `wf_resource_bundle_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_resource_bundle_message` (
  `id` varchar(255) NOT NULL,
  `messageKey` varchar(255) DEFAULT NULL,
  `locale` varchar(255) DEFAULT NULL,
  `message` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_resource_bundle_message`
--

LOCK TABLES `wf_resource_bundle_message` WRITE;
/*!40000 ALTER TABLE `wf_resource_bundle_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_resource_bundle_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_setup`
--

DROP TABLE IF EXISTS `wf_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_setup` (
  `id` varchar(255) NOT NULL,
  `property` varchar(255) DEFAULT NULL,
  `value` text,
  `ordering` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_setup`
--

LOCK TABLES `wf_setup` WRITE;
/*!40000 ALTER TABLE `wf_setup` DISABLE KEYS */;
/*!40000 ALTER TABLE `wf_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_userview_process`
--

DROP TABLE IF EXISTS `wf_userview_process`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_userview_process` (
  `id` varchar(255) NOT NULL,
  `processDefId` varchar(255) DEFAULT NULL,
  `categoryId` varchar(255) DEFAULT NULL,
  `activityDefId` varchar(255) DEFAULT NULL,
  `activityLabel` varchar(255) DEFAULT NULL,
  `sequence` int(11) DEFAULT NULL,
  `tableName` varchar(255) DEFAULT NULL,
  `tableColumn` text,
  `activityFormId` varchar(255) DEFAULT NULL,
  `activityFormUrl` text,
  `filter` varchar(255) DEFAULT NULL,
  `sort` varchar(255) DEFAULT NULL,
  `viewType` int(11) DEFAULT NULL,
  `permType` int(11) DEFAULT NULL,
  `mappingType` varchar(255) DEFAULT NULL,
  `mappingValue` varchar(255) DEFAULT NULL,
  `header` text,
  `footer` text,
  `createdBy` varchar(255) DEFAULT NULL,
  `createdOn` date DEFAULT NULL,
  `modifiedBy` varchar(255) DEFAULT NULL,
  `modifiedOn` date DEFAULT NULL,
  `userviewSetupId` varchar(255) DEFAULT NULL,
  `buttonSaveLabel` varchar(255) DEFAULT NULL,
  `buttonWithdrawLabel` varchar(255) DEFAULT NULL,
  `buttonCompleteLabel` varchar(255) DEFAULT NULL,
  `buttonCancelLabel` varchar(255) DEFAULT NULL,
  `buttonSaveShow` int(11) DEFAULT NULL,
  `buttonWithdrawShow` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK8070990F016ACB5` (`userviewSetupId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_userview_process`
--

LOCK TABLES `wf_userview_process` WRITE;
/*!40000 ALTER TABLE `wf_userview_process` DISABLE KEYS */;
INSERT INTO `wf_userview_process` VALUES ('ff8080812911011b0129110c99c60011','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271240319427','wp1_act2','Travel Request Approval',3,'hr_travel_1','refName:Ref., full_name:Requester, department:Department, departure_date:Travel Date, travel_destination:Destination, hod_action:Status',NULL,NULL,'hod_action','departure_date, hod_action',0,1,'GROUP','G-002,G-001',NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL),('ff8080812911011b0129110c99fe0012','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271240097938','wp1_act3','Arrange Travel Requests',4,'hr_travel_1','refName:Ref., department:Department, full_name:Requester, departure_date:Departure, travel_destination:Destination, require_accommodation:Accommodation Req.',NULL,NULL,'department, full_name','departure_date',0,1,'GROUP','G-003',NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL),('ff8080812911011b0129110c9a2a0013','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271239677528','wp1_act1','Travel Request Listing',0,'hr_travel_1','refName:Ref., full_name:Requester, department:Department, departure_date:Travel Date, travel_destination:Destination, hod_action:Status',NULL,NULL,NULL,NULL,0,0,'GROUP',NULL,NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL),('ff8080812911011b0129110c9a570014','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271239677528','wp1_act10','Travel Arrangements',1,'hr_travel_1','refName:Ref., full_name:Requester, departure_date:Travel Date, travel_destination:Destination',NULL,NULL,NULL,NULL,0,1,'GROUP',NULL,NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL),('ff8080812911011b0129110c9a840015','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271833697825','wp1_act10','Employee Travel Record',5,'hr_travel_1','refName:Ref., full_name:Employee Name, department:Department, travel_destination:Destination, departure_date_actual:Departure Date, return_date_actual:Return Date, hod_action:Status',NULL,NULL,'department','refName, departure_date_actual',0,2,'GROUP','G-002',NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL),('ff8080812911011b0129110c9ab00016','Human_Resource_WF_01#1#Human_Resource_WF_01_wp1','1271239677528','wp1_act4','Travel Requests to Resubmit',2,'hr_travel_1','refName:Ref., full_name:Requester, department:Department, departure_date:Travel Date, hod_action:Status, hod_comments:Comments',NULL,NULL,'hod_action','refName, departure_date, hod_action',1,1,'GROUP',NULL,NULL,NULL,'admin','2010-04-21',NULL,NULL,'UV-HR-001',NULL,NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `wf_userview_process` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wf_userview_setup`
--

DROP TABLE IF EXISTS `wf_userview_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `wf_userview_setup` (
  `id` varchar(255) NOT NULL,
  `setupName` varchar(255) DEFAULT NULL,
  `startProcessDefId` varchar(255) DEFAULT NULL,
  `startProcessLabel` varchar(255) DEFAULT NULL,
  `inboxLabel` varchar(255) DEFAULT NULL,
  `header` text,
  `footer` text,
  `menu` text,
  `css` text,
  `cssLink` varchar(255) DEFAULT NULL,
  `categories` varchar(255) DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `createdOn` date DEFAULT NULL,
  `modifiedBy` varchar(255) DEFAULT NULL,
  `modifiedOn` date DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `runProcessDirectly` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wf_userview_setup`
--

LOCK TABLES `wf_userview_setup` WRITE;
/*!40000 ALTER TABLE `wf_userview_setup` DISABLE KEYS */;
INSERT INTO `wf_userview_setup` VALUES ('UV-HR-001','Joget.Org: Travel Management Console','Human_Resource_WF_01%231%23Human_Resource_WF_01_wp1','Create New Travel Request','My Pending Tasks',NULL,NULL,NULL,NULL,NULL,'1271239677528:My Travel Requests,1271240319427:Travel Request Approval,1271240097938:Travel Administration,1271833697825:CxO Report,','admin','2010-04-21',NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `wf_userview_setup` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-06-07 14:15:38

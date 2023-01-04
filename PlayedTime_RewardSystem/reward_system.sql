/*
Navicat MySQL Data Transfer

Source Server         : JadaLocalhost
Source Server Version : 50711
Source Host           : localhost:3306
Source Database       : characters

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2023-01-04 18:13:05
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for reward_system
-- ----------------------------
DROP TABLE IF EXISTS `reward_system`;
CREATE TABLE `reward_system` (
  `character_guid` int(11) NOT NULL,
  `obtained` varchar(255) NOT NULL,
  `reward_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

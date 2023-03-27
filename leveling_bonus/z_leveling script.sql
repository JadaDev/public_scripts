/*

Made by JADADEV - JADA#2723

Navicat MySQL Data Transfer

Source Server         : JadaLocalhost
Source Server Version : 50711
Source Host           : localhost:3306
Source Database       : world

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2023-03-27 15:15:58
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for z_leveling_bonus
-- ----------------------------
DROP TABLE IF EXISTS `z_leveling_bonus`;
CREATE TABLE `z_leveling_bonus` (
  `level` smallint(5) unsigned NOT NULL,
  `item` varchar(255) NOT NULL,
  `count` varchar(255) NOT NULL DEFAULT '1',
  `money` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of z_leveling_bonus
-- ----------------------------
INSERT INTO `z_leveling_bonus` VALUES ('5', '4824,4306,4338', '1,100,100', '115241');
INSERT INTO `z_leveling_bonus` VALUES ('10', '1483', '1', '145151');
INSERT INTO `z_leveling_bonus` VALUES ('15', '2078', '1', '1251151');
INSERT INTO `z_leveling_bonus` VALUES ('20', '4238', '1', '1515151');
INSERT INTO `z_leveling_bonus` VALUES ('25', '6632', '1', '1151');
INSERT INTO `z_leveling_bonus` VALUES ('30', '12958', '2', '451');
INSERT INTO `z_leveling_bonus` VALUES ('35', '20906', '1', '2231');
INSERT INTO `z_leveling_bonus` VALUES ('40', '4074', '1', '221215');
INSERT INTO `z_leveling_bonus` VALUES ('45', '17223', '1', '15151');
INSERT INTO `z_leveling_bonus` VALUES ('50', '16802', '3', '2155151');
INSERT INTO `z_leveling_bonus` VALUES ('55', '23517', '1', '23325');
INSERT INTO `z_leveling_bonus` VALUES ('60', '19362', '1', '55114');
INSERT INTO `z_leveling_bonus` VALUES ('65', '30305', '1', '111');
INSERT INTO `z_leveling_bonus` VALUES ('70', '30888', '1', '2251');
INSERT INTO `z_leveling_bonus` VALUES ('75', '35594,51809', '1,1', '1584584');
INSERT INTO `z_leveling_bonus` VALUES ('80', '45087,36942', '1,1', '145158');

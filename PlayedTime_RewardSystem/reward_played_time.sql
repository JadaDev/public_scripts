/*
Navicat MySQL Data Transfer

Source Server         : JadaLocalhost
Source Server Version : 50711
Source Host           : localhost:3306
Source Database       : characters

Target Server Type    : MYSQL
Target Server Version : 50711
File Encoding         : 65001

Date: 2023-01-04 18:13:13
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for reward_played_time
-- ----------------------------
DROP TABLE IF EXISTS `reward_played_time`;
CREATE TABLE `reward_played_time` (
  `id` varchar(255) DEFAULT NULL,
  `played_time` int(11) DEFAULT NULL,
  `reward_item_id` int(11) DEFAULT NULL,
  `reward_item_amount` varchar(255) DEFAULT NULL,
  `reward_gold_amount` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of reward_played_time
-- ----------------------------
INSERT INTO `reward_played_time` VALUES ('1', '1800', '60999', '50', '100', 'Thank you for playing on our server, You have received a reward due to your 30 Minutes dedication toward our server.');
INSERT INTO `reward_played_time` VALUES ('2', '9000', '60999', '200', '500', 'You\'ve been playing for 2 Hours and 30 Minutes on our server, here\'s your reward.');
INSERT INTO `reward_played_time` VALUES ('3', '86400', '60999', '500', '5000', 'You have achived 1 Day playing on our server, Thank you for your dedicated. Please check your reward.');

-- MariaDB dump 10.19  Distrib 10.11.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: nugget.bloom.host    Database: s59454_dragoncotewebsitatssurvival
-- ------------------------------------------------------
-- Server version	10.11.6-MariaDB-0+deb12u1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `player_inventories`
--

DROP TABLE IF EXISTS `player_inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_inventories` (
  `player_name` varchar(64) NOT NULL,
  `slot` int(11) NOT NULL,
  `item_type` varchar(255) DEFAULT NULL,
  `item_amount` int(11) DEFAULT NULL,
  `item_texture` text DEFAULT NULL,
  `item_tooltip` text DEFAULT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`player_name`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_inventories`
--

LOCK TABLES `player_inventories` WRITE;
/*!40000 ALTER TABLE `player_inventories` DISABLE KEYS */;
INSERT INTO `player_inventories` VALUES
('AS82',0,'POLISHED_DIORITE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_polished_diorite.png','Polished Diorite','2026-04-10 15:37:20'),
('AS82',1,'LIGHT_GRAY_WOOL',1,'https://mc.nerothe.com/img/1.21.8/minecraft_light_gray_wool.png','Light Gray Wool','2026-04-10 15:37:20'),
('AS82',2,'CROSSBOW',1,'https://mc.nerothe.com/img/1.21.8/minecraft_crossbow.png','<span style=\'color:#FFFFFF\'></span><span style=\'color:#AA0000\'>🏹 <span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span></span><span style=\'color:#BD0000\'> </span><span style=\'color:#A50010\'>.</span><span style=\'color:#8E0020\'>.</span><span style=\'color:#760030\'>=</span><span style=\'color:#5F0040\'>.</span><span style=\'color:#470050\'>.</span><span style=\'color:#300060\'>=</span><span style=\'color:#180070\'>)<span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'><span class=\'obfuscated\'></span></span></span></span><span style=\'color:#BD0000\'>.</span><span style=\'color:#A80C02\'>.</span><span style=\'color:#931905\'>.</span><span style=\'color:#7E2507\'>.</span><span style=\'color:#69320A\'>.</span><span style=\'color:#543E0C\'>.</span><span style=\'color:#3F4B0F\'>.</span><span style=\'color:#2A5711\'>.</span><span style=\'color:#156414\'>.</span><span style=\'color:#007016\'>.<span style=\'font-weight:bold;\'></span></span><span style=\'color:#06B800\'>L</span><span style=\'color:#06B20A\'>e</span><span style=\'color:#05AB14\'>v</span><span style=\'color:#05A51F\'>i</span><span style=\'color:#059F29\'>a</span><span style=\'color:#049833\'>t</span><span style=\'color:#04923D\'>h</span><span style=\'color:#048C48\'>a</span><span style=\'color:#038552\'>n<span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'><span class=\'obfuscated\'></span></span></span></span><span style=\'color:#007016\'>.</span><span style=\'color:#156414\'>.</span><span style=\'color:#2A5711\'>.</span><span style=\'color:#3F4B0F\'>.</span><span style=\'color:#543E0C\'>.</span><span style=\'color:#69320A\'>.</span><span style=\'color:#7E2507\'>.</span><span style=\'color:#931905\'>.</span><span style=\'color:#A80C02\'>.</span><span style=\'color:#BD0000\'>.<span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span></span><span style=\'color:#180070\'>(</span><span style=\'color:#300060\'>=</span><span style=\'color:#470050\'>.</span><span style=\'color:#5F0040\'>.</span><span style=\'color:#760030\'>=</span><span style=\'color:#8E0020\'>.</span><span style=\'color:#A50010\'>.</span><span style=\'color:#BD0000\'> </span> <span style=\'color:#AA0000\'>🏹</span><br><span style=\'color:#AAAAAA\'>Mending 1</span><br><span style=\'color:#AAAAAA\'>Multishot 1</span><br><span style=\'color:#AAAAAA\'>Piercing 3</span><br><span style=\'color:#AAAAAA\'>Quick Charge 1</span><br><span style=\'color:#AAAAAA\'>Unbreaking 4</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#FFFFFF\'><span style=\'font-style:italic;\'>Serpent of the abyss</span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#C20000\'>B</span><span style=\'color:#BC0909\'>l</span><span style=\'color:#B61212\'>a</span><span style=\'color:#B01B1B\'>c</span><span style=\'color:#AA2424\'>k</span><span style=\'color:#A42D2D\'>B</span><span style=\'color:#9E3636\'>l</span><span style=\'color:#993F3F\'>o</span><span style=\'color:#934848\'>o</span><span style=\'color:#8D5151\'>d</span><span style=\'color:#875A5A\'>P</span><span style=\'color:#816363\'>a</span><span style=\'color:#7B6C6C\'>c</span><span style=\'color:#757575\'>k</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---=---=---=---*</span></span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#AAAAAA\'><span style=\'text-decoration:line-through;\'>= </span></span> <span style=\'color:#FF5555\'>Skill: </span><span style=\'color:#AA0000\'>Mortal sins</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#AAAAAA\'><span style=\'text-decoration:line-through;\'>= </span></span> <span style=\'color:#FF5555\'>Skill: </span><span style=\'color:#AA0000\'>Blood downpour</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---=---=---=---*</span></span></span>','2026-04-10 15:37:20'),
('AS82',3,'WOODEN_AXE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_wooden_axe.png','Wooden Axe','2026-04-10 15:37:20'),
('AS82',4,'CYAN_TERRACOTTA',1,'https://mc.nerothe.com/img/1.21.8/minecraft_cyan_terracotta.png','Cyan Terracotta','2026-04-10 15:37:20'),
('AS82',5,'NETHERITE_SWORD',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_sword.png','Netherite Sword<br><span style=\'color:#AAAAAA\'>Sharpness 50</span>','2026-04-10 15:37:20'),
('AS82',6,'ENCHANTED_GOLDEN_APPLE',64,'https://mc.nerothe.com/img/1.21.8/minecraft_enchanted_golden_apple.png','Enchanted Golden Apple','2026-04-10 15:37:20'),
('AS82',7,'ENCHANTED_GOLDEN_APPLE',64,'https://mc.nerothe.com/img/1.21.8/minecraft_enchanted_golden_apple.png','Enchanted Golden Apple','2026-04-10 15:37:20'),
('AS82',8,'ENCHANTED_GOLDEN_APPLE',8,'https://mc.nerothe.com/img/1.21.8/minecraft_enchanted_golden_apple.png','Enchanted Golden Apple','2026-04-10 15:37:20'),
('AS82',9,'SLIME_BLOCK',2,'https://mc.nerothe.com/img/1.21.8/minecraft_slime_block.png','<span style=\'color:#55FF55\'><span style=\'font-weight:bold;\'>Custom Jump Pad</span></span><br><span style=\'color:#555555\'>Custom Launch Device</span><br><span style=\'color:#AAAAAA\'>Distance: 200</span>','2026-04-10 15:37:20'),
('AS82',10,'WAXED_OXIDIZED_COPPER_BULB',1,'https://mc.nerothe.com/img/1.21.8/minecraft_waxed_oxidized_copper_bulb.png','Waxed Oxidized Copper Bulb','2026-04-10 15:37:20'),
('AS82',11,'SPRUCE_PLANKS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_spruce_planks.png','Spruce Planks','2026-04-10 15:37:20'),
('AS82',12,'COW_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_cow_spawn_egg.png','<span style=\'color:#FF5555\'>statue</span>','2026-04-10 15:37:20'),
('AS82',13,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>TornObelisk</span>','2026-04-10 15:37:20'),
('AS82',14,'NETHERITE_LEGGINGS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_leggings.png','<span style=\'color:#FFFFFF\'></span><span style=\'color:#FF5555\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><span style=\'color:#AA0000\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*<span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span></span></span></span><span style=\'color:#525252\'> </span><span style=\'color:#5E5E5E\'>=</span><span style=\'color:#6B6B6B\'>.</span><span style=\'color:#777777\'>,</span><span style=\'color:#838383\'>.</span><span style=\'color:#909090\'>=</span><span style=\'color:#9C9C9C\'>(</span><span style=\'color:#A9A9A9\'> </span><span style=\'color:#B5B5B5\'>)</span><span style=\'color:#C1C1C1\'>=</span><span style=\'color:#CECECE\'>.</span><span style=\'color:#DADADA\'>,</span><span style=\'color:#E6E6E6\'>.</span><span style=\'color:#F3F3F3\'>=</span><span style=\'color:#FFFFFF\'> </span> <span style=\'font-weight:bold;\'></span><span style=\'color:#800000\'>B</span><span style=\'color:#8A0000\'>l</span><span style=\'color:#940000\'>a</span><span style=\'color:#9D0000\'>c</span><span style=\'color:#A70000\'>k</span><span style=\'color:#B10000\'>B</span><span style=\'color:#BB0000\'>l</span><span style=\'color:#C40000\'>o</span><span style=\'color:#CE0000\'>o</span><span style=\'color:#D80000\'>d</span><span style=\'color:#E20000\'> </span><span style=\'color:#EB0000\'>s</span><span style=\'color:#F50000\'>e</span><span style=\'color:#FF0000\'>t</span> <span style=\'color:#555555\'>✙ <span style=\'font-weight:bold;\'></span></span><span style=\'color:#FF0000\'>L</span><span style=\'color:#ED0000\'>e</span><span style=\'color:#DB0000\'>g</span><span style=\'color:#C90000\'>g</span><span style=\'color:#B60000\'>i</span><span style=\'color:#A40000\'>n</span><span style=\'color:#920000\'>g</span><span style=\'color:#800000\'>s</span> <span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span><span style=\'color:#FFFFFF\'> </span><span style=\'color:#F3F3F3\'>=</span><span style=\'color:#E6E6E6\'>.</span><span style=\'color:#DADADA\'>,</span><span style=\'color:#CECECE\'>.</span><span style=\'color:#C1C1C1\'>=</span><span style=\'color:#B5B5B5\'>(</span><span style=\'color:#A9A9A9\'> </span><span style=\'color:#9C9C9C\'>)</span><span style=\'color:#909090\'>=</span><span style=\'color:#838383\'>.</span><span style=\'color:#777777\'>,</span><span style=\'color:#6B6B6B\'>.</span><span style=\'color:#5E5E5E\'>=</span><span style=\'color:#525252\'> </span><span style=\'color:#AA0000\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><span style=\'color:#FF5555\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><br><span style=\'color:#AAAAAA\'>Blast Protection 5</span><br><span style=\'color:#AAAAAA\'>Feather Falling 2</span><br><span style=\'color:#AAAAAA\'>Fire Protection 6</span><br><span style=\'color:#AAAAAA\'>Mending 1</span><br><span style=\'color:#AAAAAA\'>Projectile Protection 1</span><br><span style=\'color:#AAAAAA\'>Protection 4</span><br><span style=\'color:#AAAAAA\'>Unbreaking 5</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#FFFFFF\'><span style=\'font-style:italic;\'>Filled with the souls of the damned</span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#C20000\'>B</span><span style=\'color:#BC0909\'>l</span><span style=\'color:#B61212\'>a</span><span style=\'color:#B01B1B\'>c</span><span style=\'color:#AA2424\'>k</span><span style=\'color:#A42D2D\'>B</span><span style=\'color:#9E3636\'>l</span><span style=\'color:#993F3F\'>o</span><span style=\'color:#934848\'>o</span><span style=\'color:#8D5151\'>d</span><span style=\'color:#875A5A\'>P</span><span style=\'color:#816363\'>a</span><span style=\'color:#7B6C6C\'>c</span><span style=\'color:#757575\'>k</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---*</span></span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#AAAAAA\'><span style=\'text-decoration:line-through;\'>= </span></span> <span style=\'color:#FF5555\'>Skill: </span><span style=\'color:#AA0000\'>Bloodbath</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---*</span></span></span>','2026-04-10 15:37:20'),
('AS82',15,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>AdventCalender</span>','2026-04-10 15:37:20'),
('AS82',16,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>WeaponStand</span>','2026-04-10 15:37:20'),
('AS82',17,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>Sunshade</span>','2026-04-10 15:37:20'),
('AS82',18,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>Hammock</span>','2026-04-10 15:37:20'),
('AS82',19,'PIG_SPAWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pig_spawn_egg.png','<span style=\'color:#FF5555\'>TornTableB</span>','2026-04-10 15:37:20'),
('AS82',20,'PLAYER_HEAD',1,'https://minotar.net/avatar/','<span style=\'color:#55FFFF\'>HoloWardrobe</span><br><br><span style=\'color:#AAAAAA\'>Save your armors!</span>','2026-04-10 15:37:20'),
('AS82',21,'SPRUCE_WOOD',1,'https://mc.nerothe.com/img/1.21.8/minecraft_spruce_wood.png','Spruce Wood','2026-04-10 15:37:20'),
('AS82',22,'OXIDIZED_CHISELED_COPPER',1,'https://mc.nerothe.com/img/1.21.8/minecraft_oxidized_chiseled_copper.png','Oxidized Chiseled Copper','2026-04-10 15:37:20'),
('AS82',23,'BIRCH_PLANKS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_birch_planks.png','Birch Planks','2026-04-10 15:37:20'),
('AS82',24,'DARK_OAK_PLANKS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_dark_oak_planks.png','Dark Oak Planks','2026-04-10 15:37:20'),
('AS82',25,'BROWN_WOOL',1,'https://mc.nerothe.com/img/1.21.8/minecraft_brown_wool.png','Brown Wool','2026-04-10 15:37:20'),
('AS82',26,'BLACK_BANNER',1,'https://mc.nerothe.com/img/1.21.8/minecraft_black_banner.png','<span style=\'color:#FFFFFF\'></span><span style=\'color:#AA0000\'>⸸ <span style=\'font-weight:bold;\'></span></span><span style=\'color:#FF6600\'>S</span><span style=\'color:#FF7611\'>i</span><span style=\'color:#FF8622\'>n</span><span style=\'color:#FF9532\'>n</span><span style=\'color:#FFA543\'>e</span><span style=\'color:#FFB554\'>r</span> <span style=\'color:#AA0000\'>⸸</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#FFFFFF\'><span style=\'font-style:italic;\'>Lucifer is watching you</span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#C20000\'>B</span><span style=\'color:#BC0909\'>l</span><span style=\'color:#B61212\'>a</span><span style=\'color:#B01B1B\'>c</span><span style=\'color:#AA2424\'>k</span><span style=\'color:#A42D2D\'>B</span><span style=\'color:#9E3636\'>l</span><span style=\'color:#993F3F\'>o</span><span style=\'color:#934848\'>o</span><span style=\'color:#8D5151\'>d</span><span style=\'color:#875A5A\'>P</span><span style=\'color:#816363\'>a</span><span style=\'color:#7B6C6C\'>c</span><span style=\'color:#757575\'>k</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#AA0000\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#FF5555\'>Decoration</span>','2026-04-10 15:37:20'),
('AS82',27,'YELLOW_WOOL',1,'https://mc.nerothe.com/img/1.21.8/minecraft_yellow_wool.png','Yellow Wool','2026-04-10 15:37:20'),
('AS82',28,'BLACK_CONCRETE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_black_concrete.png','Black Concrete','2026-04-10 15:37:20'),
('AS82',29,'DIAMOND_CHESTPLATE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_diamond_chestplate.png','<span style=\'color:#AAAAAA\'>[</span><span style=\'color:#55FF55\'>ᴠɪᴘ</span><span style=\'color:#FFFF55\'>✶</span><span style=\'color:#AAAAAA\'>] Chestplate</span><br><span style=\'color:#AAAAAA\'>Protection 2</span><br><span style=\'color:#AAAAAA\'>Unbreaking 2</span>','2026-04-10 15:37:20'),
('AS82',30,'DIAMOND_CHESTPLATE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_diamond_chestplate.png','<span style=\'color:#8A00FF\'>⭐ </span><span style=\'color:#AAAAAA\'>[</span><span style=\'color:#55FF55\'>ᴠɪᴘ</span><span style=\'color:#FFFF55\'>✶</span><span style=\'color:#AAAAAA\'>] Chestplate </span><span style=\'color:#FFFFFF\'>[cyber_thrusters]</span><br><span style=\'color:#AAAAAA\'>Protection 2</span><br><span style=\'color:#AAAAAA\'>Unbreaking 2</span><br><span style=\'color:#FFFFFF\'>✦ Cosmetic: cyber_thrusters</span>','2026-04-10 15:37:20'),
('AS82',31,'DIAMOND_BOOTS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_diamond_boots.png','<span style=\'color:#FFD700\'>🔥 </span><span style=\'color:#AAAAAA\'>[</span><span style=\'color:#55FF55\'>ᴠɪᴘ</span><span style=\'color:#FFFF55\'>✶</span><span style=\'color:#AAAAAA\'>] Boots </span><span style=\'color:#FF5555\'>[Cyber Glitch]</span><br><span style=\'color:#AAAAAA\'>Depth Strider 1</span><br><span style=\'color:#AAAAAA\'>Feather Falling 1</span><br><span style=\'color:#AAAAAA\'>Protection 2</span><br><span style=\'color:#AAAAAA\'>Unbreaking 2</span><br><span style=\'color:#FF5555\'>✦ Cosmetic: Cyber Glitch</span>','2026-04-10 15:37:20'),
('AS82',32,'DIAMOND_BOOTS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_diamond_boots.png','<span style=\'color:#AAAAAA\'>[</span><span style=\'color:#55FF55\'>ᴠɪᴘ</span><span style=\'color:#FFFF55\'>✶</span><span style=\'color:#AAAAAA\'>] Boots</span><br><span style=\'color:#AAAAAA\'>Depth Strider 1</span><br><span style=\'color:#AAAAAA\'>Feather Falling 1</span><br><span style=\'color:#AAAAAA\'>Protection 2</span><br><span style=\'color:#AAAAAA\'>Unbreaking 2</span>','2026-04-10 15:37:20'),
('AS82',33,'SEA_LANTERN',1,'https://mc.nerothe.com/img/1.21.8/minecraft_sea_lantern.png','Sea Lantern','2026-04-10 15:37:20'),
('AS82',34,'PINK_WOOL',1,'https://mc.nerothe.com/img/1.21.8/minecraft_pink_wool.png','Pink Wool','2026-04-10 15:37:20'),
('AS82',35,'DARK_OAK_WOOD',1,'https://mc.nerothe.com/img/1.21.8/minecraft_dark_oak_wood.png','Dark Oak Wood','2026-04-10 15:37:20'),
('AS82',36,'NETHERITE_BOOTS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_boots.png','<span style=\'color:#FFFFFF\'></span><span style=\'color:#FF5555\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><span style=\'color:#AA0000\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*<span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span></span></span></span><span style=\'color:#525252\'> </span><span style=\'color:#5E5E5E\'>=</span><span style=\'color:#6B6B6B\'>.</span><span style=\'color:#777777\'>,</span><span style=\'color:#838383\'>.</span><span style=\'color:#909090\'>=</span><span style=\'color:#9C9C9C\'>(</span><span style=\'color:#A9A9A9\'> </span><span style=\'color:#B5B5B5\'>)</span><span style=\'color:#C1C1C1\'>=</span><span style=\'color:#CECECE\'>.</span><span style=\'color:#DADADA\'>,</span><span style=\'color:#E6E6E6\'>.</span><span style=\'color:#F3F3F3\'>=</span><span style=\'color:#FFFFFF\'> </span> <span style=\'font-weight:bold;\'></span><span style=\'color:#800000\'>B</span><span style=\'color:#8A0000\'>l</span><span style=\'color:#940000\'>a</span><span style=\'color:#9D0000\'>c</span><span style=\'color:#A70000\'>k</span><span style=\'color:#B10000\'>B</span><span style=\'color:#BB0000\'>l</span><span style=\'color:#C40000\'>o</span><span style=\'color:#CE0000\'>o</span><span style=\'color:#D80000\'>d</span><span style=\'color:#E20000\'> </span><span style=\'color:#EB0000\'>s</span><span style=\'color:#F50000\'>e</span><span style=\'color:#FF0000\'>t</span> <span style=\'color:#555555\'>✙ <span style=\'font-weight:bold;\'></span></span><span style=\'color:#FF0000\'>B</span><span style=\'color:#DF0000\'>o</span><span style=\'color:#C00000\'>o</span><span style=\'color:#A00000\'>t</span><span style=\'color:#800000\'>s</span> <span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'></span></span><span style=\'color:#FFFFFF\'> </span><span style=\'color:#F3F3F3\'>=</span><span style=\'color:#E6E6E6\'>.</span><span style=\'color:#DADADA\'>,</span><span style=\'color:#CECECE\'>.</span><span style=\'color:#C1C1C1\'>=</span><span style=\'color:#B5B5B5\'>(</span><span style=\'color:#A9A9A9\'> </span><span style=\'color:#9C9C9C\'>)</span><span style=\'color:#909090\'>=</span><span style=\'color:#838383\'>.</span><span style=\'color:#777777\'>,</span><span style=\'color:#6B6B6B\'>.</span><span style=\'color:#5E5E5E\'>=</span><span style=\'color:#525252\'> </span><span style=\'color:#AA0000\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><span style=\'color:#FF5555\'><span style=\'font-weight:bold;\'><span class=\'obfuscated\'>*</span></span></span><br><span style=\'color:#AAAAAA\'>Blast Protection 1</span><br><span style=\'color:#AAAAAA\'>Feather Falling 5</span><br><span style=\'color:#AAAAAA\'>Fire Protection 1</span><br><span style=\'color:#AAAAAA\'>Mending 1</span><br><span style=\'color:#AAAAAA\'>Projectile Protection 6</span><br><span style=\'color:#AAAAAA\'>Protection 4</span><br><span style=\'color:#AAAAAA\'>Soul Speed 3</span><br><span style=\'color:#AAAAAA\'>Unbreaking 5</span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#FFFFFF\'><span style=\'font-style:italic;\'>Filled with the souls of the damned</span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#555555\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*</span></span></span> <span style=\'color:#C20000\'>B</span><span style=\'color:#BC0909\'>l</span><span style=\'color:#B61212\'>a</span><span style=\'color:#B01B1B\'>c</span><span style=\'color:#AA2424\'>k</span><span style=\'color:#A42D2D\'>B</span><span style=\'color:#9E3636\'>l</span><span style=\'color:#993F3F\'>o</span><span style=\'color:#934848\'>o</span><span style=\'color:#8D5151\'>d</span><span style=\'color:#875A5A\'>P</span><span style=\'color:#816363\'>a</span><span style=\'color:#7B6C6C\'>c</span><span style=\'color:#757575\'>k</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---*</span></span></span><br><span style=\'color:#FFFFFF\'></span><span style=\'color:#AAAAAA\'><span style=\'text-decoration:line-through;\'>= </span></span> <span style=\'color:#FF5555\'>Skill: </span><span style=\'color:#AA0000\'>Bloodbath</span><br><span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'><span style=\'text-decoration:line-through;\'>*---=---=---=---=---=---*</span></span></span>','2026-04-10 15:37:20'),
('AS82',37,'NETHERITE_LEGGINGS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_leggings.png','Netherite Leggings<br><span style=\'color:#AAAAAA\'>Protection 255</span><br><span style=\'color:#AAAAAA\'>Unbreaking 255</span>','2026-04-10 15:37:20'),
('AS82',38,'NETHERITE_CHESTPLATE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_chestplate.png','Netherite Chestplate<br><span style=\'color:#AAAAAA\'>Protection 255</span><br><span style=\'color:#AAAAAA\'>Unbreaking 255</span>','2026-04-10 15:37:20'),
('AS82',39,'NETHERITE_HELMET',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_helmet.png','Netherite Helmet<br><span style=\'color:#AAAAAA\'>Protection 255</span><br><span style=\'color:#AAAAAA\'>Unbreaking 255</span>','2026-04-10 15:37:20'),
('AS82',40,'ENCHANTED_GOLDEN_APPLE',61,'https://mc.nerothe.com/img/1.21.8/minecraft_enchanted_golden_apple.png','Enchanted Golden Apple','2026-04-10 15:37:20'),
('Dragoncote',0,'PLAYER_HEAD',1,'https://minotar.net/avatar/null','<span style=\'color:#FFAA00\'>Survival Menu </span><span style=\'color:#AAAAAA\'>(Right Click)</span><br><span style=\'color:#FFFFFF\'></span><br><span style=\'color:#AAAAAA\'>Get access to most of the </span><span style=\'color:#55FFFF\'>Survival</span><br><span style=\'color:#AAAAAA\'>menus with this menu item, you can either</span><br><span style=\'color:#AAAAAA\'>lock this item in any slots you wish for</span><br><span style=\'color:#AAAAAA\'>or just simply access it via </span><span style=\'color:#55FF55\'>/menu</span><span style=\'color:#AAAAAA\'>!</span><br><span style=\'color:#FFFFFF\'></span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ʟᴇꜰᴛ ᴄʟɪᴄᴋ ᴛᴏ</span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ꜱᴡɪᴛᴄʜ ᴛʜᴇ ʟᴏᴄᴋɪɴɢ ᴍᴏᴅᴇ!</span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ᴄᴜʀʀᴇɴᴛ ᴍᴏᴅᴇ: </span><span style=\'color:#FF5555\'><span style=\'font-weight:bold;\'>LOCKED</span></span><br><span style=\'color:#AAAAAA\'></span><br><span style=\'color:#FFFF55\'>Click to open!</span>','2026-03-23 03:06:37'),
('Dragoncote',1,'ANDESITE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_andesite.png','Andesite','2026-03-23 03:06:37'),
('Dragoncote',2,'OAK_SIGN',1,'https://mc.nerothe.com/img/1.21.8/minecraft_oak_sign.png','Oak Sign','2026-03-23 03:06:37'),
('Dragoncote',3,'BROWN_EGG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_brown_egg.png','Brown Egg','2026-03-23 03:06:37'),
('Dragoncote',5,'STRIPPED_DARK_OAK_LOG',1,'https://mc.nerothe.com/img/1.21.8/minecraft_stripped_dark_oak_log.png','Stripped Dark Oak Log','2026-03-23 03:06:37'),
('Dragoncote',6,'SMOOTH_STONE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_smooth_stone.png','Smooth Stone','2026-03-23 03:06:37'),
('Dragoncote',7,'DARK_OAK_BUTTON',1,'https://mc.nerothe.com/img/1.21.8/minecraft_dark_oak_button.png','Dark Oak Button','2026-03-23 03:06:37'),
('Dragoncote',8,'ENCHANTED_BOOK',1,'https://mc.nerothe.com/img/1.21.8/minecraft_enchanted_book.png','Enchanted Book','2026-03-23 03:06:37'),
('Dragoncote',9,'NETHERITE_LEGGINGS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_leggings.png','<span style=\'color:#5555FF\'>Phoenix\'ꜱ ʟᴇɢɢɪɴɢꜱ</span><br><span style=\'color:#AAAAAA\'></span>','2026-03-23 03:06:37'),
('Dragoncote',10,'NETHERITE_LEGGINGS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_leggings.png','<span style=\'color:#5555FF\'>Phoenix\'ꜱ ʟᴇɢɢɪɴɢꜱ</span><br><span style=\'color:#AAAAAA\'></span>','2026-03-23 03:06:37'),
('Dragoncote',11,'NETHERITE_LEGGINGS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_leggings.png','<span style=\'color:#5555FF\'>Phoenix\'ꜱ ʟᴇɢɢɪɴɢꜱ</span><br><span style=\'color:#AAAAAA\'></span>','2026-03-23 03:06:37'),
('Dragoncote',12,'STRING',1,'https://mc.nerothe.com/img/1.21.8/minecraft_string.png','String','2026-03-23 03:06:37'),
('Dragoncote',13,'PLAYER_HEAD',1,'https://minotar.net/avatar/null','<span style=\'color:#FFFF55\'>Default name</span><br><span style=\'color:#55FFFF\'><span style=\'font-style:italic;\'>Default lore</span></span>','2026-03-23 03:06:37'),
('Dragoncote',14,'PLAYER_HEAD',1,'https://minotar.net/avatar/null','<span style=\'color:#FFFF55\'>Default name</span><br><span style=\'color:#55FFFF\'><span style=\'font-style:italic;\'>Default lore</span></span>','2026-03-23 03:06:37'),
('Dragoncote',29,'PLAYER_HEAD',1,'https://minotar.net/avatar/null','<span style=\'color:#FFFF55\'>Default name</span><br><span style=\'color:#55FFFF\'><span style=\'font-style:italic;\'>Default lore</span></span>','2026-03-23 03:06:37'),
('SxmiiiAlt',0,'STICK',1,'https://mc.nerothe.com/img/1.21.8/minecraft_stick.png','Stick','2026-04-07 16:29:52'),
('SxmiiiAlt',8,'PLAYER_HEAD',1,'https://minotar.net/avatar/','<span style=\'color:#FFAA00\'>Survival Menu </span><span style=\'color:#AAAAAA\'>(Right Click)</span><br><span style=\'color:#FFFFFF\'></span><br><span style=\'color:#AAAAAA\'>Get access to most of the </span><span style=\'color:#55FFFF\'>Survival</span><br><span style=\'color:#AAAAAA\'>menus with this menu item, you can either</span><br><span style=\'color:#AAAAAA\'>lock this item in any slots you wish for</span><br><span style=\'color:#AAAAAA\'>or just simply access it via </span><span style=\'color:#55FF55\'>/menu</span><span style=\'color:#AAAAAA\'>!</span><br><span style=\'color:#FFFFFF\'></span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ʟᴇꜰᴛ ᴄʟɪᴄᴋ ᴛᴏ</span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ꜱᴡɪᴛᴄʜ ᴛʜᴇ ʟᴏᴄᴋɪɴɢ ᴍᴏᴅᴇ!</span><br><span style=\'color:#555555\'><span style=\'text-decoration:line-through;\'>=</span></span> <span style=\'color:#555555\'>ᴄᴜʀʀᴇɴᴛ ᴍᴏᴅᴇ: </span><span style=\'color:#55FF55\'><span style=\'font-weight:bold;\'>UNLOCKED</span></span><br><span style=\'color:#AAAAAA\'></span><br><span style=\'color:#FFFF55\'>Click to open!</span>','2026-04-07 16:29:52'),
('SxmiiiAlt',9,'GRASS_BLOCK',1,'https://mc.nerothe.com/img/1.21.8/minecraft_grass_block.png','<span style=\'color:#00AA00\'><span style=\'font-weight:bold;\'>Radius Claimblock</span></span><br><span style=\'color:#AAAAAA\'>You can claim a radius of</span><br><span style=\'color:#AAAAAA\'>chunks by placing this block</span><br><span style=\'color:#AAAAAA\'>in the wilderness.</span><br><br> <span style=\'color:#555555\'>• </span><span style=\'color:#AAAAAA\'>Owner:</span><span style=\'color:#00AAAA\'> SxmiiiAlt</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#AAAAAA\'>Radius:</span><span style=\'color:#00AAAA\'> 1 </span><span style=\'color:#555555\'>(</span><span style=\'color:#00AAAA\'>= 9 chunks</span><span style=\'color:#555555\'>)</span>','2026-04-07 16:29:52'),
('SxmiiiAlt',10,'CAMPFIRE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_campfire.png','<span style=\'color:#00AA00\'><span style=\'font-weight:bold;\'>Camp</span></span><br><span style=\'color:#AAAAAA\'>Place this item to create a temporary</span><br><span style=\'color:#AAAAAA\'>camp that will be deleted after</span><br><span style=\'color:#AA00AA\'>1 day(s)</span><span style=\'color:#AAAAAA\'>.</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#AAAAAA\'>Radius:</span><span style=\'color:#00AAAA\'> 1</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#AAAAAA\'>Camps can\'t be expanded.</span>','2026-04-07 16:29:52'),
('SxmiiiAlt',11,'FEATHER',1,'https://mc.nerothe.com/img/1.21.8/minecraft_feather.png','<span style=\'color:#00AA00\'><span style=\'font-weight:bold;\'>Info Tool</span></span><br><span style=\'color:#AAAAAA\'>Use this tool to get</span><br><span style=\'color:#AAAAAA\'>information about the claim</span><br><span style=\'color:#AAAAAA\'>you\'re pointing at.</span>','2026-04-07 16:29:52'),
('SxmiiiAlt',12,'GOLDEN_HOE',1,'https://mc.nerothe.com/img/1.21.8/minecraft_golden_hoe.png','<span style=\'color:#00AA00\'><span style=\'font-weight:bold;\'>Selection Tool</span></span><br><span style=\'color:#AAAAAA\'>Use this tool to create a selection.</span><br><span style=\'color:#AAAAAA\'>Selections can be used for:</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#FFFF55\'>/claim</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#FFFF55\'>/unclaim</span><br> <span style=\'color:#555555\'>• </span><span style=\'color:#FFFF55\'>/assign</span>','2026-04-07 16:29:52'),
('SxmiiiAlt',13,'WHEAT_SEEDS',1,'https://mc.nerothe.com/img/1.21.8/minecraft_wheat_seeds.png','Wheat Seeds','2026-04-07 16:29:52'),
('xXxdaliborxXx',2,'NETHERITE_SWORD',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_sword.png','Netherite Sword','2026-03-23 21:35:27'),
('xXxdaliborxXx',3,'NETHERITE_SWORD',1,'https://mc.nerothe.com/img/1.21.8/minecraft_netherite_sword.png','Netherite Sword<br><span style=\'color:#AAAAAA\'>Sharpness 5</span>','2026-03-23 21:35:27');
/*!40000 ALTER TABLE `player_inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_searches`
--

DROP TABLE IF EXISTS `player_searches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_searches` (
  `player_name` varchar(64) NOT NULL,
  `search_count` int(11) DEFAULT 0,
  PRIMARY KEY (`player_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_searches`
--

LOCK TABLES `player_searches` WRITE;
/*!40000 ALTER TABLE `player_searches` DISABLE KEYS */;
INSERT INTO `player_searches` VALUES
('1',25),
('AS82',65),
('DKARPO',35),
('Dream',6),
('mamadnabudi',26),
('RuthKnight',34),
('Test',8),
('xxxdaliborxxx',25);
/*!40000 ALTER TABLE `player_searches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_stats`
--

DROP TABLE IF EXISTS `player_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `player_stats` (
  `player_name` varchar(64) NOT NULL,
  `placeholder_name` text DEFAULT NULL,
  `placeholder_value` text DEFAULT NULL,
  `placeholder_value_clean` text DEFAULT NULL,
  `placeholder_definer` text DEFAULT NULL,
  `placeholder_definer_clean` text DEFAULT NULL,
  `section_index` int(11) NOT NULL,
  `section_title` text DEFAULT NULL,
  `order_index` int(11) NOT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`player_name`,`section_index`,`order_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_stats`
--

LOCK TABLES `player_stats` WRITE;
/*!40000 ALTER TABLE `player_stats` DISABLE KEYS */;
INSERT INTO `player_stats` VALUES
('AS82','%cmi_user_playtime_dayst%','0.44','0.44','<span style=\'color:#FFFF55\'>⍋ Playtime</span>','⍋ Playtime',1,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>General Stats</span></span>',0,'2026-04-10 15:37:20'),
('AS82','%mcmmo_power_level%','4349','4349','<span style=\'color:#55FFFF\'>✺ Power Level</span>','✺ Power Level',1,NULL,1,'2026-04-10 15:37:20'),
('AS82','&5&r%battlepass_pass_type% [%battlepass_tier%]','<span style=\'color:#AA00AA\'></span>Premium [71]','Premium [71]','<span style=\'color:#55FFFF\'>⚜ Battlepass</span>','⚜ Battlepass',1,NULL,2,'2026-04-10 15:37:20'),
('AS82','&6&r&bK &f/ &4D %deluxecombat_ranking_kd% &7┃ &bRank: &8[&f%deluxecombat_ranking_rank%&8]','<span style=\'color:#FFAA00\'></span><span style=\'color:#55FFFF\'>K </span><span style=\'color:#FFFFFF\'>/ </span><span style=\'color:#AA0000\'>D 0.0 </span><span style=\'color:#AAAAAA\'>┃ </span><span style=\'color:#55FFFF\'>Rank: </span><span style=\'color:#555555\'>[</span><span style=\'color:#FFFFFF\'>0</span><span style=\'color:#555555\'>]</span>','K / D 0.0 ┃ Rank: [0]','<span style=\'color:#55FFFF\'>🗡 Combat</span>','🗡 Combat',1,NULL,3,'2026-04-10 15:37:20'),
('AS82','&7&r%guilds_prefix% %guilds_name%','<span style=\'color:#AAAAAA\'></span>❤ Dragoncote','❤ Dragoncote','<span style=\'color:#FF55FF\'>♔ Guild</span>','♔ Guild',1,NULL,4,'2026-04-10 15:37:20'),
('AS82','&8&r%luckperms_prefix%','<span style=\'color:#555555\'></span><span style=\'color:#AAAAAA\'><span style=\'font-weight:bold;\'>[</span></span><span style=\'color:#55FFFF\'><span style=\'font-weight:bold;\'>ᴍᴠᴘ</span></span><span style=\'color:#AAAAAA\'><span style=\'font-weight:bold;\'>]</span></span><span style=\'color:#55FFFF\'> </span>','[ᴍᴠᴘ] ','<span style=\'color:#FFFF55\'>♛ Rank</span>','♛ Rank',1,NULL,5,'2026-04-10 15:37:20'),
('AS82','&9&r%luckperms_primary_group_name%','<span style=\'color:#5555FF\'></span>mvp','mvp','<span style=\'color:#FFAA00\'>⚜ Rank Tag</span>','⚜ Rank Tag',1,NULL,6,'2026-04-10 15:37:20'),
('AS82','%cmi_user_balance_formated%','7,800.00$','7,800.00$','<span style=\'color:#FFFF55\'>💰 Balance</span>','💰 Balance',2,'<span style=\'color:#FFAA00\'><span style=\'font-weight:bold;\'>Currencies</span></span>',0,'2026-04-10 15:37:20'),
('AS82','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',2,NULL,1,'2026-04-10 15:37:20'),
('AS82','%coinsengine_balance_raw_afkcoins%','40','40','<span style=\'color:#FFAA00\'>〄 Votes</span>','〄 Votes',2,NULL,2,'2026-04-10 15:37:20'),
('AS82','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',3,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>TEST NEWWS</span></span>',0,'2026-04-10 15:37:20'),
('Dragoncote','%cmi_user_playtime_dayst%','1.13','1.13','<span style=\'color:#FFFF55\'>⍋ Playtime</span>','⍋ Playtime',1,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>General Stats</span></span>',0,'2026-03-23 03:06:37'),
('Dragoncote','%mcmmo_power_level%','2','2','<span style=\'color:#55FFFF\'>✺ Power Level</span>','✺ Power Level',1,NULL,1,'2026-03-23 03:06:37'),
('Dragoncote','&5&r%battlepass_pass_type% [%battlepass_tier%]','<span style=\'color:#AA00AA\'></span>Free [8]','Free [8]','<span style=\'color:#55FFFF\'>⚜ Battlepass</span>','⚜ Battlepass',1,NULL,2,'2026-03-23 03:06:37'),
('Dragoncote','&6&r&bK &f/ &4D %deluxecombat_ranking_kd% &7┃ &bRank: &8[&f%deluxecombat_ranking_rank%&8]','<span style=\'color:#FFAA00\'></span><span style=\'color:#55FFFF\'>K </span><span style=\'color:#FFFFFF\'>/ </span><span style=\'color:#AA0000\'>D 0.0 </span><span style=\'color:#AAAAAA\'>┃ </span><span style=\'color:#55FFFF\'>Rank: </span><span style=\'color:#555555\'>[</span><span style=\'color:#FFFFFF\'>0</span><span style=\'color:#555555\'>]</span>','K / D 0.0 ┃ Rank: [0]','<span style=\'color:#55FFFF\'>🗡 Combat</span>','🗡 Combat',1,NULL,3,'2026-03-23 03:06:37'),
('Dragoncote','&7&r%guilds_prefix% %guilds_name%','<span style=\'color:#AAAAAA\'></span> ',' ','<span style=\'color:#FF55FF\'>♔ Guild</span>','♔ Guild',1,NULL,4,'2026-03-23 03:06:37'),
('Dragoncote','&8&r%luckperms_prefix%','<span style=\'color:#555555\'></span><span style=\'color:#000000\'>[</span><span style=\'color:#0000AA\'><span style=\'font-weight:bold;\'>ᴏᴡɴᴇʀ</span></span><span style=\'color:#000000\'>]</span><span style=\'color:#5555FF\'> </span>','[ᴏᴡɴᴇʀ] ','<span style=\'color:#FFFF55\'>♛ Rank</span>','♛ Rank',1,NULL,5,'2026-03-23 03:06:37'),
('Dragoncote','&9&r%luckperms_primary_group_name%','<span style=\'color:#5555FF\'></span>owner','owner','<span style=\'color:#FFAA00\'>⚜ Rank Tag</span>','⚜ Rank Tag',1,NULL,6,'2026-03-23 03:06:37'),
('Dragoncote','%cmi_user_balance_formated%','200.00$','200.00$','<span style=\'color:#FFFF55\'>💰 Balance</span>','💰 Balance',2,'<span style=\'color:#FFAA00\'><span style=\'font-weight:bold;\'>Currencies</span></span>',0,'2026-03-23 03:06:37'),
('Dragoncote','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',2,NULL,1,'2026-03-23 03:06:37'),
('Dragoncote','%coinsengine_balance_raw_afkcoins%','0','0','<span style=\'color:#FFAA00\'>〄 Votes</span>','〄 Votes',2,NULL,2,'2026-03-23 03:06:37'),
('Dragoncote','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',3,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>TEST NEWWS</span></span>',0,'2026-03-23 03:06:37'),
('SxmiiiAlt','%cmi_user_playtime_dayst%','0.0','0.0','<span style=\'color:#FFFF55\'>⍋ Playtime</span>','⍋ Playtime',1,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>General Stats</span></span>',0,'2026-04-07 16:29:52'),
('SxmiiiAlt','%mcmmo_power_level%','','','<span style=\'color:#55FFFF\'>✺ Power Level</span>','✺ Power Level',1,NULL,1,'2026-04-07 16:29:52'),
('SxmiiiAlt','&5&r%battlepass_pass_type% [%battlepass_tier%]','<span style=\'color:#AA00AA\'></span>Free [2]','Free [2]','<span style=\'color:#55FFFF\'>⚜ Battlepass</span>','⚜ Battlepass',1,NULL,2,'2026-04-07 16:29:52'),
('SxmiiiAlt','&6&r&bK &f/ &4D %deluxecombat_ranking_kd% &7┃ &bRank: &8[&f%deluxecombat_ranking_rank%&8]','<span style=\'color:#FFAA00\'></span><span style=\'color:#55FFFF\'>K </span><span style=\'color:#FFFFFF\'>/ </span><span style=\'color:#AA0000\'>D 0.0 </span><span style=\'color:#AAAAAA\'>┃ </span><span style=\'color:#55FFFF\'>Rank: </span><span style=\'color:#555555\'>[</span><span style=\'color:#FFFFFF\'>0</span><span style=\'color:#555555\'>]</span>','K / D 0.0 ┃ Rank: [0]','<span style=\'color:#55FFFF\'>🗡 Combat</span>','🗡 Combat',1,NULL,3,'2026-04-07 16:29:52'),
('SxmiiiAlt','&7&r%guilds_prefix% %guilds_name%','<span style=\'color:#AAAAAA\'></span> ',' ','<span style=\'color:#FF55FF\'>♔ Guild</span>','♔ Guild',1,NULL,4,'2026-04-07 16:29:52'),
('SxmiiiAlt','&8&r%luckperms_prefix%','<span style=\'color:#555555\'></span>','','<span style=\'color:#FFFF55\'>♛ Rank</span>','♛ Rank',1,NULL,5,'2026-04-07 16:29:52'),
('SxmiiiAlt','&9&r%luckperms_primary_group_name%','<span style=\'color:#5555FF\'></span>default','default','<span style=\'color:#FFAA00\'>⚜ Rank Tag</span>','⚜ Rank Tag',1,NULL,6,'2026-04-07 16:29:52'),
('SxmiiiAlt','%cmi_user_balance_formated%','200.00$','200.00$','<span style=\'color:#FFFF55\'>💰 Balance</span>','💰 Balance',2,'<span style=\'color:#FFAA00\'><span style=\'font-weight:bold;\'>Currencies</span></span>',0,'2026-04-07 16:29:52'),
('SxmiiiAlt','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',2,NULL,1,'2026-04-07 16:29:52'),
('SxmiiiAlt','%coinsengine_balance_raw_afkcoins%','0','0','<span style=\'color:#FFAA00\'>〄 Votes</span>','〄 Votes',2,NULL,2,'2026-04-07 16:29:52'),
('SxmiiiAlt','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',3,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>TEST NEWWS</span></span>',0,'2026-04-07 16:29:52'),
('xXxdaliborxXx','%cmi_user_playtime_dayst%','0.2','0.2','<span style=\'color:#FFFF55\'>⍋ Playtime</span>','⍋ Playtime',1,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>General Stats</span></span>',0,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%mcmmo_power_level%','40','40','<span style=\'color:#55FFFF\'>✺ Power Level</span>','✺ Power Level',1,NULL,1,'2026-03-23 21:35:27'),
('xXxdaliborxXx','&5&r%battlepass_pass_type% [%battlepass_tier%]','<span style=\'color:#AA00AA\'></span>Free [17]','Free [17]','<span style=\'color:#55FFFF\'>⚜ Battlepass</span>','⚜ Battlepass',1,NULL,2,'2026-03-23 21:35:27'),
('xXxdaliborxXx','&6&r&bK &f/ &4D %deluxecombat_ranking_kd% &7┃ &bRank: &8[&f%deluxecombat_ranking_rank%&8]','<span style=\'color:#FFAA00\'></span><span style=\'color:#55FFFF\'>K </span><span style=\'color:#FFFFFF\'>/ </span><span style=\'color:#AA0000\'>D 0.0 </span><span style=\'color:#AAAAAA\'>┃ </span><span style=\'color:#55FFFF\'>Rank: </span><span style=\'color:#555555\'>[</span><span style=\'color:#FFFFFF\'>0</span><span style=\'color:#555555\'>]</span>','K / D 0.0 ┃ Rank: [0]','<span style=\'color:#55FFFF\'>🗡 Combat</span>','🗡 Combat',1,NULL,3,'2026-03-23 21:35:27'),
('xXxdaliborxXx','&7&r%guilds_prefix% %guilds_name%','<span style=\'color:#AAAAAA\'></span> ',' ','<span style=\'color:#FF55FF\'>♔ Guild</span>','♔ Guild',1,NULL,4,'2026-03-23 21:35:27'),
('xXxdaliborxXx','&8&r%luckperms_prefix%','<span style=\'color:#555555\'></span><span style=\'color:#AAAAAA\'><span style=\'font-weight:bold;\'>[</span></span><span style=\'color:#55FFFF\'><span style=\'font-weight:bold;\'>ᴍᴠᴘ</span></span><span style=\'color:#55FF55\'>✶</span><span style=\'color:#AAAAAA\'><span style=\'font-weight:bold;\'>]</span></span><span style=\'color:#55FFFF\'> </span>','[ᴍᴠᴘ✶] ','<span style=\'color:#FFFF55\'>♛ Rank</span>','♛ Rank',1,NULL,5,'2026-03-23 21:35:27'),
('xXxdaliborxXx','&9&r%luckperms_primary_group_name%','<span style=\'color:#5555FF\'></span>mvp+','mvp+','<span style=\'color:#FFAA00\'>⚜ Rank Tag</span>','⚜ Rank Tag',1,NULL,6,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%cmi_user_balance_formated%','200.00$','200.00$','<span style=\'color:#FFFF55\'>💰 Balance</span>','💰 Balance',2,'<span style=\'color:#FFAA00\'><span style=\'font-weight:bold;\'>Currencies</span></span>',0,'2026-03-23 21:35:27'),
('xXxdaliborxXx','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',2,NULL,1,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%coinsengine_balance_raw_afkcoins%','0','0','<span style=\'color:#FFAA00\'>〄 Votes</span>','〄 Votes',2,NULL,2,'2026-03-23 21:35:27'),
('xXxdaliborxXx','[PRIVATE]','[PRIVATE]','[PRIVATE]','<span style=\'color:#AA00AA\'>✦ Gems</span>','✦ Gems',3,'<span style=\'color:#FFFFFF\'><span style=\'font-weight:bold;\'>TEST NEWWS</span></span>',0,'2026-03-23 21:35:27');
/*!40000 ALTER TABLE `player_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progressive_bars`
--

DROP TABLE IF EXISTS `progressive_bars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `progressive_bars` (
  `player_name` varchar(64) NOT NULL,
  `placeholder_name` text DEFAULT NULL,
  `placeholder_value` text DEFAULT NULL,
  `placeholder_max` text DEFAULT NULL,
  `placeholder_definer` text DEFAULT NULL,
  `order_index` int(11) NOT NULL,
  `last_updated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`player_name`,`order_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progressive_bars`
--

LOCK TABLES `progressive_bars` WRITE;
/*!40000 ALTER TABLE `progressive_bars` DISABLE KEYS */;
INSERT INTO `progressive_bars` VALUES
('AS82','%mcmmo_level_swords%','40','1000','Swords Level',0,'2026-04-10 15:37:20'),
('AS82','%mcmmo_level_axes%','0','1000','Axes Level',1,'2026-04-10 15:37:20'),
('AS82','%mcmmo_level_acrobatics%','387','1000','Acrobatics Level',2,'2026-04-10 15:37:20'),
('AS82','%mcmmo_level_archery%','600','1000','Archery Level',3,'2026-04-10 15:37:20'),
('Dragoncote','%mcmmo_level_swords%','1','1000','Swords Level',0,'2026-03-23 03:06:37'),
('Dragoncote','%mcmmo_level_axes%','0','1000','Axes Level',1,'2026-03-23 03:06:37'),
('Dragoncote','%mcmmo_level_acrobatics%','1','1000','Acrobatics Level',2,'2026-03-23 03:06:37'),
('Dragoncote','%mcmmo_level_archery%','0','1000','Archery Level',3,'2026-03-23 03:06:37'),
('SxmiiiAlt','%mcmmo_level_swords%','','1000','Swords Level',0,'2026-04-07 16:29:52'),
('SxmiiiAlt','%mcmmo_level_axes%','','1000','Axes Level',1,'2026-04-07 16:29:52'),
('SxmiiiAlt','%mcmmo_level_acrobatics%','','1000','Acrobatics Level',2,'2026-04-07 16:29:52'),
('SxmiiiAlt','%mcmmo_level_archery%','','1000','Archery Level',3,'2026-04-07 16:29:52'),
('xXxdaliborxXx','%mcmmo_level_swords%','12','1000','Swords Level',0,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%mcmmo_level_axes%','0','1000','Axes Level',1,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%mcmmo_level_acrobatics%','7','1000','Acrobatics Level',2,'2026-03-23 21:35:27'),
('xXxdaliborxXx','%mcmmo_level_archery%','0','1000','Archery Level',3,'2026-03-23 21:35:27');
/*!40000 ALTER TABLE `progressive_bars` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-19 12:30:42

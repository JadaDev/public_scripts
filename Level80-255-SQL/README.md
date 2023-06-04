
# SQL Scripts for Max Level 255 WoW Private Server

These SQL scripts are designed to modify a World of Warcraft (WoW) private server database, allowing players to reach the maximum level of 255. The scripts cover various aspects of the game, including player data, experience points (XP), character stats, pets, and creatures. Follow the instructions below to apply the changes to your WoW private server.

**Disclaimer**: Modifying game data can have unintended consequences and may not be compatible with all server configurations. Ensure you have backups of your database before proceeding. Use these scripts at your own risk.

## Prerequisites

Before using these SQL scripts, make sure you have the following:

-   A WoW private server running with a compatible database system (e.g., MySQL, MariaDB).
-   Access to the server's database, usually through a tool like phpMyAdmin or MySQL Workbench.
-   Basic knowledge of SQL queries and how to execute them.

## Instructions

1.  Open your preferred database management tool and connect to your WoW private server's database.
    
2.  Create a backup of your database. This step is crucial in case anything goes wrong or you wish to revert the changes.
    
3.  Execute the following SQL scripts in the provided order:
    

### 1. `player_max_level.sql`

This script modifies the player table, increasing the maximum level to 255.

### 2. `xp_max_level.sql`

This script updates the XP requirements for each level up to level 255, ensuring a smooth progression.

### 3. `stats_max_level.sql`

This script adjusts the character stats to accommodate the increased maximum level.

### 4. `pets_max_level.sql`

This script modifies the pet table, allowing pets to reach level 255 alongside the players.

### 5. `creatures_max_level.sql`

This script updates the creature table, increasing the level limit for creatures in the game.

## Usage Tips

-   Before executing the scripts, stop the WoW server to avoid any conflicts or data inconsistencies.
    
-   Ensure that you have administrator access to the database to execute these scripts.
    
-   Double-check the compatibility of these scripts with your specific server and database version.
    
-   Always have a backup of your database before running any modifications.
    
-   If you encounter any issues or wish to revert the changes, restore your database backup.
    

## Contributing

If you have any suggestions or improvements for these scripts, feel free to open an issue or submit a pull request in the repository.

## Credits

JadaDev

## License

These SQL scripts are provided under the [MIT License](https://opensource.org/license/mit/).

> This system was made by JadaDev.
> 
> DO NEVER REMOVE CREDITS.
> 
> Edit it freely.
> 
> Please make sure to insert the database tables inside your characters database.
> 
> This script will give rewards to the player only when he login and has the required played time, I made it only on login as that's what i needed for.
> 
> You could simply change obtained to '0' if you make another rewards with same ID's.
> 
> Much love Jada.


#Setup : 

1. Run Both SQL files in your characters database 'reward_played_time.sql' & 'reward_system.sql'.
2. Place 'Reward_System.cpp' Inside your custom folder (..Source\src\server\scripts\Custom).
3. Open 'custom_script_loader.cpp'.
4. Add 'void AddSC_reward_system();' under '// This is where scripts' loading functions should be declared:'.
5. Add '	AddSC_reward_system();' under 'void AddCustomScripts()'
6. Recompile, and you're good to go!

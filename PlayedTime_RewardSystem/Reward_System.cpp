// This system was made by JadaDev
// DO NEVER REMOVE CREDITS
// Edit it freely
// Please make sure to insert the database tables inside your characters database.
// This script will give rewards to the player only when he login and has the required played time, I made it only on login as that's what i needed for.
// You could simply change obtained to 0 if you make another rewards with same ID's.
// Much love Jada
#define USE_DATABASE_PROVIDER
#include "ScriptMgr.h"
#include "Player.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "DatabaseEnv.h"
#include "chat.h"

class reward_system : public PlayerScript
{
    public:
        reward_system() : PlayerScript("reward_system") {}

        void OnLogin(Player* player, bool firstLogin)
        {
            uint32 totalPlayTime = player->GetTotalPlayedTime();

            // Get all the reward details from the database
            QueryResult result = CharacterDatabase.PQuery("SELECT id, played_time, reward_item_id, reward_item_amount, reward_gold_amount, message FROM reward_played_time");
            if (result)
            {
                do
                {
                    Field* fields = result->Fetch();
                    uint32 id = fields[0].GetUInt32();
                    uint32 playedTime = fields[1].GetUInt32();
                    uint32 rewardItemId = fields[2].GetUInt32();
                    uint32 rewardItemAmount = fields[3].GetUInt32();
                    uint32 rewardGoldAmount = fields[4].GetUInt32();
                    std::string message = fields[5].GetString();

                    // Check if the player has playedtime = or more than what's specified in the reward_played_time table ( played_time column )
                    if (totalPlayTime >= playedTime)
                    {
                        // Check if the player has already received a reward by checking reward_played_time id and reward system reward_id
                        QueryResult result2 = CharacterDatabase.PQuery("SELECT obtained FROM reward_system WHERE character_guid = %u AND reward_id = %u", player->GetGUID().GetCounter(), id);
                        if (result2)
                        {
                            Field* fields2 = result2->Fetch();
							uint8 obtained = fields2[0].GetUInt8();

								// If you ever reset something in the reward_played_time table you could change unobtained to 0 so that the player can get the rewards again after he logs in

                            if (obtained == 0)
                            {
                                // Give the player the reward item and it's count that is specified in reward_played_time as reward_item_id and rewardItemAmount
                                if (rewardItemId > 0 && rewardItemAmount > 0)
                                    player->AddItem(rewardItemId, rewardItemAmount);

                                // Give the player the reward gold that is specified in reward_played_time as rewardGoldAmount
                                if (rewardGoldAmount > 0)
                                    player->ModifyMoney(rewardGoldAmount);

                                // update reward_system to make sure that he received the reward by the character guid and the reward id
                                CharacterDatabase.PExecute("UPDATE reward_system SET obtained = 1 WHERE character_guid = %u AND reward_id = %u", player->GetGUID().GetCounter(), id);

                                // Send a thanks message to the player for his dedication can be written in the message column inside reward_played_time table
                                ChatHandler(player->GetSession()).PSendSysMessage(message.c_str());
                            }
                        }
                        else
                        {
                            // This will add the character that has logged in and got a reward.
                            CharacterDatabase.PExecute("INSERT INTO reward_system (character_guid, reward_id, obtained) VALUES (%u, %u, 1)", player->GetGUID().GetCounter(), id);

                            // Give the player the reward item and it's count that is specified in reward_played_time as reward_item_id and rewardItemAmount
                            if (rewardItemId > 0 && rewardItemAmount > 0)
                                player->AddItem(rewardItemId, rewardItemAmount);

                            // Give the player the reward gold that is specified in reward_played_time as rewardGoldAmount
                            if (rewardGoldAmount > 0)
                                player->ModifyMoney(rewardGoldAmount);

                            /// Send a thanks message to the player for his dedication can be written in the message column inside reward_played_time table
                            ChatHandler(player->GetSession()).PSendSysMessage(message.c_str());
                        }
                    }
                }
                while (result->NextRow());
            }
        }
};

void AddSC_reward_system()
{
    new reward_system();
}


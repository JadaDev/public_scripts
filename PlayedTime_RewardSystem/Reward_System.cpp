// This system was made by JadaDev
// Updated by Artamedes
// DO NEVER REMOVE CREDITS
// Edit it freely
// Please make sure to insert the database tables inside your characters database.
// This script will give rewards to the player only when he login and has the required played time, I made it only on login as that's what i needed for.
// You could simply change obtained to 0 if you make another rewards with same ID's.
// Much love Jada
#include "ScriptMgr.h"
#include "Player.h"
#include "ObjectMgr.h"
#include "WorldSession.h"
#include "DatabaseEnv.h"
#include "Chat.h"
#include <vector>
#include <unordered_map>

struct PlayedTimeRewardsStruct
{
    uint32 ID;
    uint32 PlayedTime;
    uint32 RewardItemId;
    uint32 RewardItemAmount;
    uint32 RewardGoldAmount;
    std::string Message;
};

class RewardSystemMgr
{
    public:
        static RewardSystemMgr* instance()
        {
            static RewardSystemMgr instance;
            return &instance;
        }

        void LoadFromDB()
        {
            if (auto result = CharacterDatabase.Query("SELECT id, played_time, reward_item_id, reward_item_amount, reward_gold_amount, message FROM reward_played_time"))
            {
                _playedTimeRewards.reserve(result->GetRowCount());

                do
                {
                    Field* fields = result->Fetch();

                    PlayedTimeRewardsStruct playedTimeReward;

                    playedTimeReward.ID               = fields[0].GetUInt32();
                    playedTimeReward.PlayedTime       = fields[1].GetUInt32();
                    playedTimeReward.RewardItemId     = fields[2].GetUInt32();
                    playedTimeReward.RewardItemAmount = fields[3].GetUInt32();
                    playedTimeReward.RewardGoldAmount = fields[4].GetUInt32();
                    playedTimeReward.Message          = fields[5].GetString();

                    _playedTimeRewards.emplace_back(playedTimeReward);
                } while (result->NextRow());
            }

            if (auto result = CharacterDatabase.Query("SELECT character_guid, reward_id, obtained FROM reward_system"))
            {
                do
                {
                    Field* fields = result->Fetch();

                    uint32 characterGuid = fields[0].GetUInt32();
                    uint32 rewardId      = fields[1].GetUInt32();
                    bool   obtained      = fields[2].GetBool();

                    if (obtained)
                        _claimedPlayedTimeRewards[characterGuid].insert(rewardId);
                } while (result->NextRow());
            }
        }

        void GiveRewardsToPlayerIfNeed(Player* player)
        {
            uint32 totalPlayTime = player->GetTotalPlayedTime();

            std::unordered_set<uint32> const* claimedRewards = nullptr;
            auto it = _claimedPlayedTimeRewards.find(player->GetGUID().GetCounter());
            if (it != _claimedPlayedTimeRewards.end())
                claimedRewards = &it->second;

            // Ok iterate played time rewards
            for (auto const& playTimeReward : _playedTimeRewards)
            {
                // Check if player already completed this
                if (claimedRewards && claimedRewards->count(playTimeReward.ID))
                    continue;

                // Check if player has enough played time
                if (totalPlayTime < playTimeReward.PlayedTime)
                    continue;

                // Give the player the reward item and it's count that is specified in reward_played_time as reward_item_id and rewardItemAmount
                if (playTimeReward.RewardItemId > 0 && playTimeReward.RewardItemAmount > 0)
                    if (!player->AddItem(playTimeReward.RewardItemId, playTimeReward.RewardItemAmount))
                        player->SendItemRetrievalMail(playTimeReward.RewardItemId, playTimeReward.RewardItemAmount);

                // Give the player the reward gold that is specified in reward_played_time as rewardGoldAmount
                if (playTimeReward.RewardGoldAmount > 0)
                    player->ModifyMoney(playTimeReward.RewardGoldAmount);

                // Send a thanks message to the player for his dedication can be written in the message column inside reward_played_time table
                if (!playTimeReward.Message.empty())
                    ChatHandler(player->GetSession()).PSendSysMessage(playTimeReward.Message.c_str());

                // update reward_system to make sure that he received the reward by the character guid and the reward id
                CharacterDatabase.PExecute("UPDATE reward_system SET obtained = 1 WHERE character_guid = %u AND reward_id = %u", player->GetGUID().GetCounter(), playTimeReward.ID);
                _claimedPlayedTimeRewards[player->GetGUID().GetCounter()].insert(playTimeReward.ID);
            }
        }

    private:
        std::vector<PlayedTimeRewardsStruct> _playedTimeRewards;
        std::unordered_map<uint32, std::unordered_set<uint32>> _claimedPlayedTimeRewards;
};

#define sRewardSystemMgr RewardSystemMgr::instance()

class reward_system : public PlayerScript
{
public:
    reward_system() : PlayerScript("reward_system") {}

    void OnLogin(Player* player, bool /*firstLogin*/)
    {
        sRewardSystemMgr->GiveRewardsToPlayerIfNeed(player);
    }
};

void AddSC_reward_system()
{
    sRewardSystemMgr->LoadFromDB();
    new reward_system();
}

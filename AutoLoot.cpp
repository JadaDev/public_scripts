// Script Made ?? reworked and updated by JadaDev

#include "ScriptMgr.h"
#include "Player.h"
#include "Creature.h"
#include "Loot.h"
#include "Group.h"
#include "WorldSession.h"

class AutoLoot : public PlayerScript
{
public:
    AutoLoot() : PlayerScript("AutoLoot") {}

    void OnCreatureKill(Player* player, Creature* creature) override
    {
        if (!player || !creature)
            return;

        // Get the creature loot
        Loot* loot = &creature->loot;

        // Group Loot for Players
        if (Group* grp = player->GetGroup())
        {
            // Group auto-loot Disabled
        }
        else
        {
            // Check if the player is allowed to loot and if he is close enough to the lootable creature [ distance is to prevent people from looting from inside a dungeon ]
            if (player->isAllowedToLoot(creature) && player->IsWithinDistInMap(creature, 50.0f))
            {
                if (!loot->isLooted() && !loot->empty())
                {
                    // Loot gold and add it to the player
                    uint32 gold = loot->gold;
                    if (gold > 0)
                    {
                        player->ModifyMoney(gold);
                    }

                    // Check all the lootable items
                    uint8 maxSlot = loot->GetMaxSlotInLootFor(player);
                    for (uint8 i = 0; i < maxSlot; ++i)
                    {
                        LootItem* item = loot->LootItemInSlot(i, player);
                        if (item && item->itemid > 0)  // Making sure the item is valid
                        {
                            player->AddItem(item->itemid, item->count);
                            loot->NotifyItemRemoved(i); // Notify to remove the loot
                        }
                    }

                    // Mark loot as fully looted
                    loot->NotifyMoneyRemoved();
                    loot->clear();
                }
            }
        }
    }
};

void AddSC_AutoLoot()
{
    new AutoLoot();
}

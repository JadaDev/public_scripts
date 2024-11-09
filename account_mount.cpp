//Created by ?? Updated by JadaDev

#include "DatabaseEnv.h"
#include "DBCStores.h"
#include "WorldSession.h"

class AccountMounts : public PlayerScript
{
public:
    static const bool limitRace = false; // Set to true to only learn mounts from characters on the same team.

    AccountMounts() : PlayerScript("AccountMounts") { }

    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        if (!player)
            return;

        uint32 accountId = player->GetSession()->GetAccountId();
        if (accountId == 0)
            return;

        // Get characters on the same account with optional race/team limitation
        std::vector<uint32> characterGuids;
        std::string characterQuery = "SELECT guid, race FROM characters WHERE account = " + std::to_string(accountId);
        QueryResult characterResult = CharacterDatabase.Query(characterQuery.c_str());
        if (!characterResult)
            return;

        do
        {
            Field* fields = characterResult->Fetch();
            uint32 charGuid = fields[0].GetUInt32();
            uint32 charRace = fields[1].GetUInt8();

            if (!limitRace || Player::TeamForRace(charRace) == Player::TeamForRace(player->GetRace()))
            {
                characterGuids.push_back(charGuid);
            }
        } while (characterResult->NextRow());

        // Collect all unique mount spells across eligible characters
        std::unordered_set<uint32> mountSpells;

        for (const auto& charGuid : characterGuids)
        {
            std::string spellQuery = "SELECT spell FROM character_spell WHERE guid = " + std::to_string(charGuid);
            QueryResult spellResult = CharacterDatabase.Query(spellQuery.c_str());
            if (!spellResult)
                continue;

            do
            {
                uint32 spellId = spellResult->Fetch()[0].GetUInt32();
                auto spellEntry = sSpellStore.LookupEntry(spellId);

                // Check if spell is a mount spell before adding it
                if (spellEntry && spellEntry->Effect[0] == SPELL_EFFECT_APPLY_AURA && spellEntry->EffectAura[0] == SPELL_AURA_MOUNTED)
                {
                    mountSpells.insert(spellId);
                }
            } while (spellResult->NextRow());
        }

        // Teach player each unique mount spell
        for (const auto& spellId : mountSpells)
        {
            player->LearnSpell(spellId, false);
        }
    }
};

void AddSC_accountmounts()
{
    new AccountMounts();
}

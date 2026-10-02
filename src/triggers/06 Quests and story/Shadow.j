library TShadow requires optional TShadowCombat, optional TShadowHiring, optional TShadowLifecycle, optional TShadowLoyalty, optional TShadowSupport
function InitTrig_Shadow takes nothing returns nothing
endfunction

// Startup registration: creates the triggers below, in this order. Called once from
// Startup_RegisterTriggers (MapBootstrap). Each Register_* function sits in the module that
// holds that trigger's code (search for its name).
function RegisterTriggers_Shadow takes nothing returns nothing
    static if LIBRARY_TShadowLifecycle then
        call Register_Shadow_Init()
        call Register_Shadow_FirstAppear() // starts off; run by Cid, Mid
        call Register_Shadow_Intro() // starts off; enabled by Shadow_Lifecycle; disabled by Shadow_Lifecycle; destroyed by Shadow_Lifecycle
        call Register_Shadow_Respawn() // starts off; enabled by Shadow_Lifecycle, Shadow_Hiring; run by Shadow_Lifecycle
        call Register_Shadow_Leave() // enabled by Shadow_Lifecycle; disabled by Shadow_Hiring
        call Register_Shadow_NearbyDelay() // starts off; enabled by Shadow_Lifecycle; disabled by Shadow_Hiring
    endif
    static if LIBRARY_TShadowHiring then
        call Register_Shadow_Hire() // starts off; enabled by Shadow_Lifecycle; disabled by Shadow_Hiring; destroyed by Shadow_Hiring
    endif
    static if LIBRARY_TShadowLifecycle then
        call Register_Shadow_Death() // starts off; enabled by Shadow_Hiring; run by Quest_LostMemories
    endif
    static if LIBRARY_TShadowLoyalty then
        call Register_Shadow_LoyaltyTick() // starts off; enabled by Shadow_Hiring; disabled by Shadow_Hiring, Shadow_Lifecycle; destroyed by Shadow_Hiring
        call Register_Shadow_KillCount() // starts off; enabled by Shadow_Hiring; disabled by Shadow_Hiring, Shadow_Lifecycle; destroyed by Shadow_Hiring
        call Register_Shadow_AttackedByParty() // starts off; enabled by Shadow_Hiring; disabled by Shadow_Hiring, Shadow_Lifecycle; destroyed by Shadow_Hiring
        call Register_Shadow_HealedBonus() // starts off; enabled by Shadow_Hiring; disabled by Shadow_Hiring, Shadow_Lifecycle; destroyed by Shadow_Hiring
    endif
    static if LIBRARY_TShadowSupport then
        call Register_Shadow_HeroDrink() // starts off
    endif
    static if LIBRARY_TShadowHiring then
        call Register_Shadow_Disband() // starts off; run by Shadow_Hiring, Shadow_Lifecycle, Shadow_Loyalty
    endif
    static if LIBRARY_TShadowCombat then
        call Register_Shadow_FumaShuriken()
    endif
endfunction

endlibrary

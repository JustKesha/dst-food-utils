--- This script returns a table (FOOD_MAKER) containing helper functions
--- related to creating food items

local FOOD_MAKER = {}

--- Creates and returns an entity instance for a generic food item
--- using common components
--- @param options PersonOptions?
--- @param options.inst Entity? entity inst to originate from
--- @param options.type string? type
--- @param options.health number? health buff
--- @param options.hunger number? hunger buff
--- @param options.sanity number? sanity buff
--- @param options.texture string? inventory texture
--- @param options.atlas string? inventory texture atlas
--- @param options.anim_bank string? animations bank
--- @param options.anim_build string? animation build
--- @param options.anim_start string? starting animation
--- @param options.sound string? pickup sound
--- @param options.temp_bonus number? temperature buff
--- @param options.temp_duration number? temperature buff duration
--- @param options.degrades boolean? does it spoil
--- @param options.spoil_time number? spoil time
--- @param options.spoil_into string? object to swap with once spoiled
--- @param options.stack integer? max stack size
--- @return Entity
function FOOD_MAKER.CreateFoodEntity(options)
    options = options or {}
    local params = {
        inst = options.inst or CreateEntity(),
        type = options.type or FOODTYPE.GENERIC,
        health = options.health or 0,
        hunger = options.hunger or 0,
        sanity = options.sanity or 0,
        texture = options.texture or "meatballs",
        atlas = options.atlas or "images/inventoryimages.xml",
        anim_bank = options.anim_bank or "berries",
        anim_build = options.anim_build or anim_bank,
        anim_start = options.anim_start or "idle",
        sound = options.sound or "generic",
        temp_bonus = options.temp_bonus or 0,
        temp_duration = options.temp_duration or TUNING.FOOD_TEMP_AVERAGE,
        degrades = (options.degrades ~= nil) and options.degrades or true,
        spoil_time = options.spoil_time or TUNING.PERISH_MED,
        spoil_into = options.spoil_into or "spoiled_food",
        stack = options.stack or TUNING.STACK_SIZE_SMALLITEM,
    }

    local inst = params.inst

    -- ! GENERIC
    inst.entity:AddTransform() -- Position & scale
    inst.entity:AddAnimState() -- Texture
    inst.entity:AddNetwork()   -- Networking

    -- Dont force to sync state with all clients at spawn
    -- ? Remove for objects with a dynamic initial state
    inst.entity:SetPristine()  -- No immediate state syncing

    -- ! APPEARANCE
    inst.AnimState:SetBuild(params.anim_build)      -- Animations set
    inst.AnimState:SetBank(params.anim_bank)        -- Textures
    inst.AnimState:PlayAnimation(params.anim_start) -- Animation starter

    inst.pickupsound = params.sound

    -- Clients stop here (logic is for the server)
    if not TheWorld or not TheWorld.ismastersim then
        return inst
    end

    -- ! COMPONENTS
    -- ITEM
    inst:AddComponent("inspectable")

    MakeHauntableLaunch(inst)
    MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = params.texture
    inst.components.inventoryitem.atlasname = params.atlas

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = params.stack

    -- FOOD
    inst:AddComponent("edible")
    inst.components.edible.foodtype = params.type
    inst.components.edible.healthvalue = params.health
    inst.components.edible.hungervalue = params.hunger
    inst.components.edible.sanityvalue = params.sanity
    inst.components.edible.temperaturedelta = params.temp_bonus
    inst.components.edible.temperatureduration = params.temp_duration
    inst.components.edible.degrades_with_spoilage = params.degrades

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(params.spoil_time)
    inst.components.perishable:StartPerishing()
    inst.components.perishable.onperishreplacement = params.spoil_into

    return inst
end

--- Wrapper for CreateFoodEntity
--- @param inst Entity?
--- @param options table?
--- @return Entity
function FOOD_MAKER.MakeFoodGeneric(inst, options)
    options = options or {}
    options.inst = inst
    return FOOD_MAKER.CreateFoodEntity(options)
end

return FOOD_MAKER
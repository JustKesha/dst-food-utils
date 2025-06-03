local DISH_MAKER = {}

--- Creates and returns a simple recipe table from the given arguments
--- @param name string prefab name
--- @param fn function function(cooker, names, tags) -> boolean
--- @param cooktime number?
--- @param potlevel string? how high in the pot to spawn the dish
--- @param category string? for the cookbook
--- @param priority number?
--- @return table recipe
function DISH_MAKER.CreateRecipe(name, fn, cooktime, potlevel, category, priority)
    return {
        name = name,
        test = fn,

        -- ? What about those values set up on the prefab
        foodtype = FOODTYPE.MEAT,
        health = TUNING.HEALING_MED,
        hunger = TUNING.CALORIES_LARGE,
        sanity = TUNING.SANITY_TINY,
        perishtime = TUNING.PERISH_SLOW,
        cooktime = cooktime or TUNING.BASE_COOK_TIME,

        potlevel = potlevel or "high",
        cookbook_category = category,
        priority = priority or 40, -- Will overwrite most default recipes
        weight = 1,
    }
end

--- Adds given recipe to all specified cooking stations
--- @param recipe table
--- @param cookpot boolean?
--- @param portable boolean?
--- @param archive boolean?
function DISH_MAKER.AddRecipe(recipe, cookpot, portable, archive)
    if cookpot ~= nil then
        -- Keep existing cookpot value
    elseif recipe and recipe.cookpot ~= nil then
        cookpot = recipe.cookpot
    else
        cookpot = true -- Default
    end

    if portable ~= nil then
        -- Keep existing portable value
    elseif recipe and recipe.portable ~= nil then
        portable = recipe.portable
    else
        portable = true -- Default
    end

    if archive ~= nil then
        -- Keep existing archive value
    elseif recipe and recipe.archive ~= nil then
        archive = recipe.archive
    else
        archive = true -- Default
    end

    if cookpot then
        AddCookerRecipe("cookpot", recipe, true)
    end
    if portable then
        AddCookerRecipe("portablecookpot", recipe, true)
    end
    if archive then
        AddCookerRecipe("archivecookpot", recipe, true)
    end
end

--- Adds given recipe as a Warly's special (meaning it can only be crafted
--- by Warly in a portable crock pot)
--- @param recipe table
function DISH_MAKER.AddWarlySpecial(recipe)
    DISH_MAKER.AddRecipe(recipe, false, true, false)
end

--- Adds all recipes from the given table to all specified cooking stations
--- @param recipes table
--- @param cookpot boolean?
--- @param portable boolean?
--- @param archive boolean?
function DISH_MAKER.AddRecipes(recipes, cookpot, portable, archive)
    for index, recipe in ipairs(recipes) do
        DISH_MAKER.AddRecipe(recipe, cookpot, portable, archive)
    end
end

--- Creates and adds a new recipe to all specified cooking stations
--- @param name string prefab name
--- @param fn function function(cooker, names, tags) -> boolean
--- @param category string? for the cookbook
--- @param priority number?
--- @param cookpot boolean?
--- @param portable boolean?
--- @param archive boolean?
function DISH_MAKER.NewRecipe(name, fn, cooktime, category, priority, cookpot, portable, archive)
    DISH_MAKER.AddRecipe(
        DISH_MAKER.CreateRecipe(name, fn, cooktime, category, priority),
        cookpot, portable, archive
    )
end

return DISH_MAKER
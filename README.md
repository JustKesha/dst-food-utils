# 🍖 DST Food & Dish Utilities
This is a set of utility functions for dst modding that allows to create food and dish items using much less code.<br>
It uses common components neatly wrapped into 7 helper functions like `MakeFoodGeneric`.

## Usage

Example food item prefab with default textures:

```lua
-- scripts/prefabs/snozzberries.lua

local foodmaker = require("../util/food")

local asset = "snozzberries"
local assets = {}
local prefabs = {}

return Prefab(
    "common/inventory/" .. asset,
    function() return foodmaker.CreateFoodEntity({
        health = 5,
        hunger = 2,
        sanity = -2,
        stack = 8,
    }) end,
    assets, prefabs
)
```

Or you can use `MakeFoodGeneric` to add all commonly used for food items components to your already existing entity instance.

## Functions

`util/food.lua`
- CreateFoodEntity - Creates and returns an entity instance for a generic food item using common components
- MakeFoodGeneric - Wrapper for CreateFoodEntity

`util/dish.lua`
- CreateRecipe - Creates and returns a simple recipe table from the given arguments
- AddRecipe - Adds given recipe to all specified cooking stations
- AddWarlySpecial - Adds given recipe as a Warly's special (meaning it can only be crafted by Warly in a portable crock pot)
- AddRecipes - Adds all recipes from the given table to all specified cooking stations
- NewRecipe - Creates and adds a new recipe to all specified cooking stations

> [!NOTE]
> These functions are not added to the global modding environment (like for example `MakeHauntableLaunch` and `MakeSmallBurnable` from `standardcomponents.lua` are).
> It means that to access them, you will first need to make an import using the `require` statement like in example.

> [!TIP]
> If you're using VSCode, you can add any of the top lua extension for easier time reading documentation.

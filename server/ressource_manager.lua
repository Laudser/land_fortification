-- resource_manager.lua

-- Définissez les quantités de matériaux par défaut et maximales ici
local DEFAULT_MATERIALS = 100
local MAX_MATERIALS = 200

-- Créez une table pour stocker les ressources du joueur
local PLAYER_RESOURCES = {}

-- Gérez les types de ressources ici
local RESOURCE_TYPES = {
   "Materials",  -- Exemple : Matériaux
   "Medical",    -- Exemple : Matériel médical
   "Ammunition", -- Exemple : Munitions
}

-- Initialisation des ressources pour chaque joueur
hook.Add("PlayerInitialSpawn", "InitializePlayerResources", function(ply)
   PLAYER_RESOURCES[ply] = {}
   for _, resourceType in pairs(RESOURCE_TYPES) do
      PLAYER_RESOURCES[ply][resourceType] = DEFAULT_MATERIALS
   end
end)

-- Fonction pour ajouter des ressources à un joueur
function GM:GiveResources(ply, resourceType, amount)
   if not IsValid(ply) or not resourceType then return end

   if PLAYER_RESOURCES[ply] and PLAYER_RESOURCES[ply][resourceType] then
      local currentAmount = PLAYER_RESOURCES[ply][resourceType]
      local newAmount = math.min(currentAmount + amount, MAX_MATERIALS)
      PLAYER_RESOURCES[ply][resourceType] = newAmount
   end
end

-- Fonction pour enlever des ressources à un joueur
function GM:RemoveResources(ply, resourceType, amount)
   if not IsValid(ply) or not resourceType then return end

   if PLAYER_RESOURCES[ply] and PLAYER_RESOURCES[ply][resourceType] then
      local currentAmount = PLAYER_RESOURCES[ply][resourceType]
      PLAYER_RESOURCES[ply][resourceType] = math.max(0, currentAmount - amount)
   end
end

-- Fonction pour obtenir le montant de ressources d'un joueur
function GM:GetResourceAmount(ply, resourceType)
   if not IsValid(ply) or not resourceType then return 0 end

   if PLAYER_RESOURCES[ply] and PLAYER_RESOURCES[ply][resourceType] then
      return PLAYER_RESOURCES[ply][resourceType]
   end

   return 0
end

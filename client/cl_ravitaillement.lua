-- Gérez les catégories des caisses de ravitaillement
local CATEGORIES = {
    ["Materials"] = { -- Catégorie pour les matériaux
       ["prop_materials_crate"] = {
          Model = "models/props_c17/oildrum001.mdl", -- Remplacez par le modèle du crate de matériaux
          ResourceType = "Materials", -- Type de ressource
       },
       -- Ajoutez d'autres caisses de matériaux ici
    },
    ["Medical"] = { -- Catégorie pour le matériel médical
       ["prop_medical_crate"] = {
          Model = "models/props_junk/cardboard_box004a.mdl", -- Remplacez par le modèle du crate de matériel médical
          ResourceType = "Medical", -- Type de ressource
       },
       -- Ajoutez d'autres caisses de matériel médical ici
    },
 }
 
 -- Gérez les coûts de ressources pour chaque caisse de ravitaillement
 local RESOURCE_COSTS = {
    ["Materials"] = 50, -- Coût en ressources pour les caisses de matériaux
    ["Medical"] = 30, -- Coût en ressources pour les caisses de matériel médical
 }
 
 function SWEP:Reload()
    local ply = self:GetOwner()
    local tr = ply:GetEyeTrace()
    local ent = tr.Entity
 
    if not IsValid(ent) or not ent:IsPlayer() then return end
 
    if CLIENT then
       -- Affichez le menu de sélection de catégorie
       -- Vous devrez implémenter la logique du menu ici
    end
 end
 
 function SWEP:SecondaryAttack()
    -- Gérez la création des caisses de ravitaillement ici
    -- Vous devrez sélectionner la catégorie en fonction du menu de sélection
 
    -- Exemple : Créez une caisse de matériaux
    local category = "Materials" -- Remplacez par la catégorie sélectionnée
    local selectedCrate = "prop_materials_crate" -- Remplacez par la caisse sélectionnée
 
    if SERVER then
       if not self:HasEnoughResources(category) then
          return
       end
 
       local crateInfo = CATEGORIES[category][selectedCrate]
 
       if crateInfo then
          -- Créez la caisse de ravitaillement en utilisant le modèle et le type de ressource
          local crate = ents.Create("ent_crate") -- Remplacez "ent_crate" par le nom de votre entité de caisse
          crate:SetModel(crateInfo.Model)
          crate:SetPos(self:GetOwner():GetEyeTrace().HitPos)
          crate:SetResourceType(crateInfo.ResourceType)
          crate:Spawn()
 
          -- Déduisez le coût des ressources
          self:ConsumeResources(category)
       end
    end
 end
 
 function SWEP:HasEnoughResources(category)
    local ply = self:GetOwner()
    return ply:GetResourceAmount(category) >= RESOURCE_COSTS[category]
 end
 
 function SWEP:ConsumeResources(category)
    local ply = self:GetOwner()
    ply:RemoveResources(category, RESOURCE_COSTS[category])
 end
 
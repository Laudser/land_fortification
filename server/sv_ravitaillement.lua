if SERVER then
    local ply = self:GetOwner()

    if not self:HasEnoughResources(category) then
       return
    end

    local crateInfo = CATEGORIES[category][selectedCrate]

    if crateInfo then
       -- Créez la caisse de ravitaillement en utilisant le modèle et le type de ressource
       local crate = ents.Create("ent_crate") -- Remplacez "ent_crate" par le nom de votre entité de caisse
       crate:SetModel(crateInfo.Model)
       crate:SetPos(ply:GetEyeTrace().HitPos)
       crate:SetResourceType(crateInfo.ResourceType)
       crate:Spawn()

       -- Déduisez le coût des ressources
       self:ConsumeResources(category)
    end
 end
end

-- Gérez les ressources en fonction de la catégorie
function SWEP:HasEnoughResources(category)
 local ply = self:GetOwner()
 return SERVER and ply:GetResourceAmount(category) >= RESOURCE_COSTS[category]
end

function SWEP:ConsumeResources(category)
 local ply = self:GetOwner()
 if SERVER then
    ply:RemoveResources(category, RESOURCE_COSTS[category])
 end
end
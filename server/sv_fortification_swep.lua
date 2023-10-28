if SERVER then
    AddCSLuaFile()
    util.AddNetworkString("Fortification_SWEP")
 end
 
 SWEP.PrintName = "Fortification Tool"
 SWEP.Author = "Landser"
 SWEP.Slot = 5
 SWEP.SlotPos = 5
 SWEP.DrawAmmo = false
 SWEP.DrawCrosshair = true
 SWEP.ViewModelFOV = 54
 SWEP.ViewModelFlip = false
 SWEP.ViewModel = "models/weapons/c_toolgun.mdl"
 SWEP.WorldModel = "models/weapons/w_toolgun.mdl"
 
 SWEP.Spawnable = true
 SWEP.AdminSpawnable = true
 SWEP.Category = "Lands SWEPS"
 
 SWEP.Primary.ClipSize = -1
 SWEP.Primary.DefaultClip = -1
 SWEP.Primary.Automatic = true
 SWEP.Primary.Ammo = "none"
 
 SWEP.Secondary.ClipSize = -1
 SWEP.Secondary.DefaultClip = -1
 SWEP.Secondary.Automatic = true
 SWEP.Secondary.Ammo = "none"
 
 SWEP.Weight = 1
 SWEP.AutoSwitchTo = false
 SWEP.AutoSwitchFrom = false
 
 function SWEP:Initialize()
    self:SetHoldType("pistol")
 end
 
 function SWEP:PrimaryAttack()
    local ply = self:GetOwner()
    if not IsFirstTimePredicted() then return end
 
    -- Ici, vous pouvez afficher un menu de sélection des props pour que le joueur en choisisse un
    -- Une fois qu'un prop est sélectionné, vous pouvez utiliser son nom/identifiant pour placer le bon prop du fichier "props_placables.lua"
 
    -- Exemple pour la construction
    local selectedPropName = "prop1" -- Remplacez par la sélection du prop

    local clicksRequired = PROPS[selectedPropName].ClicksRequired
    local currentClicks = self:GetNWInt("Clicks", 0) -- Récupérez le compteur de clics

    if currentClicks < clicksRequired then
        currentClicks = currentClicks + 1 -- Incrémentation du compteur de clics
        self:SetNWInt("Clicks", currentClicks) -- Mettez à jour le compteur de clics
    -- Mettez à jour la barre de progression en fonction de currentClicks / clicksRequired
    end

    if currentClicks >= clicksRequired then
        -- Effectuez la construction
        self:SetNWInt("Clicks", 0) -- Réinitialisez le compteur de clics

 
    -- Code pour la gestion de la construction du prop
    local progress = 0.5  -- Exemple : Remplacez progress par la valeur réelle de progression
 
    -- Ici, assurez-vous de vérifier les ressources, de gérer la barre d'état et d'ajouter le prop lorsqu'il est entièrement construit
    if progress >= 1.0 then
       -- Ajoutez le prop sélectionné à l'emplacement spécifié en utilisant son nom/identifiant
       local selectedProp = PROPS[selectedPropName]  -- Utilisez la table des props de "props_placables.lua"
       if selectedProp then
          local prop = ents.Create(selectedProp.Model)
          prop:SetPos(ply:GetEyeTrace().HitPos)
          prop:Spawn()
       end
    end
 
    -- Ensuite, envoyez des informations au client pour mettre à jour la barre de progression et le prop sélectionné
    net.Start("Fortification_SWEP")
    net.WriteFloat(progress)
    net.WriteString(selectedPropName)  -- Envoyez le nom/identifiant du prop sélectionné
    net.Send(ply)
 end
 
 function SWEP:SecondaryAttack()
    local ply = self:GetOwner()
    if not IsFirstTimePredicted() then return end
 
    -- Ici, vous pouvez afficher un menu de sélection des props pour que le joueur en choisisse un
    -- Une fois qu'un prop est sélectionné, vous pouvez utiliser son nom/identifiant pour déconstruire le bon prop du fichier "props_placables.lua"
 
    local selectedPropName = "prop1"  -- Exemple : Remplacez par le nom/identifiant du prop sélectionné
 
    -- Code pour la gestion de la déconstruction du prop
    local progress = 0.25  -- Exemple : Remplacez progress par la valeur réelle de progression
 
    -- Ici, assurez-vous de gérer la barre d'état et de détruire le prop lorsque la déconstruction est terminée
    if progress >= 1.0 then
       local trace = ply:GetEyeTrace()
       local ent = trace.Entity
       if IsValid(ent) and ent:GetClass() == selectedPropName then
          ent:Remove()
       end
    end
 
    -- Ensuite, envoyez des informations au client pour mettre à jour la barre de progression et le prop sélectionné
    net.Start("Fortification_SWEP")
    net.WriteFloat(progress)
    net.WriteString(selectedPropName)  -- Envoyez le nom/identifiant du prop sélectionné
    net.Send(ply)
 end
 
 if CLIENT then
    function SWEP:DrawHUD()
       -- Code pour afficher la barre de progression sur l'interface utilisateur du client
       -- Utilisez les informations reçues du serveur pour afficher la progression ici
       local progress = net.ReadFloat()  -- Lire la progression depuis le serveur
       local selectedPropName = net.ReadString()  -- Lire le nom/identifiant du prop sélectionné
       local scrW, scrH = ScrW(), ScrH()
       local width, height, padding = 200, 20, 10
       local x, y = (scrW - width) / 2, scrH - height - padding
 
       draw.RoundedBox(4, x, y, width, height, Color(0, 0, 0, 150))  -- Fond de la barre
       draw.RoundedBox(4, x, y, width * progress, height, Color(0, 255, 0, 255))  -- Barre de progression
    end
 
    net.Receive("Fortification_SWEP", function()
       local progress = net.ReadFloat()  -- Lire la progression depuis le serveur
       -- Mettez à jour l'interface utilisateur avec la nouvelle progression
    end)
 end
 
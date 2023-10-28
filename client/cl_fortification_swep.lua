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
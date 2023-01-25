local PANEL = {}

local validRoles = {
    traitor = true,
    detective = true
}

function PANEL:Init()
    self:SetSkin(Pointshop2.Config.DermaSkin)

    self:addSectionTitle("Icon Settings")

    local defaultMat = "pointshop2/crime1.png";

    self.selectMatElem = vgui.Create("DPanel")
    self.selectMatElem:SetTall(64)
    self.selectMatElem:SetWide(self:GetWide())
    function self.selectMatElem:Paint()
    end

    self.materialPanel = vgui.Create("DImage", self.selectMatElem)
    self.materialPanel:SetSize(64, 64)
    self.materialPanel:Dock(LEFT)
    self.materialPanel:SetMouseInputEnabled(true)
    self.materialPanel:SetTooltip("Click to Select")
    self.materialPanel:SetMaterial(defaultMat)
    local frame = self
    function self.materialPanel:OnMousePressed()
        -- Open model selector
        local window = vgui.Create("DMaterialSelector")
        window:Center()
        window:MakePopup()
        window:DoModal()
        Pointshop2View:getInstance():requestMaterials("pointshop2"):Done(function(files)
            window:SetMaterials("pointshop2", files)
        end)
        function window:OnChange()
            frame.manualEntry:SetText(window.matName)
            frame.materialPanel:SetMaterial(window.matName)
        end
    end

    local rightPnl = vgui.Create("DPanel", self.selectMatElem)
    rightPnl:Dock(FILL)
    function rightPnl:Paint()
    end

    self.manualEntry = vgui.Create("DTextEntry", rightPnl)
    self.manualEntry:Dock(TOP)
    self.manualEntry:DockMargin(5, 0, 5, 5)
    self.manualEntry:SetText(defaultMat)
    self.manualEntry:SetTooltip("Click on the icon or manually enter the material path here and press enter")
    function self.manualEntry:OnEnter()
        frame.materialPanel:SetMaterial(self:GetText())
    end

    self.infoPanel = vgui.Create("DInfoPanel", self)
    self.infoPanel:SetSmall(true)
    self.infoPanel:Dock(TOP)
    self.infoPanel:SetInfo("Materials Location", [[To add a material to the selector, put it into this folder: 
addons/ps2_materials/materials/pointshop2
Don't forget to upload the material to your fastdl, too!]])
    self.infoPanel:DockMargin(5, 5, 5, 5)

    local cont = self:addFormItem("Material", self.selectMatElem)
    cont:SetTall(64)

    timer.Simple(0, function()
        self:Center()
    end)

    self:addSectionTitle("Pass Settings")

    self.roleChoice = vgui.Create("DRadioChoice", self)
    self.roleChoice:DockMargin(5, 5, 5, 5)
    self.roleChoice:Dock(TOP)

    for k, v in pairs(validRoles) do
        self.roleChoice:AddOption(k)
    end

    function self.roleChoice:PerformLayout()
        self:SizeToChildren(false, true)
    end

end

function PANEL:SaveItem(saveTable)
    self.BaseClass.SaveItem(self, saveTable)

    saveTable.material = self.manualEntry:GetText()
    saveTable.role = self.roleChoice:GetSelectedOption():GetText()
end

function PANEL:EditItem(persistence, itemClass)
    -- self.BaseClass.EditItem(self, persistence.ItemPersistence, itemClass)

    self.manualEntry:SetText(persistence.material)
    self.materialPanel:SetMaterial(persistence.material)
    self.roleChoice:SelectChoiceByText(persistence.role)
end

function PANEL:Validate(saveTable)
    local succ, err = self.BaseClass.Validate(self, saveTable)
    if not succ then
        return succ, err
    end

    local roleChoice = self.roleChoice:GetSelectedOption()

    if not roleChoice then
        return false, "No role selected."
    end

    if not validRoles[roleChoice:GetText()] then
        return false, "Invalid role selected."
    end

    return true
end

vgui.Register("DPassCreator", PANEL, "DItemCreator")

class X2StrategyElement_ProductionTechs extends X2StrategyElement config(Production);

struct ProductionConversion {
	var name ItemName;
	var name ProjectName;
	var int TimeDays;
	var string Type;
};

var config array<ProductionConversion> ProductionProjects;

static function array<X2DataTemplate> CreateTemplates()
{
	local X2ItemTemplateManager ItemTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local array<X2DataTemplate> Techs;
	local ProductionConversion Project;
	local string ImageStr;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.ProductionProjects(Project)
	{
		ItemTemplate = ItemTemplateManager.FindItemTemplate(Project.ItemName);

		if (ItemTemplate == none)
		{
			`RedScreen(Project.ItemName $ " is an invalid template, production conversion failed!");
			continue;
		}

		ImageStr = GetImageStr(Project.Type);
		Techs.AddItem(CreateProductionLineTemplate(Project.ProjectName, Project.TimeDays, ImageStr));
	}

	return Techs;
}

static function string GetImageStr(string Type)
{
	//return "img:///UILibrary_Production.Inv_Production";
	//return "img:///UILibrary_Production.Inv_Machinery";

	if (Type == "Ammo")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Ammo";
	}
	else if (Type == "Grenade1")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Experimental_Grenade";
	}
	else if (Type == "Grenade2")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Advanced_Grenade_Project'";
	}
	else if (Type == "Vest")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_ExperimentalArmor";
	}
	else if (Type == "Heavy1")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Heavy_Weapons_Project";
	}
	else if (Type == "Heavy2")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_AdvHeavy_Weapons_Project";
	}
	else if (Type == "Weapon")
	{
		return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Modular_Weapons";
	}
	else
	{
		return "img:///UILibrary_Production.Inv_Production";
		//return "img:///UILibrary_StrategyImages.ResearchTech.TECH_Bluescreen_Project";
	}
}

static function X2DataTemplate CreateProductionLineTemplate(name TemplateName, optional int TimeToComplete, optional string ImageString)
{
	local X2TechTemplate Template;

	`CREATE_X2TEMPLATE(class'X2TechTemplate', Template, name("ProductionLine_" $ string(TemplateName)));
	Template.SortingTier = 3;
	Template.strImage = ImageString;
	Template.bProvingGround = true;
	Template.PointsToComplete = StafferXDays(1, TimeToComplete);

	return Template;
}

// Helper function for calculating project time
static function int StafferXDays(int iNumEngineers, int iNumDays)
{
	return (iNumEngineers * 5) * (24 * iNumDays); // Engineers at base skill level
}

static function ConnectItemsToProjects()
{
	local ProductionConversion Project;
	local X2ItemTemplateManager ItemTemplateManager;
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local X2ItemTemplate ItemTemplate;
	local X2TechTemplate TechTemplate;
	
	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();
	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();

	foreach default.ProductionProjects(Project)
	{
		ItemTemplate = ItemTemplateManager.FindItemTemplate(Project.ItemName);

		if (ItemTemplate == none)
		{
			continue;
		}

		TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate(name("ProductionLine_" $ string(Project.ProjectName))));
		
		if (TechTemplate == none)
		{
			continue;
		}

		ItemTemplate.Requirements.RequiredTechs.Length = 0;
		ItemTemplate.Requirements.RequiredTechs.AddItem(name("ProductionLine_" $ string(Project.ProjectName)));
		ItemTemplate.CanBeBuilt = true;
	}
}

static function DeleteExperimentalProjects()
{
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local X2TechTemplate TechTemplate;
	
	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	
	TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('ExperimentalAmmo'));
	if (TechTemplate != none)
	{
		TechTemplate.Requirements.RequiredTechs.Length = 0;
		TechTemplate.Requirements.RequiredTechs.AddItem('ExperimentalGrenade');
	}

	TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('ExperimentalGrenade'));
	if (TechTemplate != none)
	{
		TechTemplate.Requirements.RequiredTechs.Length = 0;
		TechTemplate.Requirements.RequiredTechs.AddItem('ExperimentalArmor');
	}

	TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('ExperimentalArmor'));
	if (TechTemplate != none)
	{
		TechTemplate.Requirements.RequiredTechs.Length = 0;
		TechTemplate.Requirements.RequiredTechs.AddItem('HeavyWeapons');
	}

	TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('HeavyWeapons'));
	if (TechTemplate != none)
	{
		TechTemplate.Requirements.RequiredTechs.Length = 0;
		TechTemplate.Requirements.RequiredTechs.AddItem('AdvancedHeavyWeapons');
	}

	TechTemplate = X2TechTemplate(StrategyTemplateManager.FindStrategyElementTemplate('AdvancedHeavyWeapons'));
	if (TechTemplate != none)
	{
		TechTemplate.Requirements.RequiredTechs.Length = 0;
		TechTemplate.Requirements.RequiredTechs.AddItem('ExperimentalAmmo');
	}
}
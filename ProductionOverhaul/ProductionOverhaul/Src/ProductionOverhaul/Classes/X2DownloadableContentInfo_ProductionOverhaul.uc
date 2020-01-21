//---------------------------------------------------------------------------------------
//  FILE:   XComDownloadableContentInfo_ProductionOverhaul.uc                                    
//           
//	Use the X2DownloadableContentInfo class to specify unique mod behavior when the 
//  player creates a new campaign or loads a saved game.
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------

class X2DownloadableContentInfo_ProductionOverhaul extends X2DownloadableContentInfo config(XComProduction);

var config int SquadSize1_XAP;
var config int SquadSize2_XAP;

static event OnPostTemplatesCreated()
{
	class'X2StrategyElement_ProductionTechs'.static.ConnectItemsToProjects();
	class'X2StrategyElement_ProductionTechs'.static.DeleteExperimentalProjects();

	EditAcademyUnlocks();
}

static function EditAcademyUnlocks()
{
	local X2StrategyElementTemplateManager StrategyTemplateManager;
	local X2SoldierUnlockTemplate Template;
	local ArtifactCost Resources;
	
	StrategyTemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	
	Template = X2SoldierUnlockTemplate(StrategyTemplateManager.FindStrategyElementTemplate('SquadSizeIUnlock'));
	Template.Cost.ResourceCosts.Length = 0;
	Resources.ItemTemplateName = 'AbilityPoint';
	Resources.Quantity = 15;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template = X2SoldierUnlockTemplate(StrategyTemplateManager.FindStrategyElementTemplate('SquadSizeIIUnlock'));
	Template.Cost.ResourceCosts.Length = 0;
	Resources.ItemTemplateName = 'AbilityPoint';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);
}

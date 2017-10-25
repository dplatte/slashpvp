class StatsController < ApplicationController

	def index

	    races_table = GoogleVisualr::DataTable.new
	    races_table.new_column('string', 'Race' )
		races_table.new_column('number', 'Characters')

		CharacterRace.all.each do |r|
	    	races_table.add_row([r.name, Character.where(bracket: current_bracket, region: current_region, character_race: r).count])
	    end

	    class_colors = HashWithIndifferentAccess.new({
	    	'Death Knight': '#C41F3B',
	    	'Demon Hunter': '#A330C9',
	    	'Druid': '#FF7D0A',
	    	'Hunter': '#ABD473',
	    	'Mage': '#69CCF0',
	    	'Monk': '#00FF96',
	    	'Paladin': '#F58CBA',
	    	'Priest': '#FFFFFF',
	    	'Rogue': '#FFF569',
	    	'Shaman': '#0070DE',
	    	'Warlock': '#9482C9',
	    	'Warrior': '#C79C6E'
	    })

	    classes_colors = Array.new
	    classes_table = GoogleVisualr::DataTable.new
	    classes_table.new_column('string', 'Class' )
		classes_table.new_column('number', 'Characters')
		CharacterClass.all.each do |c|
	    	classes_table.add_row([c.name, Character.where(bracket: current_bracket, region: current_region, character_class: c).count])
	    	classes_colors.push(class_colors[c.name])
	    end

	    faction_colors = HashWithIndifferentAccess.new({
	    	'alliance': '#034390',
	    	'horde': '#9E0A00',
	    	'neutral': 'black'
	    })

	    factions_colors = Array.new
	    factions_table = GoogleVisualr::DataTable.new
	    factions_table.new_column('string', 'Class' )
		factions_table.new_column('number', 'Characters')
		Faction.all.each do |f|
			factions_table.add_row([f.name.capitalize, Character.where(bracket: current_bracket, region: current_region, faction: f).count])
			factions_colors.push(faction_colors[f.name])
		end

		races_options = { is3D: true, chartArea: {width: '95%', height: '95%'}, legend:{position:'none'}, pieSliceText: 'label', backgroundColor: '#ECF0F1' }
		classes_options = { is3D: true,chartArea: {width: '95%', height: '95%'}, legend:{position:'none'}, pieSliceText: 'label', colors: classes_colors, pieSliceTextStyle: { color: 'black'}, backgroundColor: '#ECF0F1' }
		factions_options = { is3D: true,chartArea: {width: '95%', height: '95%'}, legend:{position:'none'}, pieSliceText: 'label', colors: factions_colors, backgroundColor: '#ECF0F1' }
		@race_chart = GoogleVisualr::Interactive::PieChart.new(races_table, races_options)
		@class_chart = GoogleVisualr::Interactive::PieChart.new(classes_table, classes_options)
		@faction_chart = GoogleVisualr::Interactive::PieChart.new(factions_table, factions_options)
	end

end
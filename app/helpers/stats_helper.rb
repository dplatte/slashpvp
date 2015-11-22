module StatsHelper
  def pie_chart_for_solutions
    count = {}
    Character.where(bracket_id: 2, region_id: 1).all.each do |character|
      count[character.character_race] ||= 0
      count[character.character_race] += 1
    end

    total = Character.where(bracket_id: 2, region_id: 1).count
    data = count.collect { |race, number| number }
    labels = count.collect { |race, number| "#{race.name} (#{total == 0 ? 0 : (100.0 * number / total).round}%)" }

    Gchart.pie(:data => data, :labels => labels, :size => '695x431', :theme => :keynote)
  end
end
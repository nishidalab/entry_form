module ExperimentPlaceFormHelper
  def setup_ex_places(experiment)
    Place.all.each do |p|
      unless experiment.ex_places.select{|e| e.place_id == p.id}.any?
        experiment.ex_places.build({place_id: p.id})
      end
    end
    experiment
  end
  def setup_ex_places_attributes(params)
    attrs = params[:ex_places_attributes].dup.map{|k,v| v }
    params[:ex_places_attributes] = attrs.inject([]){ |res, attr|
      if attr[:apply].to_i == 0
        res.push({id: attr[:id], _destroy: 1}) if attr[:id].present?
      else
        res.push({id: attr[:id], place_id: attr[:place_id]})
      end
      res
    }
    params
  end
end

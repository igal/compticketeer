ActionController::Routing::Routes.draw do |map|
  map.resources :tickets

  map.resources :ticket_kinds

  map.resources :batches

  map.root :controller => :batches, :action => "new"
end

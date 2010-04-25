ActionController::Routing::Routes.draw do |map|
  map.resources :tickets
  map.resources :ticket_kinds
  map.resources :batches

  map.resource :user_session
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.root :controller => :batches, :action => "new"
end

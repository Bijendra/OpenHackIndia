Trippy::Application.routes.draw do
  root :to => 'plans#index'

  match 'plan' => 'plans#index'
  match 'plan/hotels' => "plans#hotels"
  match 'plan/restaurants' => "plans#restaurants"
end

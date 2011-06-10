 Rails.application.routes.draw do |map|
   resources :chimpactions, :except => [:show]
   match 'chimpactions/index', :to =>  'chimpactions#index'
 end
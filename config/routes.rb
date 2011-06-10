 Rails.application.routes.draw do |map|
   resources :chimpactions
   match 'chimpactions/index', :to =>  'chimpactions#index'
 end
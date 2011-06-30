 Rails.application.routes.draw do |map|
   resources :chimpactions, :except => [:show]
   match 'chimpactions/webhooks', :to => 'chimpactions#webhooks'
   match 'chimpactions/delete_webhook/:id', :to => 'chimpactions#delete_webhook'
   match 'chimpactions/add_webhook/:id', :to => 'chimpactions#add_webhook'
   match 'chimpactions/receive', :to => 'chimpacitons#receive', :as => :webhook
   match 'chimpactions/index', :to =>  'chimpactions#index'
 end
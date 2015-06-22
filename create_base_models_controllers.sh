#!/usr/bin/env bash
#rake db:create

#gem 'devise'
#rails generate devise:install
#rails generate devise User
#rails generate migration AddFieldsToUser name:string gender:boolean status:integer paid:date

#rails g model Reason user:integer name:string period:string duration_day:integer status:integer
#rails g model Agent user:integer name:string email:string img:string status:integer
#rails g model Message user:integer theme:string text:string status:integer
#rails g model From user:integer email:string status:integer
#rails g model Friend user:references name:string img:string cycle_day:integer status:integer
#rails g model Event user:integer friend:references reason:references begin_date:date period:string duration_day:integer shift_day:integer color:integer status:integer
#rails g model Letter user:integer event:references agent:references from:references message:references status:integer
#rails g model History user:references letter:references status:integer
rails g model Image user:integer who:string refer:integer url:string status:integer

#rake db:migrate

#rails g controller Pages index
#rails g controller Images create
#rails g controller Friends index new show edit create update destroy

rake routes

                  Prefix Verb   URI Pattern                       Controller#Action
                    root GET    /                                 pages#index
               user_root GET    /friends/index(.:format)          friends#index
        new_user_session GET    /users/sign_in(.:format)          devise/sessions#new
            user_session POST   /users/sign_in(.:format)          devise/sessions#create
    destroy_user_session DELETE /users/sign_out(.:format)         devise/sessions#destroy
           user_password POST   /users/password(.:format)         devise/passwords#create
       new_user_password GET    /users/password/new(.:format)     devise/passwords#new
      edit_user_password GET    /users/password/edit(.:format)    devise/passwords#edit
                         PATCH  /users/password(.:format)         devise/passwords#update
                         PUT    /users/password(.:format)         devise/passwords#update
cancel_user_registration GET    /users/cancel(.:format)           devise/registrations#cancel
       user_registration POST   /users(.:format)                  devise/registrations#create
   new_user_registration GET    /users/sign_up(.:format)          devise/registrations#new
  edit_user_registration GET    /users/edit(.:format)             devise/registrations#edit
                         PATCH  /users(.:format)                  devise/registrations#update
                         PUT    /users(.:format)                  devise/registrations#update
                         DELETE /users(.:format)                  devise/registrations#destroy
       user_confirmation POST   /users/confirmation(.:format)     devise/confirmations#create
   new_user_confirmation GET    /users/confirmation/new(.:format) devise/confirmations#new
                         GET    /users/confirmation(.:format)     devise/confirmations#show
                 friends GET    /friends(.:format)                friends#index
                         POST   /friends(.:format)                friends#create
                  friend GET    /friends/:id(.:format)            friends#show
                         PATCH  /friends/:id(.:format)            friends#update
                         PUT    /friends/:id(.:format)            friends#update
                         DELETE /friends/:id(.:format)            friends#destroy
                  images POST   /images(.:format)                 images#create
                  agents POST   /agents(.:format)                 agents#create
                   agent PATCH  /agents/:id(.:format)             agents#update
                         PUT    /agents/:id(.:format)             agents#update
                   froms POST   /froms(.:format)                  froms#create
                    from PATCH  /froms/:id(.:format)              froms#update
                         PUT    /froms/:id(.:format)              froms#update
                messages POST   /messages(.:format)               messages#create
                 message PATCH  /messages/:id(.:format)           messages#update
                         PUT    /messages/:id(.:format)           messages#update
                 reasons POST   /reasons(.:format)                reasons#create
                  reason PATCH  /reasons/:id(.:format)            reasons#update
                         PUT    /reasons/:id(.:format)            reasons#update
                  events POST   /events(.:format)                 events#create
                   event GET    /events/:id(.:format)             events#show
                         PATCH  /events/:id(.:format)             events#update
                         PUT    /events/:id(.:format)             events#update
                         DELETE /events/:id(.:format)             events#destroy
                 letters POST   /letters(.:format)                letters#create
                  letter GET    /letters/:id(.:format)            letters#show
                         PATCH  /letters/:id(.:format)            letters#update
                         PUT    /letters/:id(.:format)            letters#update
                         DELETE /letters/:id(.:format)            letters#destroy
                   pages GET    /pages(.:format)                  pages#index
                         POST   /pages(.:format)                  pages#create
                    page PATCH  /pages/:id(.:format)              pages#update
                         PUT    /pages/:id(.:format)              pages#update
                         GET    /*path(.:format)                  pages#index


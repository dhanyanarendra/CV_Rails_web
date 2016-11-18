Rails.application.routes.draw do

  root 'welcome#index'
#SignUp
post 'api/v1/users' => 'api/v1/users#create'
#updateUser
put 'api/v1/users/:id' => 'api/v1/users#update'
#list user based on ID
get 'api/v1/users/:id' => 'api/v1/users#show'
#delete user profile image
delete 'api/v1/remove_profile_image/:id' => 'api/v1/users#remove_profile_image'

#SignIn
post "api/v1/authenticate" => 'api/v1/authentications#authenticate'

post "api/v1/forgot_password" => 'api/v1/forgot_password#forgot_password'
#Reset_password_api
put "api/v1/reset_password" => 'api/v1/forgot_password#reset_password'

put "api/v1/describes/publish" => 'api/v1/describes#publish'

post "api/v1/:id/describe/like" => 'api/v1/describes#like_project'
post "api/v1/:id/describe/follow" => 'api/v1/describes#follow_project'
post "api/v1/tasks/:task_id/needs/:need_id/pledge" => 'api/v1/pledges#pledge_need'
get "api/v1/list_projects" => 'api/v1/describes#list'
post "api/v1/:describe_id/suggestion_tasks" => 'api/v1/suggestion_tasks#create'
delete "api/v1/suggestion_tasks/:id" => 'api/v1/suggestion_tasks#destroy'
post "api/v1/suggestion_need/:id" => 'api/v1/needs#suggestion_need'
get "api/v1/:describe_id/suggestion_tasks" => 'api/v1/suggestion_tasks#index'
put "api/v1/:describe_id/suggestion_tasks/:id" => 'api/v1/suggestion_tasks#update'
put "api/v1/:task_suggestion_id/suggestion_needs/:id" => 'api/v1/needs#suggestion_need_update'
get "api/v1/:id/suggestion_needs" => 'api/v1/needs#suggestion_index'
delete "api/v1/:task_suggestion_id/suggestion_needs/:id" =>'api/v1/needs#suggestion_destroy'
post "api/v1/:id/task_suggestion/like" => 'api/v1/suggestion_tasks#like_tasksuggestion'
put "api/v1/suggestion_status/:id" => 'api/v1/suggestion_tasks#update_suggestion'
put "api/v1/reorder_tasks/:id" => 'api/v1/tasks#reorder_tasks'
put "api/v1/reorder_goals" => 'api/v1/goals#reorder_goals'
get "api/v1/:id/profile_index" => 'api/v1/suggestion_tasks#profile_index'
get "api/v1/:id/user_contributions" => 'api/v1/pledges#user_contributions'
get "api/v1/:id/user_publish" => 'api/v1/describes#user_publish'
post "api/v1/:id/user/follow_user" => 'api/v1/users#follow_user'
post "api/v1/:user_id/describe/:describe_id" => 'api/v1/comments#create'
post "api/v1/checked_needs/:id" => 'api/v1/needs#checked_needs'
put "api/v1/users/:user_id/describe/:describe_id/comment/:id" => 'api/v1/comments#update'
delete "api/v1/users/:user_id/describe/:describe_id/comment/:id" =>'api/v1/comments#destroy'
get "api/v1/describe/:describe_id/comments" => 'api/v1/comments#index'

get "api/v1/my_pledges" => 'api/v1/describes#my_pledges'
get "api/v1/dashboard_projects" => 'api/v1/describes#dashboard_projects'
get "api/v1/show_all_followed_projects" => 'api/v1/describes#show_all_followed_projects'
get "api/v1/describe/:describe_id/project_needs"=> 'api/v1/needs#project_needs'
get "api/v1/:describe_id/fetch_project_details" => 'api/v1/describes#fetch_project_details'
get "api/v1/:need_id/pledged_user" => 'api/v1/describes#pledged_user'

#need_comments
post "api/v1/users/:user_id/need/:need_id" => 'api/v1/need_comments#create'
delete "api/v1/users/:user_id/needs/:need_id/need_comment/:id" =>'api/v1/need_comments#destroy'
get "api/v1/needs/:need_id/need_comments" => 'api/v1/need_comments#index'
post "api/v1/search" => 'api/v1/describes#search'


namespace :api do
  namespace :v1 do
    resources :describes do
      resources :goals do
        resources :tasks do
          resources :needs
        end
      end
    end
  end
end
end
APP_ROUTES = Proc.new do
  controller(:user) do 
    get '/'
    get 'sign_up'
    get 'sign_in'
    get 'sign_out' #delete
    post '/'
    post 'create_session'
  end

  controller(:twitter) do
    get '/'
    post 'search_user'
    post 'track_user'
  end
end

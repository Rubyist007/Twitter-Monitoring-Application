require './app/models/user.rb'
require './app/controllers/application_controller.rb'

class UserController < BaseController

  def initialize(request)
    super(request)

    authenticate!(:index, :sign_out) 
  end

  def sign_up
    render('users/sign_up')
  end

  def sign_in
    render('users/sign_in')
  end

  def create_session(params) 
    user = User.where(nickname: params['nickname'])[0]
    if user != nil
      request.session['user'] = user
      redirect_to('/user/')
    else
      redirect_to('/user/sign_in')
    end
  end

  def index 
    render('/users/index')
  end

  def create(params)
    user = User.new(params)
    user.password = params[:password] 
    user.save!
    request.session['user'] = user
    redirect_to('/user/')
  end

  def sign_out
    request.session['user'] = nil
    redirect_to('/user/sign_in')
  end
end

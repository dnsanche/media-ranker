class UsersController < ApplicationController
  def index 
    @users = User.alphabetic
  end

  def show
    @user = User.find_by(id: params[:id])
    
    if @user.nil?
      redirect_to root_path
      return 
    end
  end

  # def login_form
  #   @user =  User.new
  # end

  # def login
  #   name = params[:user][:name]
    
  #   if name == ""
  #     flash[:failure] = "Name cannot be blank"
  #     redirect_to login_path
  #   else
  #     user = User.find_by(name: name)
  #     if user
  #       session[:user_id] = user.id
  #       flash[:success] = "Successfully logged in as returning user #{name}"
  #     else
  #       user = User.create(name: name)
  #       session[:user_id] = user.id
  #       flash[:success] = "Successfully logged in as #{name}"
  #     end  
  #     redirect_to root_path   
  #   end
  # end

  def create
    auth_hash = request.env["omniauth.auth"]

    user = User.find_by(uid: auth_hash[:uid], provider: "github")
    if user
      # User was found in the database
      flash[:success] = "Logged in as returning user #{user.name}"
    else
      # User doesn't match anything in the DB
      # Attempt to create a new user
      user = User.build_from_github(auth_hash)
      if user.save
        flash[:success] = "Logged in as new user #{user.name}"
      else
        # Couldn't save the user for some reason. If we
        # hit this it probably means there's a bug with the
        # way we've configured GitHub. Our strategy will
        # be to display error messages to make future
        # debugging easier.
        flash[:error] = "Could not create new user account: #{user.errors.messages}"
        return redirect_to root_path
      end
    end
    # If we get here, we have a valid user instance
    session[:user_id] = user.id
    return redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "Successfully logged out!"

    redirect_to root_path
  end


  def current
    @current_user = User.find_by(id: session[:user_id])
    unless @current_user
      flash[:error] = "You must be logged in to see this page"
      redirect_to root_path
    end
  end
  
  # def logout
  #   session[:user_id] = nil
  #   redirect_to root_path
  # end
end

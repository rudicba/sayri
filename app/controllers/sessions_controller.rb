class SessionsController < ApplicationController
  # Es muy loco, si no le sacas el filtro automaticamente 
  # entra al filtro que lo redirecciona aca, por lo tanto
  # se ejecuta el filtro de nuevo que lo redirecciona aca
  # y asi pr una eternidad!
  skip_before_filter :signed_in_user, :correct_user, :admin_user

  def new
    # Si el usuario ya esta logeado redirecionar a su pagina
    if signed_in?
      redirect_to current_user
    end
  end

  def create
    login = params[:session][:uid]
    password = params[:session][:password]

    user = User.try_to_login(login, password)
    if user
      sign_in user
      if admin?
        redirect_to groups_url
      else
        redirect_to user
      end
    else
      flash.now[:alert] = "Invalid Username or Password"
      render 'new'
    end
  end

  def destroy
    # OPTIMIZE: Hace falta un helper para sign_out? 
    # Si solo se llama desde aca...
    sign_out
    redirect_to root_url, notice: "You have successfully logged out."
  end
end
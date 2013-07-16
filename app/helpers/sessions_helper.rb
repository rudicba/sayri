module SessionsHelper

    # Logea una session del usuario user
    def sign_in(user)
        session[:remember_token] = user.id
        self.current_user = user
    end

    # True si el user esta logeado
    def signed_in?
        !current_user.nil?
    end

    # Set del usuario
    def current_user=(user)
        @current_user = user
    end

    # Devuelve el user de la session
    def current_user
        @current_user ||= User.find_by_login(session[:remember_token])
    end

    # Dado un user, true si es el user que esta en session
    def current_user?(user)
        user == current_user
    end

    # True si el user de la session es admin
    def admin?
        current_user.groups.member? Group.find('Sayri')
    end
    
    # Termina una session de usuario
    def sign_out
        self.current_user = nil
        session.delete(:remember_token)
    end
end
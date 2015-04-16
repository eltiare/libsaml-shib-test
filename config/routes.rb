Rails.application.routes.draw do
  namespace :saml do
    get   :init
    post  :consume
    get   :consume
    get   :meta
    get   :sign_out
    post  :sign_out
  end
end

class SamlController < ApplicationController

  protect_from_forgery except: :consume

  include Saml::Rails::ControllerHelper
  current_provider :set_provider

  def init
    destination = Saml.current_provider.single_sign_on_service_url(Saml::ProtocolBinding::HTTP_REDIRECT)
    authn_request = Saml::AuthnRequest.new(
        destination: destination,
        assertion_consumer_service_url: saml_consume_url,
        assertion_consumer_service_binding: Saml::ProtocolBinding::HTTP_POST,
        issuer: entity_id
    )
    session[:authn_request_id] = authn_request._id
    redirect_to Saml::Bindings::HTTPRedirect.create_url(authn_request)
  end

  def consume
    @response = Saml::Bindings::HTTPPost.receive_message(request, :response)
    if @response.success?
      if session[:authn_request_id] == @response.in_response_to
        @response.assertion.fetch_attribute('any_attribute')
      else
        # handle unrecognized response
      end
      reset_session # It's good practice to reset sessions after authenticating to mitigate session fixation attacks
    else
      # handle failure
    end
  end

  def meta
    ed = Saml::Elements::EntityDescriptor.new
    ed.entity_id = entity_id
    container = Saml::Elements::SPSSODescriptor.new
    ed.sp_sso_descriptor = container
    container.assertion_consumer_services << Saml::Elements::SPSSODescriptor::AssertionConsumerService.new(location: saml_consume_url, binding: Saml::ProtocolBinding::HTTP_POST)
    cert = File.open(Rails.root.join('config/ssl/cert.pem')).read
    container.key_descriptors << Saml::Elements::KeyDescriptor.new(certificate: cert)
    render xml: ed.to_xml
  end

  private

  def set_provider
    Saml.provider('https://shibboleth.vagrant.dev/idp/shibboleth')
  end

  def entity_id
    'urn:testing:app'
  end

end

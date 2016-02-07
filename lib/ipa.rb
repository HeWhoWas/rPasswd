require 'httpclient'
require 'base64'
require 'gssapi'
require 'json'

class IPA
  attr_reader :hostgroup, :group, :sudorule, :sudocmd, :sudocmdgroup, :hbacrule, :hbacsvcgroup

  def initialize(host, keytab_path)
    host = Socket.gethostbyname(Socket.gethostname).first if host.nil?

    @gsok    = false
    @uri     = URI.parse "https://#{host}/ipa/json"
    @robot   = HTTPClient.new
    @gssapi  = GSSAPI::Simple.new(@uri.host, 'HTTP', keytab_path) # Get an auth token for HTTP/fqdn@REALM
    # you must already have a TGT (kinit admin)
    token    = @gssapi.init_context                  # Base64 encode it and shove it in the http header

    @robot.ssl_config.set_trust_ca('/etc/ipa/ca.crt')

    @extheader = {
        "referer"       => "https://ipa.auto.local/ipa",
        "Content-Type"  => "application/json",
        "Accept"        => "applicaton/json",
        "Authorization" => "Negotiate #{Base64.strict_encode64(token)}",
    }

    @hostgroup    = IPA::Hostgroup.new(self)
    # @group        = IPAgroup.new(self)
    # @sudorule     = IPAsudorule.new(self)
    # @sudocmd      = IPAsudocmd.new(self)
    # @sudocmdgroup = IPAsudocmdgroup.new(self)
    # @hbacrule     = IPAhbacrule.new(self)
    # @hbacsvcgroup = IPAhbacsvcgroup.new(self)
  end

  def post(method,params)
    payload = { "method" => method, "params" => params }
    resp    = @robot.post(@uri, JSON.dump(payload), @extheader)

    # lets look at the response header and see if kerberos liked our auth
    # only do this once since the context is established on success.

    itok    = resp.header["WWW-Authenticate"].pop.split(/\s+/).last
    @gsok   = @gssapi.init_context(Base64.strict_decode64(itok)) unless @gsok

    if @gsok and resp.status == 200
      result = JSON.parse(resp.content)
      puts "--------OOOOOOOOOPS #{result['error']['message']}" if !result['error'].nil?
      result
    else
      puts "failed"
      nil
    end
  end
end
require 'uri'
require 'net/http'

class JobsValueTool < RubyLLM::Tool
  description "Rechercher des offres d'emploi via le code ROME pour obtenir des infos sur les salaires et types de contrats disponibles (CDI, CDD...)."

  param :code_rome, desc: "Le code ROME du métier (ex: 'G1204', 'K1302'). Récupéré depuis la fiche métier."

  def execute(code_rome:)
    uri = URI('https://entreprise.francetravail.fr/connexion/oauth2/access_token?realm=%2Fpartenaire')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.basic_auth(ENV.fetch('FRANCE_TRAVAIL_CLIENT_ID'), ENV.fetch('FRANCE_TRAVAIL_SECRET'))
    request.set_form_data(
      'grant_type' => 'client_credentials',
      'scope' => 'o2dsoffre api_offresdemploiv2'
    )

    token_response = http.request(request)
    raise "Token error: #{token_response.body}" unless token_response.is_a?(Net::HTTPSuccess)

    access_token = JSON.parse(token_response.body)['access_token']

    url = URI("https://api.francetravail.io/partenaire/offresdemploi/v2/offres/search?codeROME=#{code_rome}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{access_token}"
    request["Accept"] = 'application/json'

    response = http.request(request)
    raise "API error #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    response.body.force_encoding('UTF-8')

  rescue => e
    { error: e.message }
  end
end

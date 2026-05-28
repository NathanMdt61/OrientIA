require 'uri'
require 'net/http'

class SearchJobsTool < RubyLLM::Tool
  description "Trouver la fiche métier liée aux sugestions proposées par l'IA."
  param :metier, desc: "Trouve la fiche métier liée au métier en question"

  def execute(metier:)

    uri = URI('https://entreprise.francetravail.fr/connexion/oauth2/access_token?realm=%2Fpartenaire')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.basic_auth(ENV.fetch('FRANCE_TRAVAIL_CLIENT_ID'), ENV.fetch('FRANCE_TRAVAIL_SECRET'))
    request.set_form_data(
      'grant_type' => 'client_credentials',
      'scope' => 'nomenclatureRome api_rome-fiches-metiersv1'
    )

    token_response = http.request(request)
    raise "Token error: #{token_response.body}" unless token_response.is_a?(Net::HTTPSuccess)

    access_token = JSON.parse(token_response.body)['access_token']

    url = URI("https://api.francetravail.io/partenaire/rome-fiches-metiers/v1/fiches-rome/fiche-metier/#{metier}")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["Authorization"] = "Bearer #{access_token}"
    request["Accept"] = 'application/json'

    response = http.request(request)
    raise "API error #{response.code}: #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    response.body.force_encoding('UTF-8')

  rescue => e # If the API fails, return an error the LLM can explain
    { error: e.message }
  end
end

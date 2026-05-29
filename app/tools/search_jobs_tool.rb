require 'uri'
require 'net/http'

class SearchJobsTool < RubyLLM::Tool
  description "Trouver la fiche métier liée aux sugestions proposées par l'IA."
  param :code_rome, desc: "Rôle : Tu es un expert du Répertoire Opérationnel des Métiers et des Emplois (ROME) de France Travail.
Tâche : Pour le métier que je te donne, identifie le code ROME exact et officiel.
Métier :
[NOM DU MÉTIER]
Règles impératives :

Le métier ne sera pas forcément écrit exactement comme dans la nomenclature officielle. Tiens compte des fautes d'orthographe, des abréviations, du masculin/féminin, du singulier/pluriel, des synonymes et des appellations courantes ou régionales. Identifie le métier ROME correspondant à l'intention, pas au libellé exact.
Si l'appellation que je donne est un synonyme ou une variante, indique d'abord à quel intitulé ROME officiel tu la rattaches, puis donne le code.
Donne le code ROME, son intitulé officiel exact, puis la fiche.
Le code et l'intitulé doivent correspondre EXACTEMENT à la nomenclature officielle ROME v4. N'invente jamais un code.
Si l'appellation est trop ambiguë pour trancher entre plusieurs métiers, liste les codes possibles avec leur intitulé et précise dans quel contexte chacun s'applique, au lieu de deviner.
Avant de répondre, vérifie la cohérence entre le code et l'intitulé : un même code ne peut pas désigner deux métiers différents."

  def execute(code_rome:)

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

    url = URI("https://api.francetravail.io/partenaire/rome-fiches-metiers/v1/fiches-rome/fiche-metier/#{code_rome}")

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

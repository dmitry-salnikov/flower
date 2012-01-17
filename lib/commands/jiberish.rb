# encoding: utf-8

class Jiberish < Flower::Command
  respond_to "bizniz"
  listen_to /affärsmodell|.*strategi|fokuserar|helheten|kunden|helhetsgrepp|samlad kompetens|gediget kunnande|personalen|kvalitet|kvaliteten|tjänster|kvalitetsmodell|kompetensplattform|tvärvetenskaplig|utmaningar|ledstjärna|professionalism|flexibelt|kundfokuserat|kvalitetsorienterad|kunskapsrik|organisation|branschledarskap|arbetsmetoder|kvalitetssäkring|affärsmässiga|kundnytta/i

  def self.description
    "Generera lite bizniz snack"
  end

  def self.respond(command, message, sender, flower)
    flower.paste(jiberish)
  end

  def self.listen(message, sender, flower)
    flower.say(jiberish, :mention => sender[:id])
  end

  private
  def self.jiberish
    'Vi ' + one[rand(one.size)] + ' och ' + two[rand(two.size)] + ' för att ' + three[rand(three.size)]
  end

  def self.one
    [
      'fokuserar på helheten',
      'sätter kunden i centrum',
      'tar ett helhetsgrepp',
      'har samlad kompetens',
      'har byggt upp ett gediget kunnande',
      'satsar på vår viktigaste resurs personalen',
      'strävar alltid efter att se helheten',
      'står för hög kvalitet',
      'är mycket noga med kvaliteten på de uppdrag vi genomför',
      'vill att våra tjänster skall förknippas med kvalitet',
      'har utvecklat en egen kvalitetsmodell',
      'har en kompetensplattform som vilar på en tvärvetenskaplig bas',
      'siktar på framtiden',
      'ser alla problem som utmaningar',
      'har kvalitet som en ledstjärna satsar på kunskap och professionalism',
      'har ett flexibelt och kundfokuserat synsätt leder och driver utvecklingen inom flera specifika områden',
      'har kompetensen och resurserna för att bryta ny mark',
      'har en stabil grundplattform',
      'för flexibla lösningar effektiviserar kundens processer',
      'för ökad koncentration på huvudaffären',
      'har en kvalitetsorienterad och kunskapsrik organisation',
      'har en ledarroll genom att vi identifierar strategier sitter på bred och djup kompetens',
      'står för aktualitet, integritet samt branschledarskap',
      'baserar verksamheten på helhetssyn och mångsidighet',
      'har som mål att seriöst satsa på ständig utveckling av våra arbetsmetoder',
      'anser att vi lever i en spännande tid',
      'har som ambition att täcka hela projektcykeln',
      'arbetar med kvalitetssäkring i en decentraliserad miljö',
      'består av ett erfaret team som värdesätter affärsmässiga relationer',
      'strävar efter optimal kundnytta och effektivitet',
      'samlar och sprider vår kompetens genom ett antal arbetsmodeller'
    ]
  end

  def self.two
    [
      'erbjuder högkvalitativa lösningar',
      'hjälper våra uppdragsgivare att satsa på sin kärnverksamhet',
      'utvecklar avancerade metoder',
      'är ledande inom våra kärnområden',
      'ett processorienterat och kundfokuserat arbetssätt',
      'riktar in oss mot viktiga områden',
      'koncentrerar oss på helhetslösningar',
      'utför kontinuerlig verifiering av uppdragens omfattning och tidsramar',
      'har gedigen erfarenhet av att arbeta med människor och teknik',
      'arbetar för målgruppsanpassade lösningar',
      'sätter alltid individens förutsättningar i centrum',
      'prioriterar engagemang och kompetens',
      'sätter alltid människan i ett centralt perspektiv',
      'utvecklar och förädlar arbetsprocesserna',
      'har byggt upp gedigen in-house-kompetens',
      'arbetar ständigt med kontinuerlig egen kunskapsförbättring',
      'utvecklar strategiskt hållbara lösningar',
      'breddar och fördjupar ständigt våra kunskaper',
      'satsar på målstyrda arbetslag som får stöd av specialister',
      'har ett individ- och grupporienterat synsätt',
      'prioriterar en kundfokuserad flödesorganisation',
      'vi delar gärna med oss av erfarenheter och kompetens',
      'arbetar kundfokuserat, välorganiserat och kostnadseffektivt',
      'fokuserar på att vara förändringsbara och verksamhetsanpassade',
      'erbjuder både anpassade samt paketerade lösningar',
      'kan erbjuda en rad spännande koncept inom design av nya lösningar',
      'har kundanpassade lösningar med hög successrate',
      'har fokus på kundernas behov av snabba och flexibla lösningar',
      'arbetar på ett kreativt sätt med förbättring av verksamhetsnettot',
      'skräddarsyr ersättningar för resursslukande metoder',
      'använder endast väl etablerade och beprövade verktyg',
      'har kvalitet, strukturerad utveckling samt kompetens som bas',
      'strävar efter proaktiva och kreativa affärsrelationer',
      'satsar på kvalitativ strategiformulering'
    ]
  end

  def self.three
    [
      'alltid kunna ligga i frontlinjen',
      'alltid kunna erbjuda optimala lösningar',
      'stärka lönsamheten',
      'kunna effektivera verksamheten',
      'ligga steget före konkurrenterna',
      'kunna erbjuda integrerade lösningar',
      'säkerställa att uppdragen fortlöper enligt plan',
      'fokusera på mänsklig interaktion, pedagogik och kreativitet',
      'kontinuerligt utveckla och förbättra våra tjänster',
      'skapa en stimulerande och kreativ miljö överträffa kundens och våra egna krav',
      'alltid sätta slutanvändaren i centrum',
      'öka kundens förutsättningar för en lönsam och positiv teknikanvändning',
      'optimera resursanvändningen och effektiviteten',
      'lyfta fram nya och annorlunda synsätt ge kunden ökad produktivitet och konkurrenskraft',
      'förse kunderna med konkurrensmässigt prisvärda tjänster',
      'ge en unik service med ett helt kundfokuserat paket',
      'stärka vår strategi',
      'att positionera oss som ett visionsstyrt företag',
      'arbeta med flexibla lösningar på kundens villkor',
      'kunna erbjuda våra kunder kostnadseffektiva totallösningar',
      'säkra kvalitet genom hela processen',
      'tillhandahålla flexibla lösningar som växer med affärsnyttan',
      'åstadkomma säkra lösningar med hög tillgänglighet',
      'garantera en produkt som snabbt anpassas till framtidens',
      'krav ge dig möjlighet att testa dina visioner mot verkligheten',
      'utveckla unika tjänster med nytänkande i effektivitet och lönsamhet',
      'skapa långsiktiga affärsrelationer som bygger på förtroende och tillit',
      'bygga djup och offensiv kunskap om marknad och möjligheter'
    ]
  end
end

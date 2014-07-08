# encoding: UTF-8

class Godmorgom < Flower::Command
  respond_to "godmorgom", "godmorgomm"

  def self.description
    'Play "Jag Ger Dig Min morgom" with lyrics'
  end

  def self.respond(message)
    message.paste(lyric)
    Spotbot.play_track("spotify:track:7nBARurNPIRVcf81uOFz3i")
  end

  def self.lyric
    <<-eos
    Åter igen gryr dagen vid din bleka skuldra.
    Genom frostigt glas syns solen som en huldra.
    Ditt hår, det flyter över hela kudden...

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgom,
    jag ger dig min dag.

    Vår gardin den böljar svagt där solen strömmar.
    Långt bakom ditt öga svinner nattens drömmar.
    Du drömmer om något fint ,
    jag ser du småler.

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgom,
    jag ger dig min dag.

    Utanför vårt fönster hör vi markens sånger.
    Som ett rastlöst barn om våren, dagen kommer.
    Lyssna till den sång som jorden sjunger.

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgom,
    jag ger dig min dag.

    Likt en sländas spröda vinge ögat skälver.
    Solens smälta i ditt hår kring pannan välver.
    Du, jag tror vi flyr rakt in i solen...

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgom,
    jag ger dig min dag.

    Men du, jag ger dig min morgom,
    jag ger dig min dag.
eos
  end

end

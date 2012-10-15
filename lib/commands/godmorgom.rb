# encoding: UTF-8

class Godmorgom < Flower::Command
  respond_to "godmorgom"

  def self.description
    'Play "Jag Ger Dig Min Morgon" with lyrics'
  end

  def self.respond(command, message, sender, flower)
    flower.paste(lyric)
    SpotifyCommand.play_track(SpotifyCommand.get_track("Fred Åkerström - Jag Ger Dig Min Morgon"))
  end

  def self.lyric
    <<-eos
    Åter igen gryr dagen vid din bleka skuldra.
    Genom frostigt glas syns solen som en huldra.
    Ditt hår, det flyter över hela kudden...

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgon,
    jag ger dig min dag.

    Vår gardin den böljar svagt där solen strömmar.
    Långt bakom ditt öga svinner nattens drömmar.
    Du drömmer om något fint ,
    jag ser du småler.

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgon,
    jag ger dig min dag.

    Utanför vårt fönster hör vi markens sånger.
    Som ett rastlöst barn om våren, dagen kommer.
    Lyssna till den sång som jorden sjunger.

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgon,
    jag ger dig min dag.

    Likt en sländas spröda vinge ögat skälver.
    Solens smälta i ditt hår kring pannan välver.
    Du, jag tror vi flyr rakt in i solen...

    Om du var vaken skulle jag ge dig
    allt det där jag aldrig ger dig.
    Men du, jag ger dig min morgon,
    jag ger dig min dag.

    Men du, jag ger dig min morgon,
    jag ger dig min dag.
eos
  end

end

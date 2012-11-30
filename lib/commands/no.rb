# encoding: UTF-8
class Noes < Flower::Command
  respond_to "no"

  NOES = %w[
    http://2.media.todaysbigthing.cvcdn.com/95/29/641fcffad4e8fa6a2abec3da6af71d66.gif
    http://1.media.todaysbigthing.cvcdn.com/60/34/ee9073fc50c7b0f472ded37f92b23807.gif
    http://0.media.todaysbigthing.cvcdn.com/11/69/7280d58bf6eef59d1fb0e55b47ab6d78.gif
    http://1.media.todaysbigthing.cvcdn.com/97/76/2ec520676c53b91a11177e6f49cf3cd3.gif
    http://1.media.todaysbigthing.cvcdn.com/29/83/76ca8d143d4af6612b22ffd59a035966.gif
    http://1.media.todaysbigthing.cvcdn.com/20/55/e972d51ea5cb7b36625a1a8cf3b617d7.gif
    http://2.media.todaysbigthing.cvcdn.com/34/74/9bf82c64106c3be9a8cb35fc0260db1f.gif
    http://1.media.todaysbigthing.cvcdn.com/97/82/204166a71f807df627c8e337674c58a6.gif
    http://2.media.todaysbigthing.cvcdn.com/17/93/5d4f7172a17eb2ec20df365eed1ed70a.gif
    http://0.media.todaysbigthing.cvcdn.com/28/83/ecae6f7199680181061d5743344c1c0f.gif
    http://2.media.todaysbigthing.cvcdn.com/72/63/9c7cc9b53a302d926bb3810a5b403b8a.gif
    http://0.media.todaysbigthing.cvcdn.com/82/35/aa87dc723e6f37bdb17b52770022b4dd.gif
    http://1.media.todaysbigthing.cvcdn.com/48/26/f455322977c8689ccc895d745da79d86.gif
    http://0.media.todaysbigthing.cvcdn.com/96/72/09a8cdb8aa79e25da5dc4f33b54087f2.gif
    http://2.media.todaysbigthing.cvcdn.com/41/63/cf17af360b451ab04b3abc14c6ad7ecc.gif
    http://1.media.todaysbigthing.cvcdn.com/99/64/9dbe4b68eb8f476423b2900bbaef8825.gif
    http://1.media.todaysbigthing.cvcdn.com/58/57/1f52f1a098d96a941086ea87f80c8550.gif
    http://2.media.todaysbigthing.cvcdn.com/13/46/5002f2ed41386f9830a01a6b6428a81c.gif
    http://2.media.todaysbigthing.cvcdn.com/16/68/bea2457b700adbbcb85f8e0a2886ffc9.gif
    http://0.media.todaysbigthing.cvcdn.com/66/84/b281a68ecf4a0746b08d24137393ef6f.gif
    http://0.media.todaysbigthing.cvcdn.com/35/72/18a381479eeb437c64aace6cf5f051d8.gif
    http://1.media.todaysbigthing.cvcdn.com/14/87/f1c3eefefcba0ecb5361ddf5c8d75166.gif
    http://2.media.todaysbigthing.cvcdn.com/97/13/9d3869dd93dc401d62099a9b9d6c6a74.gif
    http://0.media.todaysbigthing.cvcdn.com/11/69/c8de615d468fcc9c02915f25ec6b598e.gif
    http://0.media.todaysbigthing.cvcdn.com/32/82/3282be12a6cb7584645de705ebba8205.gif
    http://2.media.todaysbigthing.cvcdn.com/57/83/2493bb4beb8f7afa1fbe50f9627c6844.gif
    http://0.media.todaysbigthing.cvcdn.com/78/32/81ffc4bb48f64608518094966cc5b2b1.gif
    http://1.media.todaysbigthing.cvcdn.com/92/42/99b7d5c31b0bad9ff2492ac31e1e41c6.gif
    http://2.media.todaysbigthing.cvcdn.com/70/99/4885a98221e5944055c0fe54580080c1.gif
    http://0.media.todaysbigthing.cvcdn.com/52/20/b2fdb72c1cc8085462bc1273e4e78aef.gif
    http://1.media.todaysbigthing.cvcdn.com/35/89/78274d82561bece8502cb229cd5048b7.gif
    http://0.media.todaysbigthing.cvcdn.com/49/70/9e8f32e498e9fad1abeb03381af383ff.gif
    http://2.media.todaysbigthing.cvcdn.com/24/18/e6718fd73955ac296ce9f68eb1967975.gif
    http://1.media.todaysbigthing.cvcdn.com/85/38/bb544e6a9d3d1061044498ef127803cc.gif
    http://1.media.todaysbigthing.cvcdn.com/85/38/bb544e6a9d3d1061044498ef127803cc.gif
    http://loopcam-uploads.s3.amazonaws.com/files/110917/original/loop.gif
  ]

  def self.description
    "No, not today!"
  end

  def self.respond(command, message, sender, flower)
    flower.say NOES.sample
  end
end
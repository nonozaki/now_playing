# -*- coding: utf-8 -*-
require 'open3'

Plugin.create(:now_playing) do

  class Now_Play
    def initialize
      @old_title = ""
    end

    def now_play
      data =  Open3.capture3("qdbus org.mpris.MediaPlayer2.rhythmbox /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get org.mpris.MediaPlayer2.Player Metadata")
      val = data[0]
      album  = val.scan(/(xesam:album):(.+)/)
      artist  = val.scan(/(xesam:artist):(.+)/)
      title  = val.scan(/(xesam:title):(.+)/)

      if !(album.nil?) && title[0][1] !=  @old_title  then
        Service.primary.post :message =>  "Title:" + title[0][1]  + " Artist:" +  artist[0][1] + " Album:" + album[0][1] + " #NowPlaing " +  "\n"
        @old_title = title[0][1]
      end

    end

  end

  def main
    now = Now_Play.new
    Reserver.new(20){
      now.now_play
      sleep 20
    main}
  end

  main

end

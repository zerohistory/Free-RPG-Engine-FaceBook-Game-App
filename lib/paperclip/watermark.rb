module Paperclip
  class Watermark < Processor
    def initialize(file, options = {}, attachment = nil)
      super

      @file = file
      @current_format   = File.extname(@file.path)
      @basename         = File.basename(@file.path, @current_format)
      @watermark        = Rails.root.join("public/images/watermark.png")
      @current_geometry   = Geometry.from_file file # This is pretty slow
      @watermark_geometry = Geometry.from_file(@watermark)
    end

    def make
      dst = Tempfile.new([@basename, @format].compact.join("."))

      command = "-gravity South -dissolve 100 \\( %s -extract %dx%d+%d+%d \\) %s %s" % [
        @watermark,
        @current_geometry.width.to_i,
        @current_geometry.height.to_i,
        @watermark_geometry.height.to_i / 2,
        @watermark_geometry.width.to_i / 2,
        File.expand_path(@file.path),
        File.expand_path(dst.path)
      ]

      begin
        Paperclip.run("composite", command)
      rescue PaperclipCommandLineError
        raise PaperclipError, "There was an error processing the watermark for #{@basename}" if @whiny_thumbnails
      end

      dst
    end
  end
end

# frozen_string_literal: true

module YARV
  # This is the self object at the top of the script.
  class Main
    def ==(other)
      other in Main
    end

    def inspect
      "main"
    end

    def require(context, filename)
      file_path =
        context.globals[:$:].find do |path|
          filename += ".rb" unless filename.end_with?(".rb")

          file_path = File.join(path, filename)
          next unless File.file?(file_path) && File.readable?(file_path)

          break file_path
        end

      raise LoadError, "cannot load such file -- #{filename}" unless file_path

      return false if context.globals[:"$\""].include?(file_path)

      iseq =
        File.open(file_path, "r") do |f|
          YARV.compile(f.read, file_path, file_path)
        end

      context.eval(iseq)
      true
    end
  end
end

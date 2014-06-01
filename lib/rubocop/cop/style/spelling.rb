# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # Checks spelling
      class Spelling < Cop
        def known_words
          @known_words ||= determine_known_words
        end

        def determine_known_words
          text = File.read('.dictionary')
          Set.new(text.split("\n"))
        end
      end
    end
  end
end

# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # Checks spelling
      class Spelling < Cop
        MSG = 'Incorrectly spelled word'

        def on_lvasgn(node)
          lv_symbol = node.children.first
          lv_name = lv_symbol.to_s
          # ASSUMPTION: All local variables are split into words by underscores.
          words = lv_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

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

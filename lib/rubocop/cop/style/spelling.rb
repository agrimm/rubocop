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
          # ASSUMPTION: All variables are split into words by underscores.
          words = lv_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_ivasgn(node)
          iv_symbol = node.children.first
          iv_name = iv_symbol.to_s[1..-1]
          # ASSUMPTION: All variables are split into words by underscores.
          words = iv_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_gvasgn(node)
          gv_symbol = node.children.first
          gv_name = gv_symbol.to_s[1..-1]
          # ASSUMPTION: All variables are split into words by underscores.
          words = gv_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_cvasgn(node)
          cv_symbol = node.children.first
          cv_name = cv_symbol.to_s[2..-1]
          # ASSUMPTION: All variables are split into words by underscores.
          words = cv_name.split('_')
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

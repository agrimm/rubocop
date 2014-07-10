# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # TODO: Add automatic generation of the dictionary file.
      # TODO: Add handling of camelCase variables.
      # TODO: Add more informative message for incorrectly spelled words.
      # TODO: Reduce repetition in code.
      # TODO: Ensure this works on other projects.
      # Checks spelling
      class Spelling < Cop
        MSG = 'Incorrectly spelled word'

        # rubocop:disable Style/LineLength
        # Listed as in the same order in Parser::AST::Processor

        # Descriptions in https://github.com/whitequark/parser/blob/master/doc/AST_FORMAT.md

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

        def on_casgn(node)
          casgn_symbol = node.children[1]
          # ASSUMPTION: All constants are split into words by underscores.
          # This assumption is invalid for class names.
          casgn_name = casgn_symbol.to_s
          words = casgn_name.split('_').map(&:downcase)
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_argument(node)
          return if node.children.empty?
          argument_symbol = node.children.fetch(0)
          argument_name = argument_symbol.to_s
          # ASSUMPTION: All variables are split into words by underscores.
          words = argument_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_module(node)
          module_symbol = node.children.fetch(0).children.fetch(1)
          module_name = module_symbol.to_s
          # REVIEW: Is there a good way of turning CamelCase names into words?
          words = module_name.scan(/[A-Z][^A-Z]*/).map(&:downcase)
          words.each do |word|
            # REVIEW: What about one letter words?
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_class(node)
          class_symbol = node.children.fetch(0).children.fetch(1)
          class_name = class_symbol.to_s
          # REVIEW: Is there a good way of turning CamelCase names into words?
          words = class_name.scan(/[A-Z][^A-Z]*/).map(&:downcase)
          words.each do |word|
            # REVIEW: What about one letter words?
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_def(node)
          def_symbol = node.children.first
          def_name = def_symbol.to_s.gsub(/[?!=~<>]+/, '')
          # ASSUMPTION: All method names are split into words by underscores.
          words = def_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_defs(node)
          defs_symbol = node.children.fetch(1)
          defs_name = defs_symbol.to_s.gsub(/[?!=~<>]+/, '')
          # ASSUMPTION: All method names are split into words by underscores.
          words = defs_name.split('_')
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression)
          end
        end

        def on_alias(node)
          alias_symbol = node.children.first.children.first
          alias_name = alias_symbol.to_s.gsub(/[?!=~<>]+/, '')
          # ASSUMPTION: All method names are split into words by underscores.
          words = alias_name.split('_')
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

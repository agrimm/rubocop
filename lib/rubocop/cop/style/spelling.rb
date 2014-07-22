# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # TODO: Add automatic generation of the dictionary file.
      # TODO: Ensure this works on other projects.
      # Checks spelling
      class Spelling < Cop
        MSG = 'Incorrectly spelled word %s'

        # rubocop:disable Style/LineLength
        # Listed as in the same order in Parser::AST::Processor

        # Descriptions in https://github.com/whitequark/parser/blob/master/doc/AST_FORMAT.md

        def on_vasgn(node)
          v_symbol = node.children.first
          v_name = v_symbol.to_s.gsub(/[$@]/, '')
          words = split_lower_case(v_name)
          inspect_words(node, words)
        end

        def on_casgn(node)
          casgn_symbol = node.children[1]
          # ASSUMPTION: All constants are split into words by underscores.
          # This assumption is invalid for class names.
          casgn_name = casgn_symbol.to_s
          words = split_upper_case(casgn_name)
          inspect_words(node, words)
        end

        def on_argument(node)
          return if node.children.empty?
          argument_symbol = node.children.fetch(0)
          argument_name = argument_symbol.to_s
          words = split_lower_case(argument_name)
          inspect_words(node, words)
        end

        def on_module(node)
          module_symbol = node.children.fetch(0).children.fetch(1)
          module_name = module_symbol.to_s
          # REVIEW: What about one letter words?
          words = split_upper_case(module_name)
          inspect_words(node, words)
        end

        def on_class(node)
          class_symbol = node.children.fetch(0).children.fetch(1)
          class_name = class_symbol.to_s
          # REVIEW: What about one letter words?
          words = split_upper_case(class_name)
          inspect_words(node, words)
        end

        def on_def(node)
          def_symbol = node.children.first
          def_name = def_symbol.to_s.gsub(/[?!=~<>]+/, '')
          words = split_lower_case(def_name)
          inspect_words(node, words)
        end

        def on_defs(node)
          defs_symbol = node.children.fetch(1)
          defs_name = defs_symbol.to_s.gsub(/[?!=~<>]+/, '')
          words = split_lower_case(defs_name)
          inspect_words(node, words)
        end

        def on_alias(node)
          alias_symbol = node.children.first.children.first
          alias_name = alias_symbol.to_s.gsub(/[?!=~<>]+/, '')
          words = split_lower_case(alias_name)
          inspect_words(node, words)
        end

        def inspect_words(node, words)
          words.each do |word|
            next if word.empty?
            next if known_words.include?(word)
            add_offense(node, :expression, format(MSG, word))
          end
        end

        def split_lower_case(name)
          if name.include?('_')
            name.split('_')
          else
            name.scan(/.[^A-Z]*/).map(&:downcase)
          end
        end

        def split_upper_case(name)
          if name =~ /[a-z]/
            # REVIEW: Is there a good way of turning CamelCase names into words?
            name.scan(/[A-Z][^A-Z]*/).map(&:downcase)
          else
            name.split('_').map(&:downcase)
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

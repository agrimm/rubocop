# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # TODO: Add automatic generation of the dictionary file.
      # TODO: Add handling of camelCase variables.
      # TODO: Add handling of more syntax, such as on_def.
      # TODO: Add more informative message for incorrectly spelled words.
      # TODO: Reduce repetition in code.
      # TODO: Ensure this works on other projects.
      # Checks spelling
      class Spelling < Cop
        MSG = 'Incorrectly spelled word'

        # rubocop:disable Style/LineLength
        # Listed as in the same order in Parser::AST::Processor

        # Descriptions in https://github.com/whitequark/parser/blob/master/doc/AST_FORMAT.md

        # dstr means "String with interpolation". Strings are content, and content may or may not be correctly spelled.
        # dsym means "Symbol with interpolation". Symbols are content, and content may or may not be correctly spelled.
        # regexp means "Regexp". Regular expressions do not obey spelling.
        # xstr means "Execute-string". System commands do not obey spelling.
        # splat means "Splat". It always contains a lvar, so leave evaluation of spelling to on_lvar.
        # array means "Array". It is always made up of other elements, so leave evaluation of spelling to them.
        # pair is always made up of other elements, so leave evaluation of spelling to them.
        # hash is always made up of other elements, so leave evaluation of spelling to them.
        # irange is always made up of other elements, so leave evaluation of spelling to them.
        # erange is always made up of other elements, so leave evaluation of spelling to them.
        # var appears to be a parent type of lvar, ivar, gvar, cvar, back_ref, nth_ref. Defer for now.
        # lvar, ivar, gvar, cvar, back_ref, nth_ref presumably refer to the use of existing variables. Try to examine the creation, not use, of variables.
        # and-asgn is always made up of other elements, so leave evaluation of spelling to them.
        # or-asgn is always made up of other elements, so leave evaluation of spelling to them.
        # op-asgn is always made up of other elements, so leave evaluation of spelling to them.
        # mlhs is always made up of other elements, so leave evaluation of spelling to them.
        # masgn is always made up of other elements, so leave evaluation of spelling to them.
        # const presumably refers to the use of existing constants. Try to examine the creation, not use, of constants.
        # arg_expr, restarg_expr, and block_arg_expr are Ruby 1.8 only, which is not supported by RuboCop.
        # sclass refers to the use of an existing variable. Try to examine the creation, not use, of variables.

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

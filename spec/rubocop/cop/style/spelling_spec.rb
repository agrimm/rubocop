# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Style::Spelling do
  subject(:cop) { described_class.new }

  it 'does not register an offense for a correctly spelled local variable' do
    inspect_source(cop, 'offense = Offense.new')
    expect(cop.offenses).to be_empty
  end
end

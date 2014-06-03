# encoding: utf-8

require 'spec_helper'

describe Rubocop::Cop::Style::Spelling do
  subject(:cop) { described_class.new }

  it 'registers an offense for an incorrectly spelled local variable' do
    inspect_source(cop, 'offence = Offense.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for a correctly spelled local variable' do
    inspect_source(cop, 'offense = Offense.new')
    expect(cop.offenses).to be_empty
  end
end

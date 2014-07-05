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

  it 'registers an offense for an incorrectly spelled instance variable' do
    inspect_source(cop, '@offence = Offense.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an incorrectly spelled global variable' do
    inspect_source(cop, '$offence = Offense.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an incorrectly spelled class variable' do
    inspect_source(cop, '@@offence = Offense.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for a correctly spelled class variable' do
    inspect_source(cop, '@@offense = Offense.new')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for an incorrectly spelled constant' do
    inspect_source(cop, 'Offence = Class.new')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an incorrectly spelled required argument' do
    inspect_source(cop, 'def foo(offence); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an incorrectly spelled optional argument' do
    inspect_source(cop, 'def foo(bar, offence = 1); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an incorrectly spelled splat argument' do
    inspect_source(cop, 'def foo(bar, *offence); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for an unnamed splat argument' do
    inspect_source(cop, 'def foo(*); end')
    expect(cop.offenses.size).to eq(0)
  end

  it 'registers an offense for an block argument' do
    inspect_source(cop, 'def foo(&offence); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for a block shadow argument' do
    inspect_source(cop, 'foo.each {|bar; offence|}')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for a required keyword argument' do
    inspect_source(cop, 'def foo(offence:); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for an optional keyword argument' do
    inspect_source(cop, 'def foo(offence: 42); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for a named keyword splat argument' do
    inspect_source(cop, 'def foo(bar:, **offence); end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for an unnamed keyword splat argument' do
    inspect_source(cop, 'def foo(bar:, **); end')
    expect(cop.offenses.size).to eq(0)
  end

  it 'registers an offense for a module definition' do
    inspect_source(cop, 'module Offence; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'does not register an offense for a correctly spelled module definition' do
    inspect_source(cop, 'module Offense; end')
    expect(cop.offenses).to be_empty
  end

  it 'does not register an offense for an acronym followed by a word' do
    inspect_source(cop, 'module MRICop; end')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for a class definition' do
    inspect_source(cop, 'class Offence; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for method definition' do
    inspect_source(cop, 'def offence; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'ignores question marks' do
    inspect_source(cop, 'def cop?; end')
    expect(cop.offenses).to be_empty
  end

  it 'ignores equal signs' do
    inspect_source(cop, 'def cop=; end')
    expect(cop.offenses).to be_empty
  end

  it 'registers an offense for singleton method definition' do
    inspect_source(cop, 'def self.offence; end')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for method aliasing' do
    inspect_source(cop, 'alias offence :foo')
    expect(cop.offenses.size).to eq(1)
  end

  it 'registers an offense for global variable aliasing' do
    inspect_source(cop, 'alias $offence $foo')
    expect(cop.offenses.size).to eq(1)
  end
end

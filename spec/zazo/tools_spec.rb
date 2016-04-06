require 'spec_helper'

RSpec.describe Zazo::Tools do
  subject { described_class }

  it { expect(subject::VERSION).to be_a String }
end

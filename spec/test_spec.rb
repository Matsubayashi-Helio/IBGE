'test rspec file'
require 'spec_helper'
require 'cli'
require 'name'
require 'byebug'
require 'json'
require 'stringio'
require_relative '../opt'


describe Cli do
    context 'Run application' do
        # let(:io) {StringIO.new('asdfasdfasdf')}
        it 'should show welcome message' do
            io = StringIO.new
            io.puts 'asdfasdfasdf'
            io.puts 'aaaaaaaaaa'
            io.rewind
            $stdin = io
            # byebug 

            # expect {Cli.welcome}.to output("asdfasdfasdf").to_stdout
            expect {Cli.welcome}.to output(include("ASDFASDFASDF","aaaaaaaaaa")).to_stdout

            $stdin = STDIN
        end
    end
end
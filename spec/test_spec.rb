require 'spec_helper'
require 'cli'
require 'name'
require 'byebug'
require 'json'
require 'stringio'


describe Cli do
    context 'Run application' do
        # let(:io) {StringIO.new('asdfasdfasdf')}
        it 'should show welcome message' do
            io = StringIO.new
            io.puts 'asdfasdfasdf'
            # io.puts 'aaaaaaaaaa'
            io.rewind
            $stdin = io
            # byebug 
            city = Cli.get_city_name
            # expect {Cli.welcome}.to output("asdfasdfasdf").to_stdout
            # expect {Cli.get_city_name}.to output(include("ASDFASDFASDF","aaaaaaaaaa")).to_stdout
            expect(city).to eq 'asdfasdfasdf'

            $stdin = STDIN
        end
    end
end
states = StateName.states

states.each do |s|
    stt = State.create!(state: s.state, initials: s.initials)
    # puts "#{s.initials} was saved to DB!"
end
speed = 2.0

i = 0
b = 0

a2 = scale :A2, :minor_pentatonic
a3 = scale :A3, :minor_pentatonic
ab3 = [57, 60, 62, 63, 64, 67, 69]
a4 = scale :A4, :minor_pentatonic
ab4 = [69, 72, 74, 75, 76, 79, 81]
a5 = scale :A5, :minor_pentatonic

d2 = scale :D2, :minor_pentatonic
d3 = scale :D3, :minor_pentatonic
d4 = scale :D4, :minor_pentatonic
d5 = scale :D5, :minor_pentatonic

e3 = scale :E3, :major_pentatonic
e4 = scale :E4, :major_pentatonic
e5 = scale :E5, :major_pentatonic

blues = [1,1,1,1,
         4,4,1,1,
         5,5,1,1,
         5,4,1,5].ring

scales = [
  0,
  [a2,a3,ab3,a4],
  0,
  0,
  [d2,d3,d3,d4],
[e3,e3,e4,e5]]

phrases = [-1,0,1,1,2,2,3,4,4,5]

chords = [
  0,
  chord(:A3, :minor),
  0,
  0,
  chord(:D3, :minor),
chord(:E3,'7')]

live_loop :bar do
  b = 0
  cue :beat
  sleep 0.2 * speed
  b = 1
  cue :beat
  sleep 0.2 * speed
  b = 2
  cue :beat
  sleep 0.2 * speed
  b = 3
  cue :beat
  sleep 0.2 * speed
  i = (i + 1) % blues.length
end

live_loop :drums do
  sync :beat
  
  if (i+1) % 4 != 2 then
    sample :drum_cymbal_closed, amp: 0.4
    if b == 2 then
      sleep 0.1 * speed
      sample :drum_cymbal_closed, amp: 0.4
    end
  end
  
  if b == 0 and i != 10 and i != 14 then
    sample :drum_bass_soft
  end
  
  if b == 2 then
    if 0 <= i && i < 4 then
      sample :drum_snare_hard, amp: 0.4
    elsif 4 <= i && i < 8 then
      sample :drum_snare_soft, amp: 0.4
    else
      sample :drum_snare_hard, amp: 0.4
      sleep 0.1 * speed
      sample :drum_snare_soft, amp: 0.4
    end
  end
end

live_loop :base do
  sync :beat
  c = blues[i]
  
  if b == 0 then
    a = 2.0
  else
    a = 1.0
  end
  
  if c == 1 then
    play :A2, amp: 0.4 * a
  elsif c == 4 then
    play :D2, amp: 1.6 * a
  elsif c == 5 then
    play :E2, amp: 1.6 * a
  end
end


live_loop :solo do
  sync :beat
  c = blues[i]
  S = scales[c]
  
  s = S.choose
  
  with_fx :distortion, distort: 0.9, amp: 0.4 do
    with_synth :beep do
      p = phrases.choose
      
      if p == -1 then
        sleep 0.8 * speed
        sleep 0.6 * speed
      elsif p == 0 then
      elsif p == 1 then
        play s.choose, amp: 0.6
      elsif p == 2
        play s.choose, amp: 0.6
        sleep 0.1 * speed
        play s.choose, amp: 0.8
      elsif p == 3
        k = s.choose
        d = [-1,0,1].choose
        play k, amp: 1.0
        sleep 0.8 * speed / 3
        play k+d, amp: 0.4
        sleep 0.8 * speed / 3
        play k+d+d, amp: 0.6
      elsif p == 4
        play s.choose, sustain: 0.2 * speed, amp: 0.4
        sleep 0.2 * speed
        with_fx :tremolo, depth: 0.9, phase: 0.1, wave: 3 do
          play s.choose, sustain: 0.1 * speed, amp: 0.4
        end
      elsif p == 5
        with_fx :tremolo, depth: 0.9, phase: 0.2, wave: 3 do
          play s.choose, sustain: 0.6 * speed, amp: 0.4
          sleep 0.8 * speed
        end
      end
    end
  end
end

live_loop :chords do
  sync :bar
  c = blues[i]
  with_synth :piano do
    if (i+1) % blues.length == 0 then
      play chords[c]
    elsif (i+1) % 4 == 0 then
      play chords[c]
      sleep 0.4 * speed
      play chords[c]
    else
      play chords[c]
      sleep 0.4 * speed
      play chords[c]
      sleep 0.2 * speed
      play chords[c]
    end
  end
end

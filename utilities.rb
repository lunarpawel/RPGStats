def roll_k6 (dice)
  count = 0
  i = 0
  while i < dice do
    if [1,2,3,4,5,6].sample == 1 then count += 1 end
    i += 1
  end
  count
end
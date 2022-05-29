(1..3).each() do |_|
    print("what is your name? ")
    name = gets().chomp()

    case name
    when "Ray"
        puts("hmmm vilager")
    when "ettol"
        puts("hmmm drawer")
    else
        puts("hmmm fuck u")
    end
end
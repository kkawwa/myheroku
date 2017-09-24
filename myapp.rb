require 'sinatra'
require "sinatra/reloader" if development?


#class String
	def complement(st)
		new_st = ""

		for i in 0...st.size
			case st[i]
			when "a"
				new_st += "t"
			when "t"
				new_st += "a"
			when "g"
				new_st += "c"
			when "c"
				new_st += "g"
			when "A"
				new_st += "T"
			when "T"
				new_st += "A"
			when "G"
				new_st += "C"
			when "C"
				new_st += "G"
			else
				new_st += st[i]
			end
		end

		new_st.reverse!
	end
#end


 
get '/' do
	erb :index
end

get '/na_comp' do
	erb :na_comp
end


post '/na_comp' do
	#@na = params[:na].complement
	@na = complement(params[:na])
	erb :na_comp
end









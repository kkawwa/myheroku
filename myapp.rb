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


def translate(st)
	st.upcase!
	arr_aa = ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y", "*"]
	arr_na = [["GCT", "GCC", "GCA", "GCG"], ["TGT", "TGC"], ["GAT", "GAC"], ["GAA", "GAG"], ["TTT", "TTC"], ["GGT", "GGC", "GGA", "GGG"], ["CAT", "CAC"], ["ATT", "ATC", "ATA"], ["AAA", "AAG"], ["TTA", "TTG", "CTT", "CTC", "CTA", "CTG"], ["ATG"], ["AAT", "AAC"], ["CCT", "CCC", "CCA", "CCG"], ["CAA", "CAG"], ["CGT", "CGC", "CGA", "CGG", "AGA", "AGG"], ["TCT", "TCC", "TCA", "TCG", "AGT", "AGC"], ["ACT", "ACC", "ACA", "ACG"], ["GTT", "GTC", "GTA", "GTG"], ["TGG"], ["TAT", "TAC"], ["TAG", "TGA", "TAA"]]


	aa = ""

	for i in 0..(st.size - 1)
		next if i%3 != 0

		cut_3 = st[i..(i + 2)]

		for j in 0..(arr_na.size - 1)
			for k in 0..(arr_na[j].size - 1)
				if arr_na[j][k] == cut_3
					aa << arr_aa[j]
				end
			end
		end

	end

	return aa

end


error do |e|
  status 500
  # これでもできるけど
  #body env['sinatra.error'].message
  # これでもよい
  body e.message
end


 
get '/' do
	erb :index
end

get '/na_comp' do
	erb :na_comp
end

get '/aa_trans' do
	erb :aa_trans
end


post '/na_comp' do
	@na = params[:na]
	@comp_na = complement(params[:na])
	erb :na_comp
end

post '/aa_trans' do
	@na = params[:na]
	@trans_na = translate(params[:na])
	erb :aa_trans
end







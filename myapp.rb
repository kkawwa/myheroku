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
	st.upcase!.gsub("\n","").gsub(" ","")
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

def bunshi_calc(st)
	arr_aa = ["A", "C", "D", "E", "F", "G", "H", "I", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "Y", "*"]
	arr_ryou = [89.09,121.16,133.10,147.13,165.19,75.07,155.15,131.17,146.19,131.17,149.21,132.12,115.13,146.15,174.20,105.09,119.12,117.15,204.23,181.19]

	sum = 0.0

	for i in 0...st.size
		break if st[i] == "*"
		sum += arr_ryou[arr_aa.index(st[i])]
	end

	return sum -= 18.0*(i - 1)
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

get '/pcr_sosei' do
	erb :pcr_sosei
end


post '/na_comp' do
	@na = params[:na]
	@comp_na = complement(params[:na])
	erb :na_comp
end

post '/aa_trans' do
	@na = params[:na]
	@trans_na = translate(params[:na])
	@bunshiryou = bunshi_calc(@trans_na)
	erb :aa_trans
end

def pcr_calc(st,per_sosei,one_sample)
	st/per_sosei*one_sample
end

get '/r' do
	
	@one_sample = 25
	@sample_su = 1
	@temp_ryou = 1
	@per_sosei = 100
	@buffer = 10
	@dNTPs = 8
	@magnesium = 6
	@sonota = 0
	@primer_f = 2
	@primer_r = 2
	@kouso = 1

	erb :kind_pcr_sosei
end

get '/ex' do
	
	@one_sample = 25
	@sample_su = 1
	@temp_ryou = 1
	@per_sosei = 100
	@buffer = 10
	@dNTPs = 8
	@magnesium = 0
	@sonota = 0
	@primer_f = 2
	@primer_r = 2
	@kouso = 0.125

	erb :kind_pcr_sosei
end

get '/ps' do
	
	@one_sample = 25
	@sample_su = 1
	@temp_ryou = 1
	@per_sosei = 100
	@buffer = 20
	@dNTPs = 8
	@magnesium = 0
	@sonota = 0
	@primer_f = 2
	@primer_r = 2
	@kouso = 0.25

	erb :kind_pcr_sosei
end

get '/kod' do
	
	@one_sample = 25
	@sample_su = 1
	@temp_ryou = 1
	@per_sosei = 50
	@buffer = 5
	@dNTPs = 5
	@magnesium = 3
	@sonota = 0
	@primer_f = 1.5
	@primer_r = 1.5
	@kouso = 1

	erb :kind_pcr_sosei
end




post '/result_pcr_sosei' do

	@one_sample = params[:one_sample].to_f
	@sample_su = params[:sample_su].to_f
	@temp_ryou = params[:temp_ryou].to_f
	@per_sosei = params[:per_sosei].to_f
	@buffer = params[:buffer].to_f
	@dNTPs = params[:dNTPs].to_f
	@magnesium = params[:magnesium].to_f
	@sonota = params[:sonota].to_f
	@primer_f = params[:primer_f].to_f
	@primer_r = params[:primer_r].to_f
	@kouso = params[:kouso].to_f

	@calc_buffer = pcr_calc(@buffer,@per_sosei,@one_sample)
	@calc_dNTPs = pcr_calc(@dNTPs,@per_sosei,@one_sample)
	@calc_magnesium = pcr_calc(@magnesium,@per_sosei,@one_sample)
	@calc_sonota = pcr_calc(@sonota,@per_sosei,@one_sample)
	@calc_primer_f = pcr_calc(@primer_f,@per_sosei,@one_sample)
	@calc_primer_r = pcr_calc(@primer_r,@per_sosei,@one_sample)
	@calc_kouso = pcr_calc(@kouso,@per_sosei,@one_sample)

	@water = @one_sample - @calc_buffer - @calc_dNTPs - @calc_magnesium - @calc_sonota - @calc_primer_f - @calc_primer_r - @calc_kouso - @temp_ryou

	erb :result_pcr_sosei
end









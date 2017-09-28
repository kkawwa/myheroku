require 'sinatra'
require "sinatra/reloader" if development?


#class String
	def complement(st)
		#arr_atgc = ["A","T","G","C"]

		new_st = ""
		for i in 0...st.size
			if st[i] =~ /\w/
				new_st += st[i]
			end
		end
		st = new_st


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

		[st,new_st.reverse!]
	end
#end


def translate(st)
	st.upcase!

	arr_atgc = ["A","T","G","C"]

	new_st = ""
	for i in 0...st.size
		if arr_atgc.include?(st[i])
			new_st += st[i]
		end
	end
	st = new_st

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

	return [st,aa]

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
	@file_data_i = 0
	File.open('db_text/count.text') do |file|
		file.each_line do |labmen|
			@file_data_i = labmen.to_i
	    end
	end

	File.open("db_text/count.text", "w") do |f| 
	  f.puts(@file_data_i += 1)
	end

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


get '/eurofin_calc' do
	@hani_temp_ryou = "範囲 ? ng"
	@aim_temp_ryou = ""
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_plasmid' do
	@hani_temp_ryou = "範囲 450-900 ng"
	@aim_temp_ryou = 900
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_150_200' do
	@hani_temp_ryou = "範囲 3-9 ng"
	@aim_temp_ryou = 9
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_200_500' do
	@hani_temp_ryou = "範囲 9-30 ng"
	@aim_temp_ryou = 30
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_500_1000' do
	@hani_temp_ryou = "範囲 15-60 ng"
	@aim_temp_ryou = 60
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_1000_2000' do
	@hani_temp_ryou = "範囲 30-120 ng"
	@aim_temp_ryou = 120
	@now_primer_noudo = 100

	erb :eurofin_calc
end

get '/e_2000' do
	@hani_temp_ryou = "範囲 60-150 ng"
	@aim_temp_ryou = 150
	@now_primer_noudo = 100

	erb :eurofin_calc
end

post '/result_eurofin_calc' do
	@hani_temp_ryou = @hani_temp_ryou
	@hani_temp_ryou = params[:hani_temp_ryou]
	@now_temp_noudo = params[:now_temp_noudo]
	@aim_temp_ryou = params[:aim_temp_ryou]
	@now_primer_noudo = params[:now_primer_noudo]

	arr_temp_noud = params[:now_temp_noudo].split(",")
	arr_temp = params[:now_temp_noudo].split(",").map { |e| params[:aim_temp_ryou].to_f/e.to_f }# params[:aim_temp_ryou].to_f/params[:now_temp_noudo].to_f
	@primer = 9.6*21.0/params[:now_primer_noudo].to_f
#9.6*21 = 100*x

	@arr_result_temp_water = [["現在の鋳型の濃度 (ng/μl)","鋳型の量 (μl)", "プライマーの量 (μl)", "水の量 (μl)"]]
	n = 0
	arr_temp.each do |a|
		@arr_result_temp_water << [arr_temp_noud[n], a.round(3), @primer.round(3), (21.0 - a - @primer).round(3)]
		n += 1
	end

	erb :result_eurofin_calc
end



post '/na_comp' do
	@na = complement(params[:na])[0]
	@comp_na = complement(params[:na])[1]
	erb :na_comp
end

post '/aa_trans' do
	@na = translate(params[:na])[0]
	@trans_na = translate(params[:na])[1]
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









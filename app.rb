#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	@title = 'Barber Shop'
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/about' do
	@title = 'О нас'
	@error = 'Something wrong!TEST'
	erb :about
end

get '/visit' do
	@title = 'Записаться'
	erb :visit
end

get '/contacts' do
	@title = 'Контакты'
	erb :contacts
end

get '/cabin' do
	@title = 'Кабинет'
	@subhead = 'Для входа введите свои данные'
	erb :cabin
end

post '/visit' do
	@title = 'Записаться'
	@username = params[:username]
	@phonenumber = params[:phonenumber]
	@datetime = params[:datetime]
	@master = params[:master]
	@colorpicker = params[:colorpicker]

	hh = {	:username => 'Не введено имя',
			:phonenumber => 'Не введен телефон',
			:datetime => 'Не указана дата визита',
			:master => 'Не выбран мастер'}

	# Решение №1, без суммирования значений хеша
	#	hh.each do |k,v|
	#		if params[k] == '' || params[k] == nil
	#			@error = hh[k]
	#			return erb :visit
	#		end			
	#	end

	# Решение №2, с суммированием значений хеша
	#	@error = hh.select {|k,v| params[k] == '' || params[k] == nil}.values.join(", ")
	#	if @error != '' # если @error не пустая вернуть erb, иначе код дальше
	#		return erb :visit
	#	end
	# Решение №3, (часть1/2), с суммированием значений хеша + вынос в отдельную функцию
	select_hash? hh
	if @error != ''
		return erb :visit
	end
	#	if select_hash? hh ///чет этот вариант работает не совсем как надо
	#		return erb :visit
	#	end
	#------------------------------------------------------------------------------------#

	@f = File.open './public/users.txt','a'
	@f.write "username: #{@username}; phonenumber: #{@phonenumber}; datetime: #{@datetime}; master: #{@master}; color: #{@colorpicker}\n"
	@f.close

	erb "Отлично #{@username}, мастер #{@master} ждет вас #{@datetime}.<br/>
	Вы выбрали покраситься в #{@colorpicker} цвет.<br/>
	За 3 часа до приема пришлем вам смс на номер #{@phonenumber}.<br/>
	До встречи!"
end

# Решение №3, (часть2/2), с суммированием значений хеша + вынос в отдельную функцию
def select_hash? hh
	@error = hh.select {|k,v| params[k] == '' || params[k] == nil}.values.join(", ")
end
#------------------------------------------------------------------------------------#

post '/contacts' do
	@title = 'Контакты'
	
	@email = params[:email]
	@usermessage = params[:usermessage]

	@f = File.open './public/contacts.txt','a'
	@f.write "e-mail: #{@email}; message: #{@usermessage}\n"
	@f.close

	erb :contacts
end

post '/cabin' do
	@title = 'Личный кабинет'
	@subhead = 'Для входа введите свои данные'
		
	@username = params[:username]
	@password = params[:password]

	if @username == '1' && @password == '1'
		@subhead = 'Статистика по клиентам'
	
		@f_users = File.open './public/users.txt','r'
		@f_contacts = File.open './public/contacts.txt','r'
		
		erb :stata
	else
		@subhead = 'Попробуйте еще раз'
		erb :cabin
	end
	
end
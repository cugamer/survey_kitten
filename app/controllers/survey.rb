#create
get '/surveys/new' do
  if logged_in?
    erb :'/surveys/new'
  else
    redirect '/'
  end
end

post '/surveys' do
  # Save information to db


  if saved
    redirect 'survey/:id'
  else
    # will need to feed a failure msg to the survey page
  end
end


#read
get '/surveys' do
  if logged_in?
    erb :'/surveys/index'
  else
    redirect '/'
  end
end

get '/surveys/:id' do
  # if logged_in?
    @survey_id = params[:id]

    @question_choices = Choice.where(question_id: Question.where(survey_id: @survey_id).first.id)
    erb :'/surveys/show'
  # else
  #   redirect '/'
  # end
end





#update



#delete



#---------------------------
# Survey submission methods

post '/responses' do
  p "submitted"
  answer = params[:choice_id]
  participation = params[:participation_no]
  Answer.create(participation_id: participation, choice_id: answer)
  erb :'/surveys/thank'
end
















#create
get '/surveys/new' do
  if logged_in?
    erb :'/surveys/new'
  else
    redirect '/'
  end
end

post '/surveys' do
# puts params #{"survey"=>{"title"=>"testsurvey", "questions"=>[{"text"=>"why?", "options"=>["because"]}]}}
# puts params[:survey] #{"title"=>"testsurvey", "questions"=>[{"text"=>"qwe", "options"=>["opop"]}]}
puts params[:survey][:questions] #{"text"=>"qwe", "options"=>["opop"]}



  @survey = Survey.new(creator_id: session[:user_id],
                       title: params[:survey][:title],
                       :filepath => params[:upload_image])

  if @survey.save!

    params[:survey][:questions].each do |question|
      @question = Question.new(survey_id: @survey.id,
                               text: question[:text],
                               filepath: question[:filepath])

      if @question.save!
        question[:options].each do |value|
          @choices = Choice.create(question_id: @question.id,
                                   option: value)
        end
      end
    end
  end

  redirect "surveys/#{@survey.id}"
end


#read
get '/surveys' do
  if logged_in?
    @surveys = Survey.all
    erb :'/surveys/index'
  else
    redirect '/'
  end
end

get '/surveys/:id' do
  # if logged_in?
    @survey = Survey.find(params[:id])
    @survey_id = params[:id]
    @question = []
    @choices = []
    Question.where(survey_id: @survey_id).each do |question|
      @question << question
      temp_choices = []
      Choice.where(question_id: question.id).each do |choice|
        temp_choices << choice
      end
      @choices << temp_choices
    end

    @survey_questions = Question.where(survey_id: @survey_id)
    erb :'/surveys/show'
end




get '/surveys/:survey_id/stats' do
  @survey = Survey.find(params[:survey_id])
  erb :'/surveys/stats'
end


#update



#delete

get '/surveys/delete/:id' do
  survey = Survey.find_by(id: params[:id], creator_id: session[:user_id])
  survey.destroy
  redirect "/users/#{session[:user_id]}"
end

#---------------------------
# Survey submission methods

post '/responses' do
  participation = Participation.create(taker_id: session[:user_id], survey_id: params[:survey_id])  # Get taker_id from user session
  if params[:answer] != nil
    params[:answer].each do |key, value|                                                          # Creates new answers for multiple choice.
      Answer.create(participation_id: participation.id, choice_id: params[:answer][key])
    end
  end
  if params[:text_answer] != nil
    params[:text_answer].each do |key, value|                                                     # Creates new answers for text entry.
      Answer.create(participation_id: participation.id, text_answer: params[:text_answer][key])
    end
  end

  participation = params[:participation_no]
  erb :'/surveys/thank'
end
















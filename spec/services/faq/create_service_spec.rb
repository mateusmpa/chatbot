require_relative './../../spec_helper.rb'

describe FaqModule::CreateService do
  before do
    @company = create(:company)

    @question = FFaker::Lorem.sentence
    @answer = FFaker::Lorem.sentence
    @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
  end

  describe '#call' do
    it 'Without hashtag params, will receive an error' do
      @create_service = FaqModule::CreateService.new({ 'question-original' => @question, 'answer-original' => @answer })

      response = @create_service.call()
      expect(response).to eq('Hashtag Obrigatória')
    end

    it 'With valid params, receive success message' do
      @create_service = FaqModule::CreateService.new({ 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })

      response = @create_service.call()
      expect(response).to eq('Criado com sucesso')
    end

    it 'With valid params, find question and answer in database' do
      @create_service = FaqModule::CreateService.new({ 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })

      response = @create_service.call()
      expect(Faq.last.question).to eq(@question)
      expect(Faq.last.answer).to eq(@answer)
    end

    it 'With valid params, hashtags are created' do
      @create_service = FaqModule::CreateService.new({ 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })

      response = @create_service.call()
      expect(@hashtags.split(/[\s,]+/).first).to eq(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to eq(Hashtag.last.name)
    end
  end
end

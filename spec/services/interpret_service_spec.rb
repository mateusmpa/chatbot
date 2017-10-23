require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it "With zero faqs, return don't find message" do
      response = InterpretService.call('list', {})
      expect(response).to eq('Nada encontrado')
    end

    it 'With two faqs, find questions and answers in response' do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = InterpretService.call('list', {})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search', { 'query' => '' })
      expect(reaponse).to eq('Nada encontrado')
    end

    it 'With valid query, find question and answer in response' do
      faq = create(:faq, company: @company)

      response = InterpretService.call('search', { 'query' => faq.question.split(' ').sample })

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by hashtag' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_by_hashtag', { 'query' => '' })
      expect(response).to eq('Nada encontrado')
    end

    it 'With valid hashtag, find question and answer in response' do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hastag, faq: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', { 'query' => hashtag.name })

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hastags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it 'Without hashtag params, receive an error' do
      response = InterpretService.call('create', { 'question-original' => @question, 'answer-original' => @answer })
      expect(response).to eq('Hashtag Obrigtória')
    end

    it 'With valid params, receive success message' do
      response = InterpretService.call('create', { 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })
      expect(response).to eq('Criado com sucesso')
    end

    it 'With valid params, find question and answer in database' do
      response = InterpretService.call('create', { 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })
      expect(Faq.last.question).to eq(@question)
      expect(Faq.last.answer).to eq(@answer)
    end

    it 'With valid params, hashtags are created' do
      response = InterpretService.call('create', { 'question-original' => @question, 'answer-original' => @answer, 'hashtags-original' => @hashtags })
      expect(@hashtags.split(/[\s,]+/).first).to eq(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to eq(Hashtag.last.name)
    end
  end

  describe '#remove' do
    it 'With valid ID, remove Faq' do
      faq = create(:faq, company: @company)
      response = InterpretService.call('remove', { 'id' => faq.id })
      expect(response).to eq('Deletado com sucesso')
    end

    it 'With invalid ID, receive error message' do
      response = InterpretService.call('remove', { 'id' => rand(1..9999) })
      expect(response).to eq('Questão inválida, verifique o ID')
    end
  end
end

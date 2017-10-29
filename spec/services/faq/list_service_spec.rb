require_relative './../../spec_helper.rb'

describe FaqModule::ListService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    it "with list command: With zero faqs, return don't find message" do
      @list_service = FaqModule::ListService.new({}, 'list')

      response = @list_service.call()
      expect(response).to eq('Nada encontrado')
    end

    it 'with list command: With two faqs, find questions and answers in response' do
      @list_service = FaqModule::ListService.new({}, 'list')

      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = @list_service.call()

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end

    it "with search command: With empty query, return don't find message" do
      @list_service = FaqModule::ListService.new({ 'query' => '' }, 'search')

      response = @list_service.call()
      expect(response).to eq('Nada encontrado')
    end

    it 'with search command: With valid query, find question ad answer in response' do
      faq = create(:faq, company: @company)

      @list_service = FaqModule::ListService.new({ 'query' => faq.question.split(' ').sample }, 'search')

      response = @list_service.call()

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end

    it "with search by hashtag command: With invalid hashtag, return don't find message" do
      @list_service = FaqModule::ListService.new({ 'query' => '' }, 'search_by_hashtag')

      response = @list_service.call()
      expect(response).to eq('Nada encontrado')
    end

    it 'with search by hashtago command: With valid hashtag, find question and answer in response' do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hashtag, faq: faq, hashtag: hashtag)

      @list_service = FaqModule::ListService.new({ 'query' => hashtag.name }, 'search_by_hashtag')

      response = @list_service.call()

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end
end

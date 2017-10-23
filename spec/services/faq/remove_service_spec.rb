require_relative './../../spec_helper.rb'

describe FaqModule::RemoveService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    it 'With valid ID, remove Faq' do
      faq = create(:faq, company: @company)
      @remove_service = FaqModule::RemoveService.new({ 'id' => faq.id })
      response = @remove_service.call()

      expect(response).to eq('Deletado com sucesso')
    end

    it 'With invalid ID, return error message' do
      @remove_service = FaqModule::RemoveService.new({ 'id' => rand(1..9999) })
      response = @remove_service.call()

      expect(response).to eq('Qestão inválida, verifique o ID')
    end

    it 'With valid ID, remove Faq from database' do
      faq = create(:faq, company: @company)
      @remove_service = FaqModule::RemoveService.new({ 'id' => faq.id })

      expect(Faq.all.count).to eq(1)
      response = @remove_service.call()
      expect(Faq.all.count).to eq(0)
    end
  end
end

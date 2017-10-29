module FaqModule
  class RemoveService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @params = params
      @id = params['id']
    end

    def call
      begin
        faq = @company.faqs.find(@id)
      rescue
        return 'Questão inválida, verifique o ID'
      end

      Faq.transaction do
        # Deleta as associações que não estão associadas a outros faqs
        faq.hashtags.each do |hashtag|
          if hashtag.faqs.count <=1
            hashtag.delete
          end
        end

        faq.delete
        'Deletado com sucesso'
      end
    end
  end
end
